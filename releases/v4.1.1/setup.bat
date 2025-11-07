@echo off
REM ============================================================================
REM ThemeToggle Quick Setup - Interactive Installer
REM ============================================================================
REM This script helps you set up ThemeToggle with common configurations
REM ============================================================================

setlocal enabledelayedexpansion

REM Save current directory and switch to script directory
pushd "%~dp0"

echo.
echo ========================================
echo   ThemeToggle Quick Setup
echo ========================================
echo.

REM Check if ThemeToggle.exe exists
if not exist "ThemeToggle.exe" (
    echo ERROR: ThemeToggle.exe not found!
    echo Please build the project first using build.bat
    echo.
    popd
    pause
    exit /b 1
)

echo ThemeToggle.exe found [OK]
echo.

REM Show menu
:MENU
echo What would you like to set up?
echo.
echo === Setup (Enable) ===
echo [1] Create Desktop Shortcut (with hotkey Ctrl+Alt+T)
echo [2] Add to Startup (auto-toggle on login)
echo [3] Create Scheduled Tasks (auto Light at 7AM, Dark at 7PM)
echo [4] All of the above
echo.
echo === Remove (Disable) ===
echo [6] Remove Desktop Shortcut
echo [7] Remove from Startup
echo [8] Remove Scheduled Tasks
echo [9] Remove All (full uninstall)
echo.
echo === Other ===
echo [5] Test theme toggle now
echo [0] Exit
echo.
set /p choice="Enter your choice (0-9): "

if "%choice%"=="1" goto SHORTCUT
if "%choice%"=="2" goto STARTUP
if "%choice%"=="3" goto SCHEDULED
if "%choice%"=="4" goto ALL
if "%choice%"=="5" goto TEST
if "%choice%"=="6" goto REMOVE_SHORTCUT
if "%choice%"=="7" goto REMOVE_STARTUP
if "%choice%"=="8" goto REMOVE_SCHEDULED
if "%choice%"=="9" goto REMOVE_ALL
if "%choice%"=="0" goto END
echo Invalid choice. Please try again.
echo.
goto MENU

:SHORTCUT
echo.
echo Creating desktop shortcut...
REM Use absolute path for script
set scriptPath=%CD%\ThemeToggle.vbs
set desktopPath=%USERPROFILE%\Desktop
set shortcutPath=%desktopPath%\Toggle Theme.lnk
set iconPath=%CD%\ThemeToggle.exe

REM Create shortcut using PowerShell with icon from executable
powershell -Command "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut('%shortcutPath%'); $s.TargetPath = 'wscript.exe'; $s.Arguments = '\"%scriptPath%\"'; $s.WorkingDirectory = '%CD%'; $s.IconLocation = '%iconPath%,0'; $s.Description = 'Toggle Windows Light/Dark Theme'; $s.Save()"

if exist "%shortcutPath%" (
    echo Desktop shortcut created successfully!
    echo.
    echo To set hotkey:
    echo 1. Right-click the shortcut on your desktop
    echo 2. Select Properties
    echo 3. Click in "Shortcut key" field
    echo 4. Press Ctrl+Alt+T (or your preferred combo)
    echo 5. Click OK
    echo.
) else (
 echo Failed to create shortcut.
    echo.
)
if not "%choice%"=="4" pause & goto MENU
goto STARTUP

:STARTUP
echo.
echo Adding to Windows Startup...
REM Use absolute path for startup entry
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "ThemeToggle" /t REG_SZ /d "wscript.exe \"%CD%\ThemeToggle.vbs\"" /f >nul 2>&1
if !errorlevel! equ 0 (
    echo Added to startup successfully!
    echo Theme will toggle automatically when you log in.
    echo.
) else (
 echo Failed to add to startup.
    echo.
)
if not "%choice%"=="4" pause & goto MENU
goto SCHEDULED

:SCHEDULED
echo.
echo Creating scheduled tasks...
echo.

REM Use absolute paths for scheduled tasks - %~dp0 is the script's directory
set "SCRIPT_DIR=%~dp0"
REM Remove trailing backslash if present
if "%SCRIPT_DIR:~-1%"=="\" set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

REM Morning Light Theme (7 AM)
schtasks /create /tn "ThemeToggle-Morning" /tr "wscript.exe \"%SCRIPT_DIR%\ThemeToggle-Light.vbs\"" /sc daily /st 07:00 /f >nul 2>&1
if !errorlevel! equ 0 (
    echo [OK] Morning task: Light theme at 7:00 AM
) else (
    echo [FAIL] Could not create morning task
)

