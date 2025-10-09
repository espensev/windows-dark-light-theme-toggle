# AutoHide Task View v1.2  (2025-10-09)
# Author: espsev
# Purpose: Event-driven auto-hide of Task View button based on desktop count
# AutoHide_TaskView.ps1 (event-driven with fallback)
# Hide Task View button when only one virtual desktop exists; show it when more are open.

# Single-instance guard (named mutex)
$script:_mutex = $null
try {
    $created = $false
    $script:_mutex = New-Object System.Threading.Mutex($false, 'Global\AutoHideTaskView', [ref]$created)
    if (-not $created) {
        Write-Verbose 'Another instance is already running. Exiting.'
        return
    }
} catch {
    Write-Verbose "Mutex creation failed (continuing without guard): $_"
}

# Stop-event (named, manual reset) to honor uninstaller signal
try {
    $createdStop = $false
    $script:_stopEvent = New-Object System.Threading.EventWaitHandle($false, ([System.Threading.EventResetMode]::ManualReset), 'Local\AutoHideTaskView-Stop', [ref]$createdStop)
    # Ensure non-signaled at startup so a previous uninstall doesn't block a fresh run
    [void]$script:_stopEvent.Reset()
} catch {
    Write-Verbose "Stop event setup failed: $_"
}

# P/Invoke for a gentle Explorer refresh
if (-not ([System.Management.Automation.PSTypeName]'NativeMethods').Type) {
    Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public static class NativeMethods {
    [DllImport("user32.dll", SetLastError=true, CharSet=CharSet.Unicode)]
    public static extern IntPtr SendMessageTimeout(
        IntPtr hWnd,
        uint Msg,
        UIntPtr wParam,
        string lParam,
        uint fuFlags,
        uint uTimeout,
        out UIntPtr lpdwResult);
}
"@
}

function Get-VirtualDesktopRegPath {
    $sessionId = (Get-Process -Id $PID).SessionId
    $perSession = "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\SessionInfo\\$sessionId\\VirtualDesktops"
    $base       = "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\VirtualDesktops"
    if (Test-Path $perSession) { return $perSession }
    if (Test-Path $base)       { return $base }
    return $null
}

function Get-DesktopCount {
    $path = Get-VirtualDesktopRegPath
    if (-not $path) { return 1 }
    try {
        $bytes = (Get-ItemProperty -Path $path -Name VirtualDesktopIDs -ErrorAction Stop).VirtualDesktopIDs
        if ($bytes -is [byte[]] -and $bytes.Length -ge 16) {
            return [Math]::Max(1, [int]($bytes.Length / 16))
        }
    } catch { }
    return 1
}

function Refresh-Taskbar {
    # Notify Explorer about taskbar setting changes (avoids killing Explorer)
    $HWND_BROADCAST   = [IntPtr]0xffff
    $WM_SETTINGCHANGE = 0x1a
    $SMTO_ABORTIFHUNG = 0x2
    $result = [UIntPtr]::Zero
    try {
        $ret = [NativeMethods]::SendMessageTimeout(
            $HWND_BROADCAST,
            $WM_SETTINGCHANGE,
            [UIntPtr]::Zero,
            'TraySettings',
            $SMTO_ABORTIFHUNG,
            3000,
            [ref]$result
        )
        if ($ret -eq [IntPtr]::Zero) {
            $err = [System.Runtime.InteropServices.Marshal]::GetLastWin32Error()
            Write-Verbose "SendMessageTimeout failed. Win32Error=$err"
            Start-Process explorer.exe -ArgumentList '/restart' -WindowStyle Hidden
        }
    } catch {
        Write-Verbose "SendMessageTimeout threw: $_"
        Start-Process explorer.exe -ArgumentList '/restart' -WindowStyle Hidden
    }
}

function Set-TaskViewButton {
    param([int]$Show)
    $key = "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced"
    try {
        $curr = (Get-ItemProperty -Path $key -Name ShowTaskViewButton -ErrorAction SilentlyContinue).ShowTaskViewButton
    } catch { $curr = $null }
    if ($curr -ne $Show) {
        New-Item -Path $key -Force | Out-Null
        Set-ItemProperty -Path $key -Name ShowTaskViewButton -Value $Show -Type DWord -Force | Out-Null
        Refresh-Taskbar
    }
}

function Update-TaskViewFromCount {
    $count = Get-DesktopCount
    Set-TaskViewButton -Show ($(if ($count -le 1) { 0 } else { 1 }))
}

function Register-VirtualDesktopWatchers {
    # WMI RegistryValueChangeEvent supports HKEY_USERS and HKLM only.
    $sid = [System.Security.Principal.WindowsIdentity]::GetCurrent().User.Value
    $sessionId = (Get-Process -Id $PID).SessionId

    $keyBase = "$sid\Software\Microsoft\Windows\CurrentVersion\Explorer\VirtualDesktops"
    $keySess = "$sid\Software\Microsoft\Windows\CurrentVersion\Explorer\SessionInfo\$sessionId\VirtualDesktops"

    $kBaseEsc = $keyBase.Replace('\\','\\\\')
    $kSessEsc = $keySess.Replace('\\','\\\\')

    $qBase = "SELECT * FROM RegistryValueChangeEvent WHERE Hive='HKEY_USERS' AND KeyPath='$kBaseEsc' AND ValueName='VirtualDesktopIDs'"
    $qSess = "SELECT * FROM RegistryValueChangeEvent WHERE Hive='HKEY_USERS' AND KeyPath='$kSessEsc' AND ValueName='VirtualDesktopIDs'"

    $subs = @()
    try { $subs += Register-WmiEvent -Namespace root\default -Query $qBase -SourceIdentifier 'VDIDs-Base' } catch { }
    try { $subs += Register-WmiEvent -Namespace root\default -Query $qSess -SourceIdentifier 'VDIDs-Session' } catch { }
    return $subs | Where-Object { $_ }
}

try {
    # Register watchers first and apply current state
    $subscriptions = Register-VirtualDesktopWatchers
    Update-TaskViewFromCount

    $useWatchers = ($subscriptions -and $subscriptions.Count -gt 0)
    while ($true) {
        # Check stop signal
        if ($script:_stopEvent -and $script:_stopEvent.WaitOne(0)) { break }

        if ($useWatchers) {
            # Wait for an event or timeout, then coalesce and update
            $ev = Wait-Event -SourceIdentifier VDIDs-Base,VDIDs-Session -Timeout 30
            if ($ev) {
                do { Remove-Event -EventIdentifier $ev.EventIdentifier; $ev = Get-Event -SourceIdentifier VDIDs-Base,VDIDs-Session -ErrorAction SilentlyContinue } while ($ev)
                Update-TaskViewFromCount
            } else {
                # Periodic sanity refresh
                Update-TaskViewFromCount
            }
        }
        else {
            # Polling fallback with stop check
            Update-TaskViewFromCount
            Start-Sleep -Seconds 3
        }
    }
}
finally {
    foreach ($s in @($subscriptions)) {
        if ($s) { Unregister-Event -SourceIdentifier $s.SourceIdentifier -ErrorAction SilentlyContinue }
    }
    Get-Event -ErrorAction SilentlyContinue | Remove-Event -ErrorAction SilentlyContinue
    if ($script:_mutex) {
        try { $script:_mutex.ReleaseMutex() } catch {}
        try { $script:_mutex.Dispose() } catch {}
    }
}
