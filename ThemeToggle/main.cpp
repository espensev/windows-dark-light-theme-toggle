//# AutoHide Task View v1.2  (2025-11-07)
//# Author: espsev
#include <windows.h>
#include <iostream>
#include <string>
#include <string_view>
#include <sstream>
#include <algorithm>
#include <cctype>
#include <optional>

// RAII wrapper for registry keys
struct RegKey {
    HKEY hKey = nullptr;

    RegKey() = default;

    // No copying
    RegKey(const RegKey&) = delete;
    RegKey& operator=(const RegKey&) = delete;

    // Allow move operations
    RegKey(RegKey&& other) noexcept : hKey(other.hKey) {
        other.hKey = nullptr;
    }

    RegKey& operator=(RegKey&& other) noexcept {
        if (std::addressof(other) != this) {
            Close();
            hKey = other.hKey;
            other.hKey = nullptr;
        }
        return *this;
    }

    ~RegKey() {
        Close();
    }

    // Explicit open method - clearer semantics than operator&
    LONG Open(HKEY root, std::wstring_view path, REGSAM access) {
        Close();
        return RegOpenKeyExW(root, path.data(), 0, access, &hKey);
    }

    // Create or open - handles missing keys gracefully
    // Access rights specified by caller based on intended use
    LONG CreateOrOpen(HKEY root, std::wstring_view path, REGSAM access) {
        Close();
        return RegCreateKeyExW(root, path.data(), 0, nullptr,
            REG_OPTION_NON_VOLATILE, access, nullptr, &hKey, nullptr);
    }
  
    operator HKEY() const { return hKey; }
    bool IsValid() const { return hKey != nullptr; }
    
    void Close() {
        if (hKey) {
            RegCloseKey(hKey);
            hKey = nullptr;
        }
    }
};

// Exit code enum for clarity and type safety
enum class ExitCode : int {
    SuccessNoChange = 0,
    ChangedToLight = 1,
    ChangedToDark = 2,
    RegKeyCreateFailed = 10,
    RegWriteFailed = 11,
    BroadcastFailed = 20
};

struct ThemeInfo {
    DWORD oldSystemValue;
    DWORD newValue;
    std::string theme;
    bool changed;
    bool broadcastOk;
    ExitCode exitCode;
};

class WindowsThemeToggler {
private:
    static constexpr std::wstring_view REG_KEY_PATH = L"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize";
    static constexpr std::wstring_view SYSTEM_VALUE_NAME = L"SystemUsesLightTheme";
    static constexpr std::wstring_view APPS_VALUE_NAME = L"AppsUseLightTheme";
    static constexpr WORD DEFAULT_CONSOLE_COLOR = FOREGROUND_RED | FOREGROUND_GREEN | FOREGROUND_BLUE;
    static constexpr UINT BROADCAST_TIMEOUT_MS = 50;  // Semantic clarity for broadcast timeout

    bool quiet;
    bool passThru;
    HANDLE hConsole;  // Cached console handle

    // Get registry value with error checking - returns optional for better error handling
    std::optional<DWORD> GetRegistryValue(HKEY hKey, std::wstring_view valueName) {
        DWORD dataSize = sizeof(DWORD);
        DWORD type = 0;
        DWORD value = 0;
        LONG result = RegQueryValueExW(hKey, valueName.data(), nullptr, &type,
            reinterpret_cast<LPBYTE>(&value), &dataSize);
        
        if (result == ERROR_SUCCESS && type == REG_DWORD && dataSize == sizeof(DWORD)) {
            return value;
        }
        return std::nullopt;  // Missing registry value is recoverable, not exceptional
    }

    // Set registry value
    bool SetRegistryValue(HKEY hKey, std::wstring_view valueName, DWORD value) {
        LONG result = RegSetValueExW(hKey, valueName.data(), 0, REG_DWORD,
            reinterpret_cast<const BYTE*>(&value), sizeof(DWORD));
        return result == ERROR_SUCCESS;
    }

    // Broadcast theme change to all windows
    // Returns false only if both broadcasts completely fail (rare)
    bool BroadcastThemeChange() {
        // Fire-and-forget async broadcasts with minimal wait
        // Uses SMTO_ABORTIFHUNG to prevent blocking on hung windows
        // BROADCAST_TIMEOUT_MS is enough for Explorer to receive without noticeable delay
        DWORD_PTR result = 0;
        
        // Cast safely to avoid const warnings from static analyzers
        LPARAM immersiveParam = reinterpret_cast<LPARAM>(static_cast<const void*>(L"ImmersiveColorSet"));
        LPARAM colorizationParam = reinterpret_cast<LPARAM>(static_cast<const void*>(L"ColorizationColor"));
  
        // Broadcast theme change - check return value
        LRESULT ret1 = SendMessageTimeoutW(
            HWND_BROADCAST,
            WM_SETTINGCHANGE,
            0,
            immersiveParam,
            SMTO_ABORTIFHUNG | SMTO_NOTIMEOUTIFNOTHUNG,
            BROADCAST_TIMEOUT_MS,
            &result
        );

        // Also broadcast colorization change for immediate taskbar/border updates
        LRESULT ret2 = SendMessageTimeoutW(
            HWND_BROADCAST,
            WM_SETTINGCHANGE,
            0,
            colorizationParam,
            SMTO_ABORTIFHUNG | SMTO_NOTIMEOUTIFNOTHUNG,
            BROADCAST_TIMEOUT_MS,
            &result
        );

        // Return true if at least one broadcast succeeded
        // Both failing is extremely rare and indicates system issues
        return (ret1 != 0 || ret2 != 0);
    }

