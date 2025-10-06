# Windows Dark/Light Theme Toggle

A comprehensive PowerShell utility collection for seamlessly toggling between Windows dark and light themes.

![Windows Theme Toggle](https://img.shields.io/badge/Windows-10%2F11-blue)
![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-blue)
![License](https://img.shields.io/badge/License-MIT-green)

## ✨ Features

- **🔄 Multiple implementations**: PowerShell scripts and VBScript versions
- **🎯 Flexible usage**: Toggle, force light, or force dark mode
- **⚙️ Registry integration**: Direct Windows registry manipulation for theme settings
- **📡 Broadcast notifications**: Notifies applications of theme changes instantly
- **🤖 Exit code support**: Perfect for automation and scripting workflows
- **🔇 Silent operation**: Quiet mode for background processes
- **📊 Detailed feedback**: PassThru mode returns comprehensive status information

## 📁 Files

### Version 3 (Latest)

- **`DarkLightThemeToggle_V3.ps1`**: Advanced PowerShell script with comprehensive features
- **`ToggleTheme_V3.vbs`**: VBScript companion

### Legacy Versions

- **`DarkLightThemeToggle_V2 - Copy.ps1`**: Previous PowerShell version
- **`DarkLightThemeToggle.bat`**: Batch file wrapper
- **`ToggleTheme.vbs`**: Original VBScript implementation

## Usage

### PowerShell Script (Recommended)

```powershell
# Toggle theme (default behavior)
.\DarkLightThemeToggle_V3\DarkLightThemeToggle_V3.ps1

# Force light theme
.\DarkLightThemeToggle_V3\DarkLightThemeToggle_V3.ps1 -Light

# Force dark theme
.\DarkLightThemeToggle_V3\DarkLightThemeToggle_V3.ps1 -Dark

# Toggle with quiet output
.\DarkLightThemeToggle_V3\DarkLightThemeToggle_V3.ps1 -Toggle -Quiet

# Get detailed information
.\DarkLightThemeToggle_V3\DarkLightThemeToggle_V3.ps1 -PassThru

# Use as automation (exit codes)
.\DarkLightThemeToggle_V3\DarkLightThemeToggle_V3.ps1 -AsExitCode
```

### Parameters

- **`-Light`**: Force light theme
- **`-Dark`**: Force dark theme  
- **`-Toggle`**: Toggle current theme (default if no other options specified)
- **`-Quiet`**: Suppress output messages
- **`-PassThru`**: Return detailed information object
- **`-AsExitCode`**: Map results to exit codes for automation

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