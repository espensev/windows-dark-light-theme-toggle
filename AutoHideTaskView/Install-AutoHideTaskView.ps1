# AutoHide Task View v1.2  (2025-10-09)
# Author: espsev
# Purpose: Event-driven auto-hide of Task View button based on desktop count


# Install-AutoHideTaskView.ps1
# Copies AutoHide_TaskView.ps1 to a per-user folder and registers a per-user scheduled task to run it hidden at logon.
[CmdletBinding()]
param(
    [string]$InstallDir = "$env:LOCALAPPDATA\AutoHideTaskView",
    [string]$TaskName = "AutoHide Task View",
    [switch]$StartNow
)

$ErrorActionPreference = 'Stop'

# Resolve paths robustly inside the AutoHideTaskView folder
$baseDir = Split-Path -Parent $PSCommandPath
$sourceScript = Join-Path $baseDir 'AutoHide_TaskView.ps1'
if (-not (Test-Path $sourceScript)) { throw "AutoHide script not found: $sourceScript" }

# Ensure install dir
New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null

# Copy script
$destScript = Join-Path $InstallDir 'AutoHide_TaskView.ps1'
Copy-Item -Path $sourceScript -Destination $destScript -Force

# Prefer pwsh if available
$psExe = (Get-Command pwsh.exe -ErrorAction SilentlyContinue)?.Source
if (-not $psExe) { $psExe = Join-Path $env:WINDIR 'System32\WindowsPowerShell\v1.0\powershell.exe' }

$arguments = "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$destScript`""

try {
    $action   = New-ScheduledTaskAction -Execute $psExe -Argument $arguments
    $trigger  = New-ScheduledTaskTrigger -AtLogOn
    $settings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit (New-TimeSpan -Minutes 0) -DisallowStartIfOnBatteries:$false -AllowStartIfOnBatteries -MultipleInstances IgnoreNew
    Register-ScheduledTask -TaskName $TaskName -Action $action -Trigger $trigger -Settings $settings -Description 'Auto-hide Task View when only one desktop exists' -User $env:UserName -Force | Out-Null
}
catch {
    Write-Warning "Falling back to schtasks: $_"
    $tr = "$psExe -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$destScript`""
    & schtasks /Create /TN "$TaskName" /TR "$tr" /SC ONLOGON /RU "$env:USERNAME" /RL LIMITED /F | Out-Null
}

if ($StartNow) {
    try {
        Start-Process -FilePath $psExe -ArgumentList $arguments -WindowStyle Hidden | Out-Null
    } catch {
        Write-Warning "Could not start script immediately: $_"
    }
}

Write-Host "Installed AutoHide Task View to $InstallDir and registered Scheduled Task '$TaskName'."
