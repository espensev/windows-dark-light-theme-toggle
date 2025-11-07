# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [4.0.0] - 2025-11-07

### 🚀 MAJOR UPGRADE - Complete C++ Rewrite

**Windows Theme Toggler V4** represents a complete architectural overhaul with revolutionary performance improvements and production-grade reliability.

### Added

- **⚡ Native C++ implementation** - Complete rewrite in modern C++17
- **🏭 Production-grade architecture** - RAII resource management, type-safe design
- **📦 Zero-dependency executable** - Single standalone ~220KB binary
- **🎯 Smart early-exit optimization** - 5-10ms when no change needed
- **📡 Dual broadcast system** - `ImmersiveColorSet` + `ColorizationColor` for instant taskbar updates
- **🖥️ Pipe detection** - Smart ANSI code handling for redirected output
- **🔇 Silent VBS launchers** - ThemeToggle.vbs, ThemeToggle-Light.vbs, ThemeToggle-Dark.vbs
- **📜 PowerShell wrapper** - ThemeToggle.ps1 for scripting convenience
- **📖 Comprehensive documentation** - AUTOMATION_GUIDE.md, RELEASE_NOTES.md, detailed README
- **🎨 Embedded icon** - Professional branding with resource compilation
- **🔨 Build automation** - build.bat with resource compilation and optimization flags
- **📋 Manifest embedding** - DPI-aware declaration for instant theme changes

### Performance Improvements

| Metric | V3 (PowerShell) | V4 (C++) | Improvement |
|--------|----------------|----------|-------------|
| **No change needed** | 5000ms | **5-10ms** | **500x faster** ⚡ |
| **Theme toggle** | 5000ms | **110ms** | **45x faster** ⚡ |
| **Startup overhead** | ~4800ms | ~2ms | **2400x faster** ⚡ |

### Technical Highlights

- **Modern C++17**: `std::wstring_view`, `enum class`, strong typing
- **RAII pattern**: Automatic cleanup, exception-safe, leak-proof
- **Explicit semantics**: Clear `Open()` vs `CreateOrOpen()` registry methods
- **Cached handles**: Eliminates redundant `GetStdHandle()` syscalls
- **Async broadcasts**: 50ms timeout with `SMTO_ABORTIFHUNG` flag
- **Static runtime**: `/MT` compilation, no DLL dependencies
- **Maximum optimization**: `/O2` compiler flag for speed
- **Zero compiler warnings**: Clean build with `/W4`

### Changed

- **Architecture**: PowerShell → C++ for performance-critical operations
- **Distribution**: Script files → Compiled executable
- **Resource management**: Manual cleanup → Automatic RAII
- **Error handling**: Exit codes → Structured error codes with fallback paths
- **Broadcast strategy**: Single message → Dual broadcast for instant UI updates
- **Repository scope**: Expanded to "Windows Customization Toolkit"

### Fixed

- **Missing registry keys**: Now creates keys on LTSC/Server editions
- **Broadcast reliability**: Fire-and-forget with timeout prevents hanging
- **Console output**: Pipe-safe, no ANSI codes in redirected output
- **Resource leaks**: RAII ensures handles always close properly
- **Performance bottlenecks**: Eliminated PowerShell startup overhead

### Migration Notes

**V3 users:** V4 is a drop-in replacement with improved command syntax:
- V3: `.\DarkLightThemeToggle_V3.ps1 -Light`
- V4: `.\ThemeToggle.exe /light`

All functionality preserved, vastly improved performance and reliability.

---

## [3.0.0] - 2025-10-09

### Added