    void PrintMessage(const std::string& message, bool isWarning = false) {
        if (!quiet) {
            // Use cached console handle
            if (hConsole != INVALID_HANDLE_VALUE && hConsole != nullptr) {
                if (isWarning) {
                    SetConsoleTextAttribute(hConsole, FOREGROUND_RED | FOREGROUND_GREEN | FOREGROUND_INTENSITY);
                    std::cout << "Warning: ";
                }
                else {
                    SetConsoleTextAttribute(hConsole, FOREGROUND_GREEN | FOREGROUND_BLUE | FOREGROUND_INTENSITY);
                }
                std::cout << message << std::endl;
                SetConsoleTextAttribute(hConsole, DEFAULT_CONSOLE_COLOR);
            }
            else {
                // Fallback for redirected output (no color codes)
                if (isWarning) {
                    std::cout << "Warning: ";
                }
                std::cout << message << std::endl;
            }
        }
    }

public:
    WindowsThemeToggler(bool quiet = false, bool passThru = false)
        : quiet(quiet), passThru(passThru) {
        // Cache console handle once - check if it's actually a console
        hConsole = GetStdHandle(STD_OUTPUT_HANDLE);
        if (hConsole != INVALID_HANDLE_VALUE && hConsole != nullptr) {
            DWORD mode;
            // If GetConsoleMode fails, output is redirected (pipe/file)
            if (!GetConsoleMode(hConsole, &mode)) {
                hConsole = nullptr;  // Disable color output for redirected streams
            }
        }
    }

    ThemeInfo SetWindowsTheme(bool forceLight, bool forceDark, bool /*toggle*/) {
        ThemeInfo info = { 0 };
        info.exitCode = ExitCode::SuccessNoChange;

        // Step 1: Open registry key with read-only access first (faster)
        RegKey keyRead;
        LONG result = keyRead.Open(HKEY_CURRENT_USER, REG_KEY_PATH, KEY_READ);

        if (result != ERROR_SUCCESS) {
            // Key doesn't exist
            info.exitCode = ExitCode::RegKeyCreateFailed;
            throw std::runtime_error("Failed to open registry key - theme settings may not exist");
        }

        // Get current values with error checking - use optional for missing values
        auto sysValueOpt = GetRegistryValue(keyRead, SYSTEM_VALUE_NAME);
        auto appsValueOpt = GetRegistryValue(keyRead, APPS_VALUE_NAME);

        // Close read-only handle immediately
        keyRead.Close();

        // If values don't exist, default to dark (0) - missing values are recoverable
        DWORD currSystem = sysValueOpt.value_or(0);
        DWORD currApps = appsValueOpt.value_or(0);

        info.oldSystemValue = currSystem;

        // Decide new target value
        DWORD newValue;
        if (forceLight) {
            newValue = 1;
        }
        else if (forceDark) {
            newValue = 0;
        }
        else {
            // Toggle based on system value
            newValue = (currSystem == 1) ? 0 : 1;
        }

        // Short-circuit: If no change needed, exit early without opening for write
        // However, still broadcast to ensure UI sync in case apps are out of date
        if (currSystem == newValue) {
            info.newValue = newValue;
            info.changed = false;
            info.theme = (newValue == 1) ? "Light" : "Dark";
            info.exitCode = ExitCode::SuccessNoChange;
        
            // Broadcast anyway to ensure all apps are synchronized with registry
            // Some apps may have missed previous broadcasts or were started after theme change
            info.broadcastOk = BroadcastThemeChange();
            
            if (!quiet) {
                std::ostringstream msg;
                msg << "Already " << info.theme << " theme.";
                PrintMessage(msg.str());
            }
         
            return info;
        }

        info.newValue = newValue;
        info.changed = true;
        info.theme = (newValue == 1) ? "Light" : "Dark";

        // Step 2: Create or open with write access - handles missing keys
        RegKey keyWrite;
        result = keyWrite.CreateOrOpen(HKEY_CURRENT_USER, REG_KEY_PATH, KEY_WRITE);

        if (result != ERROR_SUCCESS) {
            info.exitCode = ExitCode::RegKeyCreateFailed;
            throw std::runtime_error("Failed to open registry key for writing");
        }

        // Write to registry
        bool writeSuccess = SetRegistryValue(keyWrite, SYSTEM_VALUE_NAME, newValue) &&
            SetRegistryValue(keyWrite, APPS_VALUE_NAME, newValue);

        // Close write handle immediately after writing
        keyWrite.Close();

        if (!writeSuccess) {
            info.exitCode = ExitCode::RegWriteFailed;
            throw std::runtime_error("Failed writing theme values");
        }

        // Broadcast change
        info.broadcastOk = BroadcastThemeChange();
        if (!info.broadcastOk) {
            info.exitCode = ExitCode::BroadcastFailed;
            PrintMessage("Broadcast failed - some apps may not update immediately", true);
        }
        else {
            info.exitCode = (newValue == 1) ? ExitCode::ChangedToLight : ExitCode::ChangedToDark;
        }

        // Print status message
        if (!quiet) {
            std::ostringstream msg;
            msg << "Changed to " << info.theme << " theme.";
            PrintMessage(msg.str());
        }

        return info;
    }

