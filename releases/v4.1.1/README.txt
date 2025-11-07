===============================================================================
                      WINDOWS THEME TOGGLER v4.1.1
           Ultra-Fast Native Theme Switcher for Windows 10/11
===============================================================================

WHAT IS THIS?
-------------

ThemeToggle instantly switches your Windows theme between Light and Dark mode.
It's a native C++ application that's 45-500x faster than PowerShell alternatives.

Perfect for:
  • Quick theme switching with desktop shortcuts
  • Keyboard hotkeys for instant theme changes
  • Automated sunrise/sunset theme scheduling
  • Manual control without diving into Settings


QUICK START (30 SECONDS)
-------------------------

1. Extract all files to a permanent location (e.g., C:\Tools\ThemeToggle\)

2. Run setup.bat and choose your preferences:
   [1] Create Desktop Shortcut  - Double-click to toggle theme
   [2] Add to Startup           - Auto-start on login (minimal resource use)
   [3] Create Scheduled Tasks   - Automatic Light (7 AM) / Dark (7 PM)
   [4] All of the above         - Complete setup

3. Done! Double-click the desktop shortcut or wait for scheduled changes.


USAGE OPTIONS
-------------

Silent Toggle (Recommended):
  • Double-click ThemeToggle.vbs
  • No console window, instant theme change
  • Perfect for shortcuts and hotkeys

Force Specific Theme:
  • ThemeToggle-Light.vbs  → Always switch to Light mode
  • ThemeToggle-Dark.vbs   → Always switch to Dark mode

Console Mode (Show Output):
  • ThemeToggle.exe         → Toggle with console output
  • ThemeToggle.exe /light  → Force Light mode
  • ThemeToggle.exe /dark   → Force Dark mode
  • ThemeToggle.exe /quiet  → Silent console mode

PowerShell Integration:
  • .\ThemeToggle.ps1 -Toggle
  • .\ThemeToggle.ps1 -Light -Quiet
  • .\ThemeToggle.ps1 -Dark -ShowWindow
  • .\ThemeToggle.ps1 -AsExitCode  (returns 0=no change, 1=light, 2=dark)


WHAT'S NEW IN v4.1.1?
---------------------

Bug Fixes:
  ✅ Fixed UI sync issue - Taskbar now updates immediately even when 
     registry already matches target theme
  ✅ Fixed manifest DPI awareness for better multi-monitor support
  ✅ Fixed scheduled task paths for reliable execution

New Features:
  ✅ Integrated disable options in setup.bat (no separate uninstall needed)
  ✅ Enhanced PowerShell wrapper with full parameter support
  ✅ Improved VBS launchers with better error handling

User Control:
  ✅ Easy enable/disable of any feature through setup.bat menu
  ✅ Remove desktop shortcut, startup entry, or scheduled tasks individually
  ✅ Complete uninstall option [9] in setup.bat


PERFORMANCE
-----------

Lightning Fast:
  • 5-10ms when no change needed (already in target mode)
  • ~110ms for full theme toggle (45x faster than PowerShell)
  • Instant UI updates (taskbar, File Explorer, apps)

Resource Efficient:
  • ~220 KB executable (single file, no dependencies)
  • Zero memory usage when not running
  • No background services or processes


AUTOMATION EXAMPLES
-------------------

Scheduled Tasks (Sunrise/Sunset):
  • Run setup.bat → Choose [3]
  • Light mode at 7:00 AM daily
  • Dark mode at 7:00 PM daily
  • Customize times by editing scheduled tasks

Keyboard Hotkey:
  1. Right-click ThemeToggle.vbs → Create Shortcut
  2. Right-click shortcut → Properties
  3. Shortcut key: Set to Ctrl+Alt+T (or any key)
  4. Apply → Done! Press your hotkey anytime

PowerShell Automation:
  # Conditional theme based on time
  if ((Get-Date).Hour -lt 7) {
      .\ThemeToggle.ps1 -Dark -Quiet
  } else {
      .\ThemeToggle.ps1 -Light -Quiet
  }

Task Scheduler Custom Times:
  1. Open Task Scheduler
  2. Find "ThemeToggle - Light Mode" or "ThemeToggle - Dark Mode"
  3. Edit trigger times to match your preferences


DISABLE/UNINSTALL OPTIONS
--------------------------

Easy Disable (New in v4.1.1):
  • Run setup.bat
  • Choose option [6], [7], [8], or [9]:
    [6] Remove Desktop Shortcut only
    [7] Remove from Startup only
    [8] Remove Scheduled Tasks only
    [9] Remove All (complete uninstall)

Manual Uninstall:
  • Run uninstall.bat (removes all shortcuts and tasks)
  • Or delete the folder after removing shortcuts/tasks


FILES INCLUDED
--------------

  ThemeToggle.exe          - Main executable (C++ native, ~220 KB)
  ThemeToggle.vbs          - Silent toggle launcher
  ThemeToggle-Light.vbs    - Silent light mode launcher
  ThemeToggle-Dark.vbs     - Silent dark mode launcher
  ThemeToggle.ps1          - PowerShell wrapper with advanced parameters
  setup.bat                - Interactive installer with enable/disable options
  uninstall.bat            - Complete uninstaller
  LICENSE.txt              - MIT License
  CHANGELOG.txt            - Version history and changes
  README.txt               - This file
  SHA256SUMS.txt           - Security checksums


SYSTEM REQUIREMENTS
-------------------

  ✅ Windows 10 version 1809 or later
  ✅ Windows 11 (all versions)
  ✅ Windows Server 2019 or later
  ✅ No Visual C++ Redistributable required
  ✅ No administrator rights required
  ✅ ~220 KB disk space


SECURITY & VERIFICATION
------------------------

Verify File Integrity:
  Get-FileHash ThemeToggle.exe -Algorithm SHA256
  Compare the hash with SHA256SUMS.txt

Open Source:
  • All code available on GitHub
  • Community reviewed and tested
  • MIT License (free to use, modify, distribute)


TROUBLESHOOTING
---------------

Theme doesn't change:
  → Make sure you're running Windows 10 1809 or later
  → Check that theme settings aren't managed by Group Policy
  → Try running ThemeToggle.exe (with console) to see error messages

Scheduled tasks don't work:
  → Open Task Scheduler and check if tasks are enabled
  → Verify task paths point to correct ThemeToggle.exe location
  → Re-run setup.bat option [3] to recreate tasks

Desktop shortcut missing:
  → Run setup.bat option [1] to recreate it

Apps don't update immediately (rare):
  → Restart the specific app
  → This is normal for some apps that don't listen to theme broadcasts


SUPPORT & FEEDBACK
------------------

  GitHub Repository:
    https://github.com/espensev/windows-dark-light-theme-toggle

  Report Issues:
    https://github.com/espensev/windows-dark-light-theme-toggle/issues

  Feature Requests:
    Open an issue on GitHub with [Feature Request] in the title


LICENSE
-------

MIT License - Copyright (c) 2025 espensev

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, subject to the conditions in LICENSE.txt.


===============================================================================
                    Thank you for using ThemeToggle!
           Quick, simple, and effective Windows theme control.
===============================================================================
