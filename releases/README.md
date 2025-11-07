# Releases

Pre-built binaries of Windows Theme Toggler for easy deployment.

## 📦 Latest Release: v4.1.0

**[Download ThemeToggle-v4.1.0.zip](v4.1.0/ThemeToggle-v4.1.0.zip)**

### What's Included
- `ThemeToggle.exe` - Native C++ executable (~220 KB, zero dependencies)
- `ThemeToggle.vbs` - Silent toggle launcher (no console)
- `ThemeToggle-Light.vbs` - Force light mode silently
- `ThemeToggle-Dark.vbs` - Force dark mode silently
- `ThemeToggle.ps1` - PowerShell wrapper
- `README.txt` - Quick start guide
- `LICENSE.txt` - MIT License

### Quick Start

1. **Download** the latest release zip
2. **Extract** to any folder (e.g., `C:\Tools\ThemeToggle\`)
3. **Run** by double-clicking:
   - `ThemeToggle.vbs` to toggle theme silently
   - `ThemeToggle.exe` to toggle with console output

### 🔥 Recommended: Create a Hotkey

**Windows 11/10:**
1. Right-click `ThemeToggle.vbs` → Create Shortcut
2. Move shortcut to: `%APPDATA%\Microsoft\Windows\Start Menu\Programs`
3. Right-click shortcut → Properties → Shortcut tab
4. Set "Shortcut key": `Ctrl + Alt + T` (or your preference)
5. Click OK

Now press **Ctrl+Alt+T** to instantly toggle theme!

## 📋 Version History

### v4.1.0 (2025-11-07) - Code Quality Improvements
- ✨ Cleaner argument parsing with `std::transform`
- ✨ Named constants for semantic clarity (`BROADCAST_TIMEOUT_MS`)
- ✨ Better error handling with `std::optional<DWORD>`
- ✨ More idiomatic modern C++17
- 📖 Enhanced documentation

### v4.0.0 (2025-11-07) - Initial Native Release
- ⚡ Complete rewrite in C++17
- ⚡ 45-500x faster than PowerShell versions
- 📦 Zero dependencies, single portable executable
- 🏭 Production-grade RAII resource management
- 📡 Dual broadcast for instant taskbar updates
- 🔇 Silent VBS launchers included

## 🔐 Verify Downloads

Each release includes `SHA256SUMS.txt` for integrity verification.

**PowerShell:**
```powershell
Get-FileHash ThemeToggle-v4.1.0.zip -Algorithm SHA256
# Compare with SHA256SUMS.txt
```

## 💻 System Requirements

- Windows 10 (1809+) / Windows 11
- No additional dependencies required
- ~1 MB disk space

## 🛠️ Build from Source

If you prefer to build from source, see the main [README](../README.md) and [ThemeToggle/README.md](../ThemeToggle/README.md).

## 📖 Documentation

- [Main README](../README.md) - Overview and features
- [ThemeToggle Documentation](../ThemeToggle/README.md) - Complete V4 docs
- [Automation Guide](../ThemeToggle/AUTOMATION_GUIDE.md) - Hotkeys, scheduled tasks
- [Changelog](../CHANGELOG.md) - Full version history

## 🤝 Contributing

See [CONTRIBUTING.md](../CONTRIBUTING.md) for guidelines.

## 📄 License

MIT License - See [LICENSE](../LICENSE) for details.
