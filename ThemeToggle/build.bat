@echo off
REM Build script for ThemeToggle.exe with embedded manifest

REM Save current directory and switch to script directory
pushd "%~dp0"

echo Building ThemeToggle (Release)...
echo.

REM Clean previous build artifacts
echo [0/3] Cleaning...
del *.obj *.res "*.lnk" 2>nul

REM Step 1: Compile resource file
echo [1/3] Compiling resources (with themetoggle_dark.ico)...
rc ThemeToggle.rc
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Resource compilation failed!
    popd
    exit /b 1
)

REM Step 2: Compile C++ and link with resources (Release build)
echo [2/3] Compiling and linking (Release: /O2 /MT /DNDEBUG)...
cl /EHsc /std:c++17 /W4 /O2 /MT /DNDEBUG main.cpp ThemeToggle.res /Fe:ThemeToggle.exe user32.lib advapi32.lib
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Compilation failed!
    popd
    exit /b 1
)

REM Step 3: Cleanup intermediate files
echo [3/3] Cleaning up...
del main.obj 2>nul
del ThemeToggle.res 2>nul

echo.
echo ===================================
echo Build completed successfully!
echo ===================================
echo.
echo Output: ThemeToggle.exe (with embedded icon)
echo   Size: ~220 KB (Release build with static runtime)
echo   Icon: themetoggle_dark.ico (embedded)
echo.
echo Available launchers:
echo   ThemeToggle.vbs    - Silent toggle
echo   ThemeToggle-Light.vbs  - Silent light mode
echo ThemeToggle-Dark.vbs   - Silent dark mode
echo   ThemeToggle.ps1      - PowerShell version
echo.
echo Quick start:
echo   1. Double-click ThemeToggle.vbs to toggle silently
echo   2. Run setup.bat for automatic configuration
echo   3. See QUICK_REFERENCE.md for all options
echo.
echo The executable now includes:
echo   * Custom dark theme icon (embedded)
echo   * Windows manifest (for instant theme updates)
echo   * Version information
echo   * Release optimizations (/O2)
echo   * Static runtime (/MT - no DLL dependencies)
echo.
echo Usage examples:
echo   ThemeToggle.exe  - Toggle theme (console)
echo   ThemeToggle.exe /light    - Force light theme
echo   ThemeToggle.exe /dark     - Force dark theme
echo   ThemeToggle.vbs           - Toggle silently (no console)
echo.

REM Restore original directory
popd
