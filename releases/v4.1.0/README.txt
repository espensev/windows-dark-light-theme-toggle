Windows Theme Toggler v4.1.0
============================

Ultra-fast Windows 10/11 Light/Dark theme switcher

QUICK START
-----------

Double-click one of these files to change your theme instantly:

  ThemeToggle.vbs         - Toggle between light and dark (SILENT)
  ThemeToggle-Light.vbs   - Force light mode (SILENT)
  ThemeToggle-Dark.vbs    - Force dark mode (SILENT)
  ThemeToggle.exe         - Toggle with console output

The .vbs files run silently (no window flash) - perfect for hotkeys!


CREATING A HOTKEY
-----------------

1. Right-click ThemeToggle.vbs → Create Shortcut
2. Move shortcut to: %APPDATA%\Microsoft\Windows\Start Menu\Programs
3. Right-click shortcut → Properties → Shortcut tab
4. Click in "Shortcut key" field and press: Ctrl + Alt + T
5. Click OK

Now press Ctrl+Alt+T anywhere to toggle your theme instantly!


COMMAND-LINE OPTIONS
--------------------

ThemeToggle.exe [options]

  /light       Force light theme
  /dark        Force dark theme
  /toggle      Toggle current theme (default)
  /quiet       Suppress output
  /passthru    Return detailed information
  /exitcode    Map result to exit code

Examples:
  ThemeToggle.exe               Toggle theme
  ThemeToggle.exe /light        Force light
  ThemeToggle.exe /dark /quiet  Force dark silently


POWERSHELL USAGE
----------------

.\ThemeToggle.ps1           # Toggle
.\ThemeToggle.ps1 -Light    # Force light
.\ThemeToggle.ps1 -Dark     # Force dark


AUTOMATION
----------

Schedule theme changes based on time of day:

1. Open Task Scheduler
2. Create Basic Task
3. Trigger: Daily at sunrise
4. Action: Start a program
5. Program: C:\Path\To\ThemeToggle.exe
6. Arguments: /light /quiet

Repeat for sunset with /dark


PERFORMANCE
-----------

  ~5-10ms     When no change needed (early exit)
  ~110ms      When toggling theme
  45-500x     Faster than PowerShell versions


TROUBLESHOOTING
---------------

Theme doesn't change?
  - Check Windows 10/11 version (requires 1809+)
  - Run ThemeToggle.exe (with console) to see errors
  - Ensure registry path exists (created automatically on most systems)

Console window flashes?
  - Use .vbs files instead of .exe for silent operation

Hotkey doesn't work?
  - Ensure shortcut is in Start Menu Programs folder
  - Try different key combination (some are reserved)


SYSTEM REQUIREMENTS
-------------------

  - Windows 10 (1809+) or Windows 11
  - No dependencies required
  - ~220 KB disk space


FILES
-----

  ThemeToggle.exe          Native C++ executable
  ThemeToggle.vbs          Silent toggle launcher
  ThemeToggle-Light.vbs    Silent light mode launcher
  ThemeToggle-Dark.vbs     Silent dark mode launcher
  ThemeToggle.ps1          PowerShell wrapper
  README.txt               This file
  LICENSE.txt              MIT License


MORE INFORMATION
----------------

GitHub: https://github.com/espensev/windows-dark-light-theme-toggle
Full Documentation: See AUTOMATION_GUIDE.txt (if included)

For advanced usage, scheduled tasks, Stream Deck integration, and more,
visit the GitHub repository.


LICENSE
-------

MIT License - Free for personal and commercial use
See LICENSE.txt for full text


VERSION
-------

Version: 4.1.0
Released: 2025-11-07
Build: Native C++17, MSVC, Release mode (/O2 /MT)
