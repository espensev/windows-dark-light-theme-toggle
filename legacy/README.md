# Legacy Versions

This folder contains previous versions of the Windows Theme Toggler for reference and backward compatibility.

## ⚠️ Deprecated - Use V4 Instead

**These versions are superseded by V4** (located in `/ThemeToggle/`).

V4 offers:
- **45-500x faster performance**
- **Native C++ implementation**
- **Zero dependencies**
- **Production-grade reliability**

## Contents

### DarkLightThemeToggle_V3/
PowerShell implementation with enhanced features (v3.0.0)
- Function-based architecture
- PassThru and exit code support
- Comprehensive error handling

### DarkLightThemeToggle_V3/DarkLightThemeToggle_V4/
**Note:** V4 has been moved to `/ThemeToggle/` for easier access.
This nested copy remains for reference only.

### Root Files (V2)
- `DarkLightThemeToggle_V2 - Copy.ps1` - Original PowerShell implementation
- `DarkLightThemeToggle.bat` - Batch wrapper
- `ToggleTheme.vbs` - VBS launcher

## Migration Guide

### From V3 to V4

**V3 Command:**
```powershell
.\DarkLightThemeToggle_V3.ps1 -Light
```

**V4 Command:**
```cmd
.\ThemeToggle.exe /light
```

### Parameter Mapping

| V3 Parameter | V4 Argument |
|--------------|-------------|
| `-Light` | `/light` |
| `-Dark` | `/dark` |
| `-Toggle` | (default) |
| `-Quiet` | `/quiet` |
| `-PassThru` | `/passthru` |
| `-AsExitCode` | `/exitcode` |

## Why Keep Legacy Versions?

1. **Reference**: Educational value for comparing implementations
2. **PowerShell-only environments**: Some restricted environments may not allow C++ executables
3. **Backwards compatibility**: Existing scripts may reference old paths
4. **Version history**: Documents the evolution of the project

## Recommendation

**Use `/ThemeToggle/` for all new deployments.** These legacy versions are maintained for reference only and will not receive updates.

For full V4 documentation, see [`/ThemeToggle/README.md`](../ThemeToggle/README.md).