REM Evening Dark Theme (7 PM)
schtasks /create /tn "ThemeToggle-Evening" /tr "wscript.exe \"%SCRIPT_DIR%\ThemeToggle-Dark.vbs\"" /sc daily /st 19:00 /f >nul 2>&1
if !errorlevel! equ 0 (
    echo [OK] Evening task: Dark theme at 7:00 PM
) else (
    echo [FAIL] Could not create evening task
)

echo.
echo To change times, use Task Scheduler (taskschd.msc)
echo.
if not "%choice%"=="4" pause & goto MENU
goto SUCCESS

:ALL
call :SHORTCUT
call :STARTUP
call :SCHEDULED
goto SUCCESS

:TEST
echo.
echo Testing theme toggle...
cscript //nologo ThemeToggle.vbs
echo.
echo If the theme changed, everything is working!
echo.
pause
goto MENU

:SUCCESS
echo.
echo ========================================
echo   Setup Complete!
echo ========================================
echo.
if "%choice%"=="4" (
    echo All features have been configured:
  echo  - Desktop shortcut created
    echo  - Added to startup
    echo  - Scheduled tasks created
)
echo.
echo You can now:
echo  - Press Ctrl+Alt+T to toggle theme ^(after setting hotkey^)
    echo  - Theme will toggle automatically at login
echo  - Light theme at 7 AM, Dark theme at 7 PM
echo.
pause
goto END

:REMOVE_SHORTCUT
echo.
echo Removing desktop shortcut...
set shortcutPath=%USERPROFILE%\Desktop\Toggle Theme.lnk
if exist "%shortcutPath%" (
    del "%shortcutPath%" >nul 2>&1
    if !errorlevel! equ 0 (
        echo [OK] Desktop shortcut removed
    ) else (
        echo [FAIL] Could not remove desktop shortcut
    )
) else (
    echo [SKIP] Desktop shortcut not found
)
echo.
pause
goto MENU

:REMOVE_STARTUP
echo.
echo Removing from Windows Startup...
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "ThemeToggle" /f >nul 2>&1
if !errorlevel! equ 0 (
    echo [OK] Startup entry removed
) else (
    echo [SKIP] Startup entry not found
)
echo.
pause
goto MENU

:REMOVE_SCHEDULED
echo.
echo Removing scheduled tasks...
schtasks /delete /tn "ThemeToggle-Morning" /f >nul 2>&1
if !errorlevel! equ 0 (
    echo [OK] Morning task removed
) else (
    echo [SKIP] Morning task not found
)
schtasks /delete /tn "ThemeToggle-Evening" /f >nul 2>&1
if !errorlevel! equ 0 (
    echo [OK] Evening task removed
) else (
    echo [SKIP] Evening task not found
)
echo.
pause
goto MENU

:REMOVE_ALL
echo.
echo ========================================
echo   Remove All Configurations
echo ========================================
echo.
echo This will remove:
echo  - Desktop shortcut
echo  - Startup entry  
echo  - Scheduled tasks
echo.
echo Note: ThemeToggle.exe and scripts will remain.
echo       You can still run them manually.
echo.
set /p confirm="Continue? (Y/N): "
if /i not "%confirm%"=="Y" (
    echo Cancelled.
    echo.
    pause
    goto MENU
)
echo.
call :REMOVE_SHORTCUT_SILENT
call :REMOVE_STARTUP_SILENT
call :REMOVE_SCHEDULED_SILENT
echo.
echo ========================================
echo   All configurations removed
echo ========================================
echo.
pause
goto MENU

REM Silent removal subroutines (no pause)
:REMOVE_SHORTCUT_SILENT
set shortcutPath=%USERPROFILE%\Desktop\Toggle Theme.lnk
if exist "%shortcutPath%" (
    del "%shortcutPath%" >nul 2>&1
    if !errorlevel! equ 0 (
        echo [OK] Desktop shortcut removed
    )
)
goto :EOF

:REMOVE_STARTUP_SILENT
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "ThemeToggle" /f >nul 2>&1
if !errorlevel! equ 0 (
    echo [OK] Startup entry removed
)
goto :EOF

:REMOVE_SCHEDULED_SILENT
schtasks /delete /tn "ThemeToggle-Morning" /f >nul 2>&1
if !errorlevel! equ 0 (
    echo [OK] Morning task removed
)
schtasks /delete /tn "ThemeToggle-Evening" /f >nul 2>&1
if !errorlevel! equ 0 (
    echo [OK] Evening task removed
)
goto :EOF

:END
echo.
echo Thank you for using ThemeToggle!
echo.
echo For more options, see AUTOMATION_GUIDE.md
echo.
REM Restore original directory
popd
pause
endlocal
exit /b 0
