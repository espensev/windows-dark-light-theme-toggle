# AutoHide Task View

A small, event-driven PowerShell utility that hides the Windows Task View button when only one virtual desktop exists, and shows it when more are open.

Features
- Event-driven: watches virtual desktop changes via RegistryValueChangeEvent; no busy polling.
- Gentle refresh: notifies Explorer to update without killing it. Fallback to explorer.exe /restart if needed.
- Single instance: named mutex prevents duplicate runs.
- Graceful shutdown: uninstaller signals a stop event which the script honors.
- Robust deployment: installer creates a per-user Scheduled Task; optional Startup shortcut creator included.

Files
- AutoHide_TaskView.ps1
  - Main script (event-driven with fallback).
- Install-AutoHideTaskView.ps1
  - Copies the script to %LOCALAPPDATA%\AutoHideTaskView and registers a per-user Scheduled Task.
- Uninstall-AutoHideTaskView.ps1
  - Removes the Scheduled Task and installed files; signals running instance to stop.
- Add-StartupShortcut.ps1 (optional)
  - Creates a Startup-folder shortcut that launches the script hidden.

Quick install
- PowerShell:
  - powershell -ExecutionPolicy Bypass -NoProfile -File .\Install-AutoHideTaskView.ps1 -StartNow

Uninstall
- PowerShell:
  - powershell -ExecutionPolicy Bypass -NoProfile -File .\Uninstall-AutoHideTaskView.ps1

Alternative: Startup shortcut
- powershell -ExecutionPolicy Bypass -NoProfile -File .\Add-StartupShortcut.ps1

Notes
- The script prefers `pwsh.exe` if available; falls back to Windows PowerShell.
- Works per-user (HKCU). Do not deploy as a service.
- If WMI events are restricted, the script automatically falls back to a light polling loop.

Versioning
- AutoHide Task View v1.2 (2025-10-09)
  - Added mutex, stop-event, installer/uninstaller, startup shortcut, improved refresh handling.