    void PrintThemeInfo(const ThemeInfo& info) {
        if (passThru) {
            std::cout << "OldSystemValue: " << info.oldSystemValue << std::endl;
            std::cout << "NewValue: " << info.newValue << std::endl;
            std::cout << "Theme: " << info.theme << std::endl;
            std::cout << "Changed: " << (info.changed ? "true" : "false") << std::endl;
            std::cout << "BroadcastOk: " << (info.broadcastOk ? "true" : "false") << std::endl;
        }
    }

    // Public method for consistent error printing
    void PrintError(const std::string& message) {
        PrintMessage(message, true);
    }
};

void PrintUsage() {
    std::cout << "Usage: ThemeToggle.exe [options]\n\n"
        << "Options:\n"
        << "  /light       Force light theme\n"
        << "  /dark        Force dark theme\n"
        << "  /toggle      Toggle current theme (default)\n"
        << "  /quiet       Suppress output\n"
        << "  /passthru    Return detailed information\n"
        << "  /exitcode    Map result to exit code\n\n"
        << "Exit Codes (when /exitcode is used):\n"
        << "  0  = Success (no change)\n"
        << "  1  = Changed to Light\n"
        << "  2  = Changed to Dark\n"
        << "  10 = Registry key creation failed\n"
        << "  11 = Registry write failed\n"
        << "  20 = Broadcast failed but registry ok\n";
}

int main(int argc, char* argv[]) {
    bool forceLight = false;
    bool forceDark = false;
    bool toggle = false;
    bool quiet = false;
    bool passThru = false;
    bool asExitCode = false;

    // Parse command-line arguments
    for (int i = 1; i < argc; ++i) {
        std::string arg = argv[i];

        // Convert to lowercase for case-insensitive comparison - cleaner with std::transform
        std::transform(arg.begin(), arg.end(), arg.begin(),
            [](unsigned char c) { return std::tolower(c); });

        if (arg == "/light" || arg == "-light") {
            forceLight = true;
        }
        else if (arg == "/dark" || arg == "-dark") {
            forceDark = true;
        }
        else if (arg == "/toggle" || arg == "-toggle") {
            toggle = true;
        }
        else if (arg == "/quiet" || arg == "-quiet") {
            quiet = true;
        }
        else if (arg == "/passthru" || arg == "-passthru") {
            passThru = true;
        }
        else if (arg == "/exitcode" || arg == "-exitcode") {
            asExitCode = true;
        }
        else if (arg == "/?" || arg == "-?" || arg == "/help" || arg == "-help") {
            PrintUsage();
            return 0;
        }
    }

    // Default to toggle if nothing specified
    if (!forceLight && !forceDark && !toggle) {
        toggle = true;
    }

    try {
        WindowsThemeToggler toggler(quiet, passThru);
        ThemeInfo info = toggler.SetWindowsTheme(forceLight, forceDark, toggle);
        toggler.PrintThemeInfo(info);
        
        // Handle exit code in main - safer than calling exit() from library code
        if (asExitCode) {
            return static_cast<int>(info.exitCode);
        }
    }
    catch (const std::exception& ex) {
        // Use consistent error output through PrintMessage system
        // This respects quiet mode and provides colored output when available
        if (!quiet) {
            WindowsThemeToggler errorPrinter(false, false);
            errorPrinter.PrintError(std::string("Error: ") + ex.what());
        }
        else {
            // Always output to stderr for automation/scripting even in quiet mode
            std::cerr << "Error: " << ex.what() << std::endl;
        }
        
        // Return appropriate error code even when exception occurs
        if (asExitCode) {
            return 10;  // Generic error - RegKeyCreateFailed is most common
        }
        return 1;
    }

    return 0;
}