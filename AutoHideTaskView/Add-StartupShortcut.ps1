# Add-StartupShortcut.ps1
# Adds a Startup-folder shortcut that starts AutoHide_TaskView.ps1 hidden.
[CmdletBinding()]
param(
    [string]$InstallDir = "$env:LOCALAPPDATA\AutoHideTaskView",
    [string]$ShortcutName = "AutoHide Task View.lnk"
)

$scriptPath = Join-Path $InstallDir 'AutoHide_TaskView.ps1'
if (-not (Test-Path $scriptPath)) {
    throw "AutoHide_TaskView.ps1 not found in $InstallDir. Run Install-AutoHideTaskView.ps1 first or adjust -InstallDir."
}

$startup = Join-Path $env:APPDATA 'Microsoft\Windows\Start Menu\Programs\Startup'
$lnkPath = Join-Path $startup $ShortcutName

$psExe = (Get-Command pwsh.exe -ErrorAction SilentlyContinue)?.Source
if (-not $psExe) { $psExe = Join-Path $env:WINDIR 'System32\WindowsPowerShell\v1.0\powershell.exe' }

$ws = New-Object -ComObject WScript.Shell
$sc = $ws.CreateShortcut($lnkPath)
$sc.TargetPath = $psExe
$sc.Arguments  = "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$scriptPath`""
$sc.WorkingDirectory = $InstallDir
$sc.WindowStyle = 7  # Minimized (hidden by -WindowStyle)
$sc.IconLocation = "$psExe,0"
$sc.Save()

Write-Host "Startup shortcut created: $lnkPath"
