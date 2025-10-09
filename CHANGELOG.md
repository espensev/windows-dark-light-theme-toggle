# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [4.0.0] - 2025-10-09

### Added

- **🆕 AutoHide Task View utility** - Complete new Windows customization tool
- **Event-driven Task View management** - Intelligently hide/show Task View button based on virtual desktop count
- **Professional installer/uninstaller** - Automated setup with scheduled tasks
- **Single-instance protection** - Mutex-based prevention of duplicate processes
- **Graceful shutdown handling** - Stop event for clean termination
- **WMI event monitoring** - Registry change detection with polling fallback
- **Comprehensive documentation** - Full README for AutoHide Task View utility

### Changed

- **Repository scope expanded** - Now "Windows Customization Toolkit" instead of just theme toggle
- **Enhanced README structure** - Multi-utility documentation with clear sections
- **Improved project organization** - Clear separation of utilities and their components

### Technical Details

- **AutoHide Task View v1.2** with mutex, stop-event, installer/uninstaller
- **Explorer refresh optimization** - Gentle notification instead of process restart
- **Robust registry monitoring** - Per-session and base path virtual desktop tracking
- **Professional deployment** - Scheduled task with proper user context

### Added
- **Enhanced PowerShell script** with comprehensive parameter support
- **PassThru parameter** for detailed information objects
- **AsExitCode parameter** for automation and scripting workflows
- **Improved error handling** with try-catch blocks and meaningful error messages
- **Better registry key creation** with safeguards
- **Enhanced broadcast notification** with timeout and error handling
- **Professional function-based architecture** allowing dot-sourcing
- **Comprehensive exit code mapping** for different scenarios

### Changed
- **Restructured parameters** for better usability (-Light, -Dark, -Toggle, etc.)
- **Improved output formatting** with colored messages
- **Enhanced VBScript wrapper** with better comments and documentation
- **Better file organization** with V3 subfolder

### Fixed
- **Registry key existence validation** before attempting operations
- **Error handling** for failed registry operations
- **Broadcast message handling** with proper timeout

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

| Feature | V1.0 | V2.0 | V3.0 |
|---------|------|------|------|
| Basic Toggle | ✅ | ✅ | ✅ |
| Force Light/Dark | ❌ | ✅ | ✅ |
| Quiet Mode | ❌ | ✅ | ✅ |
| Error Handling | ❌ | Basic | Advanced |
| Exit Codes | ❌ | Basic | Comprehensive |
| PassThru Object | ❌ | ❌ | ✅ |
| Function Architecture | ❌ | ❌ | ✅ |
| Documentation | ❌ | Basic | Comprehensive |