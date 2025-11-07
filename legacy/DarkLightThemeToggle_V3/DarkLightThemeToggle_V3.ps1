[CmdletBinding()]
param(

    [switch]$Light,      # Force light
    [switch]$Dark,       # Force dark
    [switch]$Toggle,     # Toggle current value (default if nothing specified)
    [switch]$Quiet,      # Suppress output
    [switch]$PassThru,   # Return an object
    [switch]$AsExitCode  # Map result to exit code (see mapping below)
)

function Set-WindowsTheme {
    [CmdletBinding()]
    param(
        [switch]$Light,
        [switch]$Dark,
        [switch]$Toggle,
        [switch]$Quiet,
        [switch]$PassThru,
        [switch]$AsExitCode
    )

    $regKeyPath = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize'
    $systemName = 'SystemUsesLightTheme'
    $appsName   = 'AppsUseLightTheme'

    # Ensure key exists (normally does, but cheap safeguard)
    if (-not (Test-Path $regKeyPath)) {
        try {
            New-Item -Path $regKeyPath -Force | Out-Null
        } catch {
            if ($AsExitCode) { exit 10 }
            throw "Failed to create registry key: $regKeyPath. $_"
        }
    }

    $currSystem = 0
    $currApps   = 0
    try { $currSystem = Get-ItemPropertyValue -Path $regKeyPath -Name $systemName -ErrorAction Stop } catch {}
    try { $currApps   = Get-ItemPropertyValue -Path $regKeyPath -Name $appsName   -ErrorAction Stop } catch {}

    # Decide new target
    if ($Light) {
        $newValue = 1
    } elseif ($Dark) {
        $newValue = 0
    } else {
        # Default to toggle if nothing explicit
        $newValue = if ($currSystem -eq 1) { 0 } else { 1 }
    }

    $changed = $currSystem -ne $newValue -or $currApps -ne $newValue

    try {
        Set-ItemProperty -Path $regKeyPath -Name $systemName -Value $newValue -Type DWord -Force
        Set-ItemProperty -Path $regKeyPath -Name $appsName   -Value $newValue -Type DWord -Force
    } catch {
        if ($AsExitCode) { exit 11 }
        throw "Failed writing theme values. $_"
    }

    # Add native method only once
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

    # Broadcast so some apps pick it up
    $HWND_BROADCAST   = [IntPtr]0xffff
    $WM_SETTINGCHANGE = 0x1a
    $SMTO_ABORTIFHUNG = 0x2
    $result = [UIntPtr]::Zero
    $broadcastOk = $true
    try {
        [void]([NativeMethods]::SendMessageTimeout(
            $HWND_BROADCAST,
            $WM_SETTINGCHANGE,
            [UIntPtr]::Zero,
            'ImmersiveColorSet',
            $SMTO_ABORTIFHUNG,
            5000,
            [ref]$result
        ))
    } catch {
        $broadcastOk = $false
        if (-not $Quiet) { Write-Warning "Broadcast failed: $_" }
    }

    $themeName = if ($newValue -eq 1) { 'Light' } else { 'Dark' }

    if (-not $Quiet) {
        $statusVerb = if ($changed) { 'Changed to' } else { 'Already' }
        Write-Host "$statusVerb $themeName theme." -ForegroundColor Cyan
    }

    $info = [pscustomobject]@{
        OldSystemValue = $currSystem
        NewValue       = $newValue
        Theme          = $themeName
        Changed        = $changed
        BroadcastOk    = $broadcastOk
    }

    if ($PassThru) {
        return $info
    }

    if ($AsExitCode) {
        # Exit code mapping:
        # 0 = Success (no change)
        # 1 = Changed to Light
        # 2 = Changed to Dark
        # 20 = Broadcast failed but registry ok
        # 10+ = earlier fatal errors (see code)
        $exitCode =
            if (-not $broadcastOk) { 20 }
            elseif (-not $changed) { 0 }
            elseif ($newValue -eq 1) { 1 } else { 2 }
        exit $exitCode
    }
}

# If script is executed directly (not dot-sourced), run once
if ($MyInvocation.InvocationName -ne '.') {
    Set-WindowsTheme @PSBoundParameters
}