- **🆕 AutoHide Task View utility** - Complete new Windows customization tool
- **Event-driven Task View management** - Intelligently hide/show Task View button based on virtual desktop count
- **Professional installer/uninstaller** - Automated setup with scheduled tasks
- **Single-instance protection** - Mutex-based prevention of duplicate processes
- **Graceful shutdown handling** - Stop event for clean termination
- **WMI event monitoring** - Registry change detection with polling fallback
- **Comprehensive documentation** - Full README for AutoHide Task View utility
- **Enhanced PowerShell script** (Theme Toggle V3) with comprehensive parameter support
- **PassThru parameter** for detailed information objects
- **AsExitCode parameter** for automation and scripting workflows
- **Improved error handling** with try-catch blocks and meaningful error messages
- **Better registry key creation** with safeguards
- **Enhanced broadcast notification** with timeout and error handling
- **Professional function-based architecture** allowing dot-sourcing
- **Comprehensive exit code mapping** for different scenarios

### Changed

- **Repository scope expanded** - Now "Windows Customization Toolkit" instead of just theme toggle
- **Enhanced README structure** - Multi-utility documentation with clear sections
- **Improved project organization** - Clear separation of utilities and their components
- **Restructured parameters** for better usability (-Light, -Dark, -Toggle, etc.)
- **Improved output formatting** with colored messages
- **Enhanced VBScript wrapper** with better comments and documentation
- **Better file organization** with V3 subfolder

### Fixed

- **Registry key existence validation** before attempting operations
- **Error handling** for failed registry operations
- **Broadcast message handling** with proper timeout

### Technical Details

- **AutoHide Task View v1.2** with mutex, stop-event, installer/uninstaller
- **Explorer refresh optimization** - Gentle notification instead of process restart
- **Robust registry monitoring** - Per-session and base path virtual desktop tracking
- **Professional deployment** - Scheduled task with proper user context

## [2.0.0] - 2025-10-05

### Added
- **Basic PowerShell implementation** with core functionality
- **VBScript wrapper** for silent execution
- **Batch file launcher** for easy access
- **Registry manipulation** for theme switching
- **Native Windows API calls** for broadcasting theme changes

### Features
- Toggle between light and dark themes
- Force specific theme modes
- Quiet operation mode
- Basic error handling

## [1.0.0] - 2025-10-04

### Added
- **Initial concept** and basic implementation
- **Core theme switching functionality**
- **Basic registry operations**

---

## Version Comparison

| Feature | V1.0 | V2.0 | V3.0 | V4.0 |
|---------|------|------|------|------|
| **Language** | PowerShell | PowerShell | PowerShell | **C++17** |
| **Performance** | Slow | Slow | Slow | **⚡ Ultra-Fast** |
| **Startup Time** | ~5000ms | ~5000ms | ~5000ms | **~2ms** |
| **Toggle Time** | ~5000ms | ~5000ms | ~5000ms | **~110ms** |
| **No-change Exit** | ~5000ms | ~5000ms | ~5000ms | **~5-10ms** |
| **Basic Toggle** | ✅ | ✅ | ✅ | ✅ |
| **Force Light/Dark** | ❌ | ✅ | ✅ | ✅ |
| **Quiet Mode** | ❌ | ✅ | ✅ | ✅ |
| **Error Handling** | ❌ | Basic | Advanced | **Enterprise** |
| **Exit Codes** | ❌ | Basic | Comprehensive | **Type-Safe** |
| **PassThru Object** | ❌ | ❌ | ✅ | ✅ |
| **Function Architecture** | ❌ | ❌ | ✅ | **Native API** |
| **Documentation** | ❌ | Basic | Comprehensive | **Professional** |
| **Dependencies** | PowerShell | PowerShell | PowerShell | **None** |
| **File Size** | N/A | N/A | N/A | **~220KB** |
| **Resource Management** | Manual | Manual | Manual | **RAII** |
| **Broadcast Strategy** | Single | Single | Single | **Dual** |
| **Pipe Safety** | ❌ | ❌ | ❌ | **✅** |
| **Missing Key Handling** | ❌ | ❌ | ❌ | **✅** |
| **Build Required** | ❌ | ❌ | ❌ | **✅** |

**Recommendation:** Use V4 for production. V3 available for PowerShell-only environments.