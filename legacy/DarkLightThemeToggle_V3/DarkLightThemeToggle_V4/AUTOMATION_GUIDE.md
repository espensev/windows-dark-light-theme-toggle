# Silent Launch & Automation Guide

This guide shows how to use the VBScript and PowerShell wrappers for completely silent theme toggling.

## ?? Quick Start

### Option 1: VBScript (Simplest - Works Everywhere)
```
Double-click ThemeToggle.vbs to toggle theme silently
```

### Option 2: PowerShell (Most Flexible)
```powershell
.\ThemeToggle.ps1  # Toggle
.\ThemeToggle.ps1 -Light  # Force light
.\ThemeToggle.ps1 -Dark     # Force dark
```

---

## ?? Hotkey Setup

### Method 1: Windows Shortcut (Easiest)

1. **Right-click `ThemeToggle.vbs`** ? Send to ? Desktop (create shortcut)
2. **Right-click the shortcut** ? Properties
3. **Click in "Shortcut key"** field
4. **Press your desired combo** (e.g., `Ctrl + Alt + T`)
5. **Click OK**

**Result**: Press `Ctrl+Alt+T` anywhere to toggle theme instantly!

### Method 2: AutoHotkey (Most Powerful)

Install [AutoHotkey](https://www.autohotkey.com/) and create `ThemeToggle.ahk`:

```autohotkey
; Ctrl+Alt+T = Toggle theme
^!t::
Run, ThemeToggle.vbs, , Hide
return

; Ctrl+Alt+L = Force Light
^!l::
Run, ThemeToggle-Light.vbs, , Hide
return

; Ctrl+Alt+D = Force Dark
^!d::
Run, ThemeToggle-Dark.vbs, , Hide
return

; Win+T = Toggle (if you prefer Win key)
#t::
Run, ThemeToggle.vbs, , Hide
return
```

### Method 3: PowerToys Keyboard Manager

1. Install [PowerToys](https://github.com/microsoft/PowerToys)
2. Open **Keyboard Manager** ? **Remap a shortcut**
3. Map your hotkey to run: `wscript.exe "C:\path\to\ThemeToggle.vbs"`

---

## ?? Scheduled Tasks (Sunrise/Sunset Automation)

### Automatic Light Theme at 7 AM

```batch
schtasks /create /tn "Theme-Morning" /tr "wscript.exe \"C:\path\to\ThemeToggle-Light.vbs\"" /sc daily /st 07:00
```

### Automatic Dark Theme at 7 PM

```batch
schtasks /create /tn "Theme-Evening" /tr "wscript.exe \"C:\path\to\ThemeToggle-Dark.vbs\"" /sc daily /st 19:00
```

### GUI Method (Easier)

1. Open **Task Scheduler** (`Win+R` ? `taskschd.msc`)
2. **Create Basic Task**
3. **Name**: "Morning Light Theme"
4. **Trigger**: Daily at 7:00 AM
5. **Action**: Start a program
6. **Program**: `wscript.exe`
7. **Arguments**: `"C:\path\to\ThemeToggle-Light.vbs"`
8. **Finish**

Repeat for evening dark theme at 7:00 PM.

---

## ??? Context Menu Integration

Add "Toggle Theme" to right-click desktop menu:

### Registry Method (Advanced)

Save as `AddContextMenu.reg` and double-click:

```reg
Windows Registry Editor Version 5.00

[HKEY_CLASSES_ROOT\DesktopBackground\Shell\ToggleTheme]
@="Toggle Theme"
"Icon"="C:\\Windows\\System32\\shell32.dll,290"

[HKEY_CLASSES_ROOT\DesktopBackground\Shell\ToggleTheme\command]
@="wscript.exe \"C:\\Users\\YourUser\\ThemeToggle.vbs\""
```

*(Replace path with your actual path)*

---

## ?? Stream Deck / Macro Pad Integration

### For Elgato Stream Deck
1. Add **System** ? **Open** button
2. Set path: `C:\path\to\ThemeToggle.vbs`
3. Optionally add custom icon

### For Any Macro Keyboard
Configure macro to execute:
```
wscript.exe "C:\path\to\ThemeToggle.vbs"
```

---

## ?? Login/Logout Automation

### Run on Login
```batch
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "ThemeToggle" /t REG_SZ /d "wscript.exe \"C:\path\to\ThemeToggle-Light.vbs\"" /f
```

### Run on Unlock (with Task Scheduler)
1. Task Scheduler ? Create Task
2. **Trigger**: On workstation unlock
3. **Action**: `wscript.exe "C:\path\to\ThemeToggle-Light.vbs"`

---

## ?? Remote Execution

### From PowerShell Remotely
```powershell
Invoke-Command -ComputerName PC-NAME -ScriptBlock {
    & "C:\path\to\ThemeToggle.exe" /dark /quiet
}
```

### From CMD/Batch Remotely
```batch
psexec \\PC-NAME -s wscript.exe "C:\path\to\ThemeToggle.vbs"
```

---

## ?? Mobile Control (Advanced)

### Using Unified Remote / KDE Connect
1. Create custom command in app
2. Set command: `wscript.exe "C:\path\to\ThemeToggle.vbs"`
3. Add to favorites for one-tap theme toggle

---

## ?? Custom Integration Examples

### Toggle on Monitor Change
```powershell
# MonitorChange.ps1
$displays = Get-CimInstance -Namespace root\wmi -ClassName WmiMonitorBrightness
if ($displays.Count -gt 1) {
    # Multiple monitors detected - switch to light
    & "C:\path\to\ThemeToggle.exe" /light /quiet
} else {
    # Single monitor - switch to dark
    & "C:\path\to\ThemeToggle.exe" /dark /quiet
}
```

### Toggle Based on Ambient Light (with sensor)
```powershell
# Requires ambient light sensor
$sensor = Get-Sensor -SensorType AmbientLight
if ($sensor.Value -lt 30) {
    & "C:\path\to\ThemeToggle.exe" /dark /quiet
} else {
    & "C:\path\to\ThemeToggle.exe" /light /quiet
}
```

### Toggle on Game Launch/Exit
```batch
REM GameLauncher.bat
start "" "C:\Games\MyGame.exe"
wscript.exe "C:\path\to\ThemeToggle-Dark.vbs"

REM When game closes:
wscript.exe "C:\path\to\ThemeToggle-Light.vbs"
```

---

## ?? Performance Notes

All VBS wrappers:
- ? **Zero console flash** (completely silent)
- ? **Instant execution** (<10ms overhead)
- ? **No admin rights required**
- ? **Works from any location**
- ? **Compatible with Windows 7-11**

---

## ?? Troubleshooting

### VBS shows error "File not found"
- Make sure `ThemeToggle.exe` is in the **same folder** as the VBS files
- Or edit VBS to use absolute path: `exePath = "C:\full\path\to\ThemeToggle.exe"`

### Hotkey doesn't work
- Check if another program is using the same hotkey
- Try a different key combination
- Ensure shortcut has admin rights if needed

### Scheduled task fails
- Use **full paths** in Task Scheduler (not relative paths)
- Set "Start in" directory to folder containing ThemeToggle.exe
- Run task with "highest privileges" if needed

---

## ?? File Summary

| File | Purpose | Use Case |
|------|---------|----------|
| `ThemeToggle.vbs` | Silent toggle | Hotkeys, shortcuts |
| `ThemeToggle-Light.vbs` | Force light | Morning automation |
| `ThemeToggle-Dark.vbs` | Force dark | Evening automation |
| `ThemeToggle.ps1` | PowerShell version | Advanced scripting |
| `ThemeToggle.exe` | Core executable | All wrappers call this |

---

## ?? Tips

1. **Pin VBS to taskbar**: Drag `ThemeToggle.vbs` to taskbar for one-click access
2. **Custom icons**: Create shortcuts with custom icons for visual feedback
3. **Multiple profiles**: Create separate VBS files for different theme schedules
4. **Combine with other actions**: Chain theme toggle with other commands

---

**Enjoy your completely silent, instant theme switching!** ??
