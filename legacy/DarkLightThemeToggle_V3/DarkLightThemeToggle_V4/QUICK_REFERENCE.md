# ?? ThemeToggle Quick Reference

## ?? Files Overview

| File | Description | When to Use |
|------|-------------|-------------|
| `ThemeToggle.exe` | Main executable | Direct command-line use |
| `ThemeToggle.vbs` | Silent toggle launcher | Hotkeys, shortcuts |
| `ThemeToggle-Light.vbs` | Silent light mode | Morning automation |
| `ThemeToggle-Dark.vbs` | Silent dark mode | Evening automation |
| `ThemeToggle.ps1` | PowerShell launcher | Advanced scripting |
| `setup.bat` | Interactive installer | First-time setup |

## ? Quick Commands

```bash
# Direct execution (shows console)
ThemeToggle.exe    # Toggle
ThemeToggle.exe /light       # Light mode
ThemeToggle.exe /dark      # Dark mode
ThemeToggle.exe /quiet       # Silent (no output)

# Silent execution (no console)
ThemeToggle.vbs    # Toggle silently
ThemeToggle-Light.vbs     # Light mode silently
ThemeToggle-Dark.vbs         # Dark mode silently

# PowerShell
.\ThemeToggle.ps1            # Toggle
.\ThemeToggle.ps1 -Light     # Light mode
.\ThemeToggle.ps1 -Dark      # Dark mode
```

## ?? Hotkey Setup (3 steps)

1. Create desktop shortcut to `ThemeToggle.vbs`
2. Right-click shortcut ? Properties
3. Set "Shortcut key" to `Ctrl+Alt+T`

**Done!** Press `Ctrl+Alt+T` anywhere to toggle theme.

## ?? Scheduled Automation

### Quick Setup (GUI)
Run `setup.bat` and select option 3

### Manual Setup
```batch
# Light theme at 7 AM
schtasks /create /tn "Theme-Morning" /tr "wscript.exe \"C:\path\to\ThemeToggle-Light.vbs\"" /sc daily /st 07:00

# Dark theme at 7 PM
schtasks /create /tn "Theme-Evening" /tr "wscript.exe \"C:\path\to\ThemeToggle-Dark.vbs\"" /sc daily /st 19:00
```

## ?? Common Use Cases

### Hotkey for Instant Toggle
```
Double-click: ThemeToggle.vbs ? Send to Desktop ? Properties ? Set hotkey
```

### Auto-toggle on Login
```batch
Run setup.bat ? Select option 2
```

### Sunrise/Sunset Automation  
```batch
Run setup.bat ? Select option 3
```

### One-Click Desktop Toggle
```
Drag ThemeToggle.vbs to desktop ? Double-click to toggle
```

### Stream Deck Button
```
Add "Open" action ? Browse to ThemeToggle.vbs
```

## ?? Exit Codes (with /exitcode)

| Code | Meaning |
|------|---------|
| 0 | No change needed |
| 1 | Changed to Light |
| 2 | Changed to Dark |
| 10 | Registry error |
| 11 | Write failed |
| 20 | Broadcast failed |

## ?? Performance

| Action | Time |
|--------|------|
| No change needed | 5-10 ms |
| Full theme toggle | ~110 ms |
| VBS wrapper overhead | <1 ms |

## ??? Troubleshooting

**Console window flashes briefly?**
? Use `.vbs` files instead of `.exe`

**Hotkey doesn't work?**
? Check if another app uses the same hotkey

**Theme doesn't change?**
? Verify Windows 10 1809+ or Windows 11

**Scheduled task fails?**
? ? Fixed! `setup.bat` now uses absolute paths automatically

**Batch scripts fail from other directories?**
? ? Fixed! All scripts now use `pushd "%~dp0"` pattern for safe directory handling

## ?? Documentation

- `README.md` - Full documentation
- `AUTOMATION_GUIDE.md` - Advanced automation
- `setup.bat` - Interactive installer

## ?? Pro Tips

1. **Pin to taskbar**: Drag `ThemeToggle.vbs` to taskbar
2. **Context menu**: Add to right-click desktop menu (see AUTOMATION_GUIDE.md)
3. **Multiple schedules**: Duplicate scheduled tasks with different times
4. **Test first**: Run `ThemeToggle.vbs` to verify it works

---

**Need more help?** See [AUTOMATION_GUIDE.md](AUTOMATION_GUIDE.md) for detailed instructions.
