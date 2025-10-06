# Examples

This directory contains practical examples of how to use the Windows Dark/Light Theme Toggle utility in various scenarios.

## Basic Usage Examples

### Quick Toggle
```powershell
# Simple toggle - switches between current theme
.\DarkLightThemeToggle_V3\DarkLightThemeToggle_V3.ps1
```

### Force Specific Themes
```powershell
# Force dark theme
.\DarkLightThemeToggle_V3\DarkLightThemeToggle_V3.ps1 -Dark

# Force light theme  
.\DarkLightThemeToggle_V3\DarkLightThemeToggle_V3.ps1 -Light
```

## Automation Examples

### Task Scheduler Integration
Create a scheduled task to automatically switch themes at specific times:

**Morning (8 AM) - Switch to Light:**
```batch
powershell.exe -ExecutionPolicy Bypass -File "C:\path\to\DarkLightThemeToggle_V3.ps1" -Light -Quiet
```

**Evening (6 PM) - Switch to Dark:**
```batch
powershell.exe -ExecutionPolicy Bypass -File "C:\path\to\DarkLightThemeToggle_V3.ps1" -Dark -Quiet
```

### Batch Script Integration
```batch
@echo off
echo Switching to work mode (Light theme)...
powershell.exe -ExecutionPolicy Bypass -File "DarkLightThemeToggle_V3\DarkLightThemeToggle_V3.ps1" -Light -Quiet
if %ERRORLEVEL% EQU 1 (
    echo Successfully switched to Light theme
) else if %ERRORLEVEL% EQU 0 (
    echo Theme was already Light
) else (
    echo Error occurred during theme switch
)
```

### PowerShell Profile Integration
Add to your PowerShell profile (`$PROFILE`) for quick access:

```powershell
# Add this to your PowerShell profile
function Toggle-Theme {
    param([switch]$Light, [switch]$Dark)
    & "C:\path\to\DarkLightThemeToggle_V3.ps1" @PSBoundParameters
}

# Usage:
# Toggle-Theme        # Toggle current
# Toggle-Theme -Light # Force light
# Toggle-Theme -Dark  # Force dark
```

## Advanced Usage

### Get Detailed Information
```powershell
# Get comprehensive status information
$result = .\DarkLightThemeToggle_V3\DarkLightThemeToggle_V3.ps1 -PassThru
Write-Host "Current theme: $($result.Theme)"
Write-Host "Theme changed: $($result.Changed)"
Write-Host "Broadcast successful: $($result.BroadcastOk)"
```

### Conditional Theme Switching
```powershell
# Switch based on time of day
$hour = (Get-Date).Hour
if ($hour -lt 18 -and $hour -gt 6) {
    # Daytime - use light theme
    .\DarkLightThemeToggle_V3\DarkLightThemeToggle_V3.ps1 -Light -Quiet
} else {
    # Evening/night - use dark theme
    .\DarkLightThemeToggle_V3\DarkLightThemeToggle_V3.ps1 -Dark -Quiet
}
```

### Integration with Other Scripts
```powershell
# Example: Switch theme based on battery level
$battery = Get-WmiObject Win32_Battery
if ($battery.EstimatedChargeRemaining -lt 20) {
    # Low battery - switch to dark theme to save power
    .\DarkLightThemeToggle_V3\DarkLightThemeToggle_V3.ps1 -Dark -Quiet
    Write-Host "Switched to dark theme to conserve battery"
}
```

## Keyboard Shortcut Setup

### Using Windows Shortcuts
1. Right-click on `DarkLightThemeToggle.bat`
2. Select "Create shortcut"
3. Right-click the shortcut → Properties
4. Set "Shortcut key" (e.g., Ctrl+Alt+T)
5. Click OK

### Using PowerToys (Recommended)
If you have PowerToys installed:
1. Open PowerToys Run (Alt+Space)
2. Type "theme" to quickly access your script

## Silent Operation Examples

### Background Theme Switching
```powershell
# Perfect for startup scripts or background tasks
.\DarkLightThemeToggle_V3\DarkLightThemeToggle_V3.ps1 -Toggle -Quiet
```

### VBScript Silent Execution
For completely silent operation (no windows):
```vb
' Double-click ToggleTheme_V3.vbs for silent toggle
```

## Error Handling Examples

### Robust Script Integration
```powershell
try {
    $result = .\DarkLightThemeToggle_V3\DarkLightThemeToggle_V3.ps1 -Light -PassThru
    if ($result.BroadcastOk) {
        Write-Host "Theme switched successfully" -ForegroundColor Green
    } else {
        Write-Warning "Theme switched but some apps may not refresh immediately"
    }
} catch {
    Write-Error "Failed to switch theme: $_"
}
```