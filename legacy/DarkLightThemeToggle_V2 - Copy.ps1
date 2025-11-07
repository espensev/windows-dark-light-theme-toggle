[CmdletBinding()]
param(

    [switch]$Toggle,   # Toggle current value (default if nothing specified)
    [switch]$Light,    # Force light
    [switch]$Dark,     # Force dark
    [switch]$Quiet     # Suppress output
  
)

$regKeyPath = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize'
$systemName = 'SystemUsesLightTheme'
$appsName   = 'AppsUseLightTheme'

# Ensure key exists (normally does, but cheap safeguard)
if (-not (Test-Path $regKeyPath)) {
    New-Item -Path $regKeyPath -Force | Out-Null
}

$currSystem = 0
$currApps   = 0
try { $currSystem = (Get-ItemPropertyValue -Path $regKeyPath -Name $systemName -ErrorAction Stop) } catch {}
try { $currApps   = (Get-ItemPropertyValue -Path $regKeyPath -Name $appsName   -ErrorAction Stop) } catch {}

# Decide target
if ($Light) {
    $newValue = 1
} elseif ($Dark) {
    $newValue = 0
} else {
    # Default behavior: toggle
    $newValue = if ($currSystem -eq 1) { 0 } else { 1 }
}

# Only write if changed (both usually same, but check)
if ($currSystem -ne $newValue) {
    Set-ItemProperty -Path $regKeyPath -Name $systemName -Value $newValue -Type DWord -Force
}
if ($currApps -ne $newValue) {
    Set-ItemProperty -Path $regKeyPath -Name $appsName -Value $newValue -Type DWord -Force
}

# Add native method only once per session
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

# Broadcast setting change so some apps refresh without logoff
$HWND_BROADCAST   = [IntPtr]0xffff
$WM_SETTINGCHANGE = 0x1a
$SMTO_ABORTIFHUNG = 0x2
$result = [UIntPtr]::Zero
[void]([NativeMethods]::SendMessageTimeout(
    $HWND_BROADCAST,
    $WM_SETTINGCHANGE,
    [UIntPtr]::Zero,
    'ImmersiveColorSet',
    $SMTO_ABORTIFHUNG,
    5000,
    [ref]$result
))

if (-not $Quiet) {
   Write-Host "Theme set to $($newValue ? 'Light' : 'Dark')" -ForegroundColor Cyan

}

exit ($newValue)
