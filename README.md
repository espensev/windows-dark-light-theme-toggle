# Windows Customization Toolkit

Professional utilities for Windows UI customization and automation.

![Windows Theme Toggle](https://img.shields.io/badge/Windows-10%2F11-blue)
![C++17](https://img.shields.io/badge/C%2B%2B-17-blue)
![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-blue)
![License](https://img.shields.io/badge/License-MIT-green)

## 🛠️ **Utilities Included**

### ⚡ **Windows Theme Toggler V4** *(Current Release)*

Ultra-fast, production-grade Windows 10/11 Light/Dark theme switcher with **native C++ performance**.

**⚡ 45-500x faster** than PowerShell implementations • **Zero dependencies** • **~110ms theme switching**

### 👁️ **AutoHide Task View**

Intelligently hide the Task View button when only one virtual desktop exists, show it when multiple desktops are in use.

## ✨ V4 Features

- **⚡ Blazing Fast**: ~5-10ms when no change needed, ~110ms when toggling
- **🏭 Production Ready**: Enterprise-grade error handling and reliability
- **📦 Zero Dependencies**: Single standalone executable (~220 KB)
- **🎯 Flexible usage**: Toggle, force light, or force dark mode
- **⚙️ Native C++17**: RAII-based resource management, type-safe
- **📡 Dual Broadcast**: Instant taskbar updates with optimized notifications
- **🔇 Silent operation**: VBS/PowerShell wrappers for background execution
- **🤖 Exit code support**: Perfect for automation and scripting workflows
- **�️ Pipe-Safe**: Smart detection of redirected output

## 📁 Repository Structure

### ⚡ **Windows Theme Toggler V4** (Current Release)
📂 `ThemeToggle/`

- **`ThemeToggle.exe`**: Native C++ executable (production-ready)
- **`ThemeToggle.vbs`**: Silent toggle launcher (no console)
- **`ThemeToggle-Light.vbs`**: Force light mode silently
- **`ThemeToggle-Dark.vbs`**: Force dark mode silently
- **`ThemeToggle.ps1`**: PowerShell wrapper alternative
- **`build.bat`**: Build script (requires Visual Studio)
- **`main.cpp`**: Source code
- **`README.md`**: Complete V4 documentation
- **`AUTOMATION_GUIDE.md`**: Hotkeys, scheduled tasks, integrations
- **`RELEASE_NOTES.md`**: V4 improvements and benchmarks

### 👁️ **AutoHide Task View**
📂 `AutoHideTaskView/`

- **`AutoHide_TaskView.ps1`**: Main event-driven script
- **`Install-AutoHideTaskView.ps1`**: Automated installer with scheduled task
- **`Uninstall-AutoHideTaskView.ps1`**: Clean removal utility
- **`Add-StartupShortcut.ps1`**: Alternative startup method
- **`README.md`**: Complete documentation

### 📜 **Legacy Versions** (Reference Only)
📂 `legacy/`

- **V3**: PowerShell with enhanced features (superseded by V4)
- **V2**: Original PowerShell implementation
- **V4 nested copy**: Old location kept for reference
- See `legacy/README.md` for migration guide

## 🚀 Quick Start

### ⭐ **Easiest: Download Pre-built Release**

**[📥 Download ThemeToggle v4.1.0](releases/v4.1.0/ThemeToggle-v4.1.0.zip)** (125 KB)

Extract and double-click `ThemeToggle.vbs` to toggle instantly!

---

### ⚡ **Windows Theme Toggler V4** (For Developers/Building from Source)

#### Direct Execution (Shows Console)
```cmd
# Navigate to ThemeToggle directory
cd ThemeToggle

# Toggle current theme (default)
ThemeToggle.exe

# Force light theme
ThemeToggle.exe /light

# Force dark theme
ThemeToggle.exe /dark

# Silent mode
ThemeToggle.exe /quiet
```

#### Silent Execution (No Console - Perfect for Hotkeys!)
```vbscript
# Double-click these VBS files for silent operation:
ThemeToggle.vbs         # Toggle
ThemeToggle-Light.vbs   # Force light
ThemeToggle-Dark.vbs    # Force dark
```

#### PowerShell Alternative
```powershell
.\ThemeToggle.ps1           # Toggle
.\ThemeToggle.ps1 -Light    # Force light
.\ThemeToggle.ps1 -Dark     # Force dark
```

**📖 Full automation guide**: See `ThemeToggle/AUTOMATION_GUIDE.md` for hotkey setup, scheduled tasks, Stream Deck integration, and more!

### 👁️ **AutoHide Task View**

```powershell
# Install with scheduled task (recommended)
.\AutoHideTaskView\Install-AutoHideTaskView.ps1 -StartNow

# Run manually for testing
.\AutoHideTaskView\AutoHide_TaskView.ps1

# Uninstall completely
.\AutoHideTaskView\Uninstall-AutoHideTaskView.ps1
```

## 📋 Parameters & Options

### ⚡ Windows Theme Toggler V4

#### Command Line Arguments
- **`/light`**: Force light theme
- **`/dark`**: Force dark theme  
- **`/toggle`**: Toggle current theme (default if no arguments)
- **`/quiet`**: Suppress output messages
- **`/passthru`**: Return detailed information
- **`/exitcode`**: Map results to exit codes for automation

#### Exit Codes (with `/exitcode`)
- **0**: Success, no change needed
- **1**: Changed to Light theme
- **2**: Changed to Dark theme
- **10**: Registry key access failed
- **11**: Registry write failed
- **20**: Broadcast failed (but theme changed)

**Example:**
```powershell
# Check result in script
.\ThemeToggle.exe /exitcode
if ($LASTEXITCODE -eq 1) { Write-Host "Switched to Light mode" }
```

### 👁️ AutoHide Task View

#### Install-AutoHideTaskView.ps1
- **`-InstallDir`**: Custom installation directory (default: `%LOCALAPPDATA%\AutoHideTaskView`)
- **`-TaskName`**: Custom scheduled task name (default: "AutoHide Task View")
- **`-StartNow`**: Start the service immediately after installation

---

## 🏆 Performance Comparison

| Operation | V2/V3 (PowerShell) | V4 (C++) | Improvement |
|-----------|-------------------|----------|-------------|
| **No change needed** | 5000ms | **5-10ms** | **500x faster** ⚡ |
| **Theme toggle** | 5000ms | **110ms** | **45x faster** ⚡ |
| **Startup overhead** | ~4800ms | ~2ms | **2400x faster** ⚡ |

**Real-world impact:** V4 feels instant. V2/V3 had noticeable delays.

## 💻 Requirements

- Windows 10 (1809+) / Windows 11
- For V4: No additional requirements (standalone executable)
- For PowerShell scripts: PowerShell 5.1 or later
- Administrator privileges may be required for scheduled tasks

## 🔧 How It Works

### Windows Theme Toggler V4

The native C++ implementation modifies Windows registry values in:

```registry
HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize
```

Specifically:

- **`SystemUsesLightTheme`** (DWORD): Controls system theme (taskbar, etc.)
- **`AppsUseLightTheme`** (DWORD): Controls app theme

**Key optimizations:**
1. **Early short-circuit**: Exits immediately if theme already matches target
2. **Dual broadcast**: Sends both `ImmersiveColorSet` and `ColorizationColor` for instant taskbar updates
3. **RAII resource management**: Automatic cleanup, exception-safe
4. **Cached console handles**: Eliminates redundant system calls
5. **Async broadcasts with timeout**: Fast + reliable (50ms timeout with `SMTO_ABORTIFHUNG`)

After updating the registry, it broadcasts `WM_SETTINGCHANGE` messages to notify applications of the theme change.

## 🛠️ Building from Source (V4)

### Prerequisites
- Visual Studio 2019 or later (MSVC)
- Windows SDK

### Quick Build
```batch
cd ThemeToggle
build.bat
```

This compiles with `/O2` (maximum speed), `/MT` (static runtime), and embeds the icon.

**Result:** `ThemeToggle.exe` (~220 KB, zero dependencies)

## 📖 Documentation

- **[ThemeToggle README](ThemeToggle/README.md)**: Complete V4 documentation
- **[AUTOMATION_GUIDE](ThemeToggle/AUTOMATION_GUIDE.md)**: Hotkeys, scheduled tasks, integrations
- **[RELEASE_NOTES](ThemeToggle/RELEASE_NOTES.md)**: V4 improvements and benchmarks
- **[CHANGELOG](CHANGELOG.md)**: Full version history
- **[EXAMPLES](EXAMPLES.md)**: Usage examples
- **[CONTRIBUTING](CONTRIBUTING.md)**: Contribution guidelines
- **[AutoHide Task View README](AutoHideTaskView/README.md)**: Task View utility documentation
- **[Legacy Versions](legacy/README.md)**: Migration guide and archived versions

## 🤝 Contributing

Contributions welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## 📄 License

MIT License - See [LICENSE](LICENSE) for details.

## 🙏 Credits

**Version 4** - Complete rewrite in C++17 with enterprise-grade optimizations and reliability improvements.

**Previous versions** - PowerShell implementations with comprehensive features and error handling.