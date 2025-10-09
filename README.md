# Windows Customization Toolkit

A comprehensive collection of PowerShell utilities for Windows UI customization and automation.

![Windows Theme Toggle](https://img.shields.io/badge/Windows-10%2F11-blue)
![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-blue)
![License](https://img.shields.io/badge/License-MIT-green)

## 🛠️ **Utilities Included**

### 🌓 **Dark/Light Theme Toggle**

Seamlessly switch between Windows dark and light themes with advanced automation features.

### 👁️ **AutoHide Task View** *(New!)*

Intelligently hide the Task View button when only one virtual desktop exists, show it when multiple desktops are in use.

## ✨ Features

- **🔄 Multiple implementations**: PowerShell scripts and VBScript versions
- **🎯 Flexible usage**: Toggle, force light, or force dark mode
- **⚙️ Registry integration**: Direct Windows registry manipulation for theme settings
- **📡 Broadcast notifications**: Notifies applications of theme changes instantly
- **🤖 Exit code support**: Perfect for automation and scripting workflows
- **🔇 Silent operation**: Quiet mode for background processes
- **📊 Detailed feedback**: PassThru mode returns comprehensive status information

## 📁 Files

### 🌓 Dark/Light Theme Toggle

#### Version 3 (Latest)

- **`DarkLightThemeToggle_V3.ps1`**: Advanced PowerShell script with comprehensive features
- **`ToggleTheme_V3.vbs`**: VBScript companion

#### Legacy Versions

- **`DarkLightThemeToggle_V2 - Copy.ps1`**: Previous PowerShell version
- **`DarkLightThemeToggle.bat`**: Batch file wrapper
- **`ToggleTheme.vbs`**: Original VBScript implementation

### 👁️ AutoHide Task View

- **`AutoHide_TaskView.ps1`**: Main event-driven script
- **`Install-AutoHideTaskView.ps1`**: Automated installer with scheduled task
- **`Uninstall-AutoHideTaskView.ps1`**: Clean removal utility
- **`Add-StartupShortcut.ps1`**: Alternative startup method

## 🚀 Usage

### 🌓 **Dark/Light Theme Toggle**

```powershell
# Toggle theme (default behavior)
.\DarkLightThemeToggle_V3\DarkLightThemeToggle_V3.ps1

# Force light theme
.\DarkLightThemeToggle_V3\DarkLightThemeToggle_V3.ps1 -Light

# Force dark theme
.\DarkLightThemeToggle_V3\DarkLightThemeToggle_V3.ps1 -Dark

# Toggle with quiet output
.\DarkLightThemeToggle_V3\DarkLightThemeToggle_V3.ps1 -Toggle -Quiet
```

### 👁️ **AutoHide Task View**

```powershell
# Install with scheduled task (recommended)
.\AutoHideTaskView\Install-AutoHideTaskView.ps1 -StartNow

# Run manually for testing
.\AutoHideTaskView\AutoHide_TaskView.ps1

# Uninstall completely
.\AutoHideTaskView\Uninstall-AutoHideTaskView.ps1
```

## 📋 Parameters

### 🌓 Dark/Light Theme Toggle Parameters

- **`-Light`**: Force light theme
- **`-Dark`**: Force dark theme  
- **`-Toggle`**: Toggle current theme (default if no other options specified)
- **`-Quiet`**: Suppress output messages
- **`-PassThru`**: Return detailed information object
- **`-AsExitCode`**: Map results to exit codes for automation

### 👁️ AutoHide Task View Parameters

#### Install-AutoHideTaskView.ps1
- **`-InstallDir`**: Custom installation directory (default: `%LOCALAPPDATA%\AutoHideTaskView`)
- **`-TaskName`**: Custom scheduled task name (default: "AutoHide Task View")
- **`-StartNow`**: Start the service immediately after installation

### Exit Codes (when using -AsExitCode)

- **0**: Success, no change needed
- **1**: Changed to Light theme
- **2**: Changed to Dark theme
- **10**: Failed to create registry key
- **11**: Failed to write theme values
- **20**: Registry updated but broadcast notification failed

## Requirements

- Windows 10/11
- PowerShell 5.1 or later (for PowerShell scripts)
- Administrator privileges may be required for some operations

## How It Works

The script modifies Windows registry values in:

```registry
HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize
```

Specifically:

- **`SystemUsesLightTheme`**: Controls system theme (taskbar, etc.)
- **`AppsUseLightTheme`**: Controls app theme

After updating the registry, it broadcasts a `WM_SETTINGCHANGE` message to notify applications of the theme change.

## Installation

1. Download or clone this repository
2. Run the PowerShell script directly, or
3. Create a shortcut using the provided `.lnk` file
4. Optionally, add to your PATH for system-wide access

## Contributing

Feel free to submit issues, feature requests, or pull requests to improve this tool.

## License

This project is provided as-is for educational and personal use.