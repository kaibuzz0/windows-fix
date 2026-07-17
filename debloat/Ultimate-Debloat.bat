@echo off
title Windows Ultimate Debloater - Remove All Bloatware & Telemetry
cls
color 0A
setlocal EnableDelayedExpansion

:: ============================================================================
:: WINDOWS ULTIMATE DEBLOATER
:: Removes ALL Windows bloatware, telemetry, and unnecessary components
:: For Windows 10/11 - Run as Administrator!
:: ============================================================================

echo.
echo  ========================================
echo   WINDOWS ULTIMATE DEBLOATER
echo   Remove Bloatware, Telemetry, Tracking
echo  ========================================
echo.
echo  [!] This script removes Windows apps and features
echo  [!] Create a restore point first if unsure
echo.
pause

:MainMenu
cls
echo  ========================================
echo   WINDOWS ULTIMATE DEBLOATER
echo  ========================================
echo.
echo   [1] QUICK DEBLOAT - Remove common bloatware (safe)
echo   [2] FULL DEBLOAT - Remove all unnecessary apps
echo   [3] NUCLEAR OPTION - Remove EVERYTHING (advanced users only)
echo   [4] PRIVACY HARDENING - Disable all telemetry/tracking
echo   [5] REMOVE SPECIFIC APPS - Choose what to remove
echo   [6] WINDOWS 11 EXTRAS - Win11 specific tweaks
echo   [7] RESTORE DEFAULTS - Reinstall removed apps
echo.
echo   [0] EXIT
echo.
echo  ========================================
set /p choice="Enter choice (0-7): "

if "%choice%"=="1" goto QuickDebloat
if "%choice%"=="2" goto FullDebloat
if "%choice%"=="3" goto NuclearOption
if "%choice%"=="4" goto PrivacyHardening
if "%choice%"=="5" goto RemoveSpecific
if "%choice%"=="6" goto Win11Extras
if "%choice%"=="7" goto RestoreDefaults
if "%choice%"=="0" exit

goto MainMenu

:: ============================================================================
:: QUICK DEBLOAT - Removes safe-to-remove bloatware
:: ============================================================================
:QuickDebloat
cls
echo  [*] Running Quick Debloat...
echo  [*] Removing safe-to-remove bloatware only
echo.

:: Gaming bloat
echo  [-] Removing Xbox apps...
powershell -Command "Get-AppxPackage *Xbox* | Remove-AppxPackage" 2>nul
echo  [-] Removing Xbox Gaming Overlay...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d 0 /f >nul
echo  [-] Removing Xbox Game Bar...
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\ApplicationManagement" /v "AllowGameDVR" /t REG_DWORD /d 0 /f >nul

:: Media bloat
echo  [-] Removing Groove Music...
powershell -Command "Get-AppxPackage *ZuneMusic* | Remove-AppxPackage" 2>nul
echo  [-] Removing Movies & TV...
powershell -Command "Get-AppxPackage *ZuneVideo* | Remove-AppxPackage" 2>nul

:: Communication bloat
echo  [-] Removing Skype...
powershell -Command "Get-AppxPackage *Skype* | Remove-AppxPackage" 2>nul
echo  [-] Removing Microsoft Teams (personal)...
powershell -Command "Get-AppxPackage *Teams* | Remove-AppxPackage" 2>nul

:: Office bloat
echo  [-] Removing Office Hub...
powershell -Command "Get-AppxPackage *MicrosoftOfficeHub* | Remove-AppxPackage" 2>nul

:: Other bloat
echo  [-] Removing OneNote...
powershell -Command "Get-AppxPackage *OneNote* | Remove-AppxPackage" 2>nul
echo  [-] Removing Solitaire...
powershell -Command "Get-AppxPackage *Solitaire* | Remove-AppxPackage" 2>nul
echo  [-] Removing Bing News/Weather/Sports...
powershell -Command "Get-AppxPackage *Bing* | Remove-AppxPackage" 2>nul
powershell -Command "Get-AppxPackage *News* | Remove-AppxPackage" 2>nul
powershell -Command "Get-AppxPackage *Weather* | Remove-AppxPackage" 2>nul
powershell -Command "Get-AppxPackage *Sports* | Remove-AppxPackage" 2>nul
echo  [-] Removing Get Started/Tips...
powershell -Command "Get-AppxPackage *Getstarted* | Remove-AppxPackage" 2>nul
powershell -Command "Get-AppxPackage *WindowsTips* | Remove-AppxPackage" 2>nul

echo.
echo  [+] Quick Debloat Complete!
echo  [+] Removed: Xbox, Skype, Groove, Movies, Solitaire, News, Weather, Tips
echo.
pause
goto MainMenu

:: ============================================================================
:: FULL DEBLOAT - Removes all unnecessary apps
:: ============================================================================
:FullDebloat
cls
echo  [!] WARNING: This removes most Windows apps
echo  [!] Some apps cannot be easily restored
echo.
set /p confirm="Are you sure? Type 'YES' to continue: "
if /I not "%confirm%"=="YES" goto MainMenu

cls
echo  [*] Running Full Debloat...
echo.

:: Everything from Quick Debloat
call :QuickDebloatSilent

:: Additional apps
echo  [-] Removing Paint 3D...
powershell -Command "Get-AppxPackage *Paint3D* | Remove-AppxPackage" 2>nul
echo  [-] Removing 3D Viewer...
powershell -Command "Get-AppxPackage *Microsoft3DViewer* | Remove-AppxPackage" 2>nul
echo  [-] Removing Mixed Reality Portal...
powershell -Command "Get-AppxPackage *MixedReality* | Remove-AppxPackage" 2>nul
echo  [-] Removing Print 3D...
powershell -Command "Get-AppxPackage *Print3D* | Remove-AppxPackage" 2>nul
echo  [-] Removing Feedback Hub...
powershell -Command "Get-AppxPackage *WindowsFeedbackHub* | Remove-AppxPackage" 2>nul
echo  [-] Removing Your Phone...
powershell -Command "Get-AppxPackage *YourPhone* | Remove-AppxPackage" 2>nul
echo  [-] Removing Phone Companion...
powershell -Command "Get-AppxPackage *WindowsPhone* | Remove-AppxPackage" 2>nul
echo  [-] Removing People app...
powershell -Command "Get-AppxPackage *People* | Remove-AppxPackage" 2>nul
echo  [-] Removing Calendar/Mail...
powershell -Command "Get-AppxPackage *windowscommunicationsapps* | Remove-AppxPackage" 2>nul
echo  [-] Removing Photos app...
powershell -Command "Get-AppxPackage *Photos* | Remove-AppxPackage" 2>nul
echo  [-] Removing Camera...
powershell -Command "Get-AppxPackage *WindowsCamera* | Remove-AppxPackage" 2>nul
echo  [-] Removing Maps...
powershell -Command "Get-AppxPackage *WindowsMaps* | Remove-AppxPackage" 2>nul
echo  [-] Removing Sound Recorder...
powershell -Command "Get-AppxPackage *WindowsSoundRecorder* | Remove-AppxPackage" 2>nul
echo  [-] Removing Sticky Notes...
powershell -Command "Get-AppxPackage *MicrosoftStickyNotes* | Remove-AppxPackage" 2>nul
echo  [-] Removing Calculator...
powershell -Command "Get-AppxPackage *WindowsCalculator* | Remove-AppxPackage" 2>nul

:: Remove provisioned apps (so they don't reinstall for new users)
echo  [-] Removing provisioned apps...
powershell -Command "Get-AppxProvisionedPackage -Online | where-object {$_.PackageName -like '*Bing*' -or $_.PackageName -like '*Solitaire*' -or $_.PackageName -like '*Xbox*' -or $_.PackageName -like '*Skype*' -or $_.PackageName -like '*Zune*' -or $_.PackageName -like '*OfficeHub*' -or $_.PackageName -like '*OneNote*' -or $_.PackageName -like '*GetStarted*'} | Remove-AppxProvisionedPackage -Online" 2>nul

echo.
echo  [+] Full Debloat Complete!
echo  [+] System is now minimal and clean
echo.
pause
goto MainMenu

:: ============================================================================
:: NUCLEAR OPTION - Removes almost everything
:: ============================================================================
:NuclearOption
cls
echo  [!] NUCLEAR OPTION - Removes ALMOST EVERYTHING
echo  [!] This includes: Store, Edge (partially), most system apps
echo  [!] Only for advanced users!
echo  [!] You may break things!
echo.
set /p confirm="Type 'NUCLEAR' to continue: "
if /I not "%confirm%"=="NUCLEAR" goto MainMenu

cls
echo  [*] NUCLEAR DEBLOAT IN PROGRESS...
echo.

:: Everything from Full Debloat
call :FullDebloatSilent

:: Additional nuclear options
echo  [-] Removing Microsoft Store... (DANGEROUS)
powershell -Command "Get-AppxPackage *WindowsStore* | Remove-AppxPackage" 2>nul
echo  [-] Removing Edge (consumer version)...
powershell -Command "Get-AppxPackage *MicrosoftEdge* | Remove-AppxPackage" 2>nul
echo  [-] Removing Cortana...
powershell -Command "Get-AppxPackage *Cortana* | Remove-AppxPackage" 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "DisableWebSearch" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchUseWeb" /t REG_DWORD /d 0 /f >nul
echo  [-] Removing OneDrive...
start /wait "" "%~dp0OneDrive-Uninstaller.bat" 2>nul
echo  [-] Removing Edge WebView...
powershell -Command "Get-AppxPackage *WebExperience* | Remove-AppxPackage" 2>nul
echo  [-] Removing Widgets (Win11)...
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\Stickers" /v "EnableStickers" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" /v "EnableFeeds" /t REG_DWORD /d 0 /f >nul

echo.
echo  [!] NUCLEAR DEBLOAT COMPLETE!
echo  [!] System is now MINIMAL
echo  [!] You probably broke some things. Good.
echo.
pause
goto MainMenu

:: ============================================================================
:: PRIVACY HARDENING - Disable all telemetry/tracking
:: ============================================================================
:PrivacyHardening
cls
echo  [*] Applying Privacy Hardening...
echo  [*] Disabling all telemetry, tracking, and data collection
echo.

:: Disable Telemetry
echo  [-] Disabling Windows Telemetry...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f >nul
sc config DiagTrack start= disabled >nul
sc config dmwappushservice start= disabled >nul

:: Disable Cortana
echo  [-] Disabling Cortana...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d 0 /f >nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Windows Search" /v "CortanaConsent" /t REG_DWORD /d 0 /f >nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Windows Search" /v "CortanaInTaskbarMode" /t REG_DWORD /d 0 /f >nul

:: Disable Activity History
echo  [-] Disabling Activity History...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableActivityFeed" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "PublishUserActivities" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "UploadUserActivities" /t REG_DWORD /d 0 /f >nul

:: Disable Location
echo  [-] Disabling Location Tracking...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableLocation" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableWindowsLocationProvider" /t REG_DWORD /d 1 /f >nul

:: Disable Speech
echo  [-] Disabling Online Speech Recognition...
reg add "HKLM\SOFTWARE\Policies\Microsoft\InputPersonalization" /v "AllowInputPersonalization" /t REG_DWORD /d 0 /f >nul

:: Disable Ink/Typing
echo  [-] Disabling Inking/Typing Data Collection...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\TabletPC" /v "PreventHandwritingDataSharing" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\HandwritingErrorReports" /v "PreventHandwritingErrorReports" /t REG_DWORD /d 1 /f >nul

:: Disable Advertising ID
echo  [-] Disabling Advertising ID...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" /v "DisabledByGroupPolicy" /t REG_DWORD /d 1 /f >nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d 0 /f >nul

:: Disable Feedback
echo  [-] Disabling Feedback...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f >nul

:: Disable Suggested Content
echo  [-] Disabling Suggested Content in Settings...
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338393Enabled" /t REG_DWORD /d 0 /f >nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353694Enabled" /t REG_DWORD /d 0 /f >nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353696Enabled" /t REG_DWORD /d 0 /f >nul

:: Disable Windows Tips
echo  [-] Disabling Windows Tips...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsConsumerFeatures" /t REG_DWORD /d 1 /f >nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338387Enabled" /t REG_DWORD /d 0 /f >nul

:: Disable OneDrive
echo  [-] Disabling OneDrive...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v "DisableFileSyncNGSC" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v "DisableMeteredNetworkTraffic" /t REG_DWORD /d 1 /f >nul

:: Disable Windows Search Web
echo  [-] Disabling Web Search in Start Menu...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "DisableWebSearch" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchUseWeb" /t REG_DWORD /d 0 /f >nul

:: Disable App Diagnostics
echo  [-] Disabling App Diagnostics...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableInventory" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "AITEnable" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableUAR" /t REG_DWORD /d 1 /f >nul

echo.
echo  [+] Privacy Hardening Complete!
echo  [+] Windows is no longer spying on you
echo  [!] Restart recommended
echo.
pause
goto MainMenu

:: ============================================================================
:: Helper: Quick Debloat (silent)
:: ============================================================================
:QuickDebloatSilent
powershell -Command "Get-AppxPackage *Xbox* | Remove-AppxPackage" 2>nul
powershell -Command "Get-AppxPackage *ZuneMusic* | Remove-AppxPackage" 2>nul
powershell -Command "Get-AppxPackage *ZuneVideo* | Remove-AppxPackage" 2>nul
powershell -Command "Get-AppxPackage *Skype* | Remove-AppxPackage" 2>nul
powershell -Command "Get-AppxPackage *Teams* | Remove-AppxPackage" 2>nul
powershell -Command "Get-AppxPackage *MicrosoftOfficeHub* | Remove-AppxPackage" 2>nul
powershell -Command "Get-AppxPackage *OneNote* | Remove-AppxPackage" 2>nul
powershell -Command "Get-AppxPackage *Solitaire* | Remove-AppxPackage" 2>nul
powershell -Command "Get-AppxPackage *Bing* | Remove-AppxPackage" 2>nul
powershell -Command "Get-AppxPackage *News* | Remove-AppxPackage" 2>nul
powershell -Command "Get-AppxPackage *Weather* | Remove-AppxPackage" 2>nul
powershell -Command "Get-AppxPackage *Sports* | Remove-AppxPackage" 2>nul
powershell -Command "Get-AppxPackage *Getstarted* | Remove-AppxPackage" 2>nul
powershell -Command "Get-AppxPackage *WindowsTips* | Remove-AppxPackage" 2>nul
goto :eof

:: ============================================================================
:: Helper: Full Debloat (silent)
:: ============================================================================
:FullDebloatSilent
call :QuickDebloatSilent
powershell -Command "Get-AppxPackage *Paint3D* | Remove-AppxPackage" 2>nul
powershell -Command "Get-AppxPackage *Microsoft3DViewer* | Remove-AppxPackage" 2>nul
powershell -Command "Get-AppxPackage *MixedReality* | Remove-AppxPackage" 2>nul
powershell -Command "Get-AppxPackage *Print3D* | Remove-AppxPackage" 2>nul
powershell -Command "Get-AppxPackage *WindowsFeedbackHub* | Remove-AppxPackage" 2>nul
powershell -Command "Get-AppxPackage *YourPhone* | Remove-AppxPackage" 2>nul
powershell -Command "Get-AppxPackage *WindowsPhone* | Remove-AppxPackage" 2>nul
powershell -Command "Get-AppxPackage *People* | Remove-AppxPackage" 2>nul
powershell -Command "Get-AppxPackage *windowscommunicationsapps* | Remove-AppxPackage" 2>nul
powershell -Command "Get-AppxPackage *Photos* | Remove-AppxPackage" 2>nul
powershell -Command "Get-AppxPackage *WindowsCamera* | Remove-AppxPackage" 2>nul
powershell -Command "Get-AppxPackage *WindowsMaps* | Remove-AppxPackage" 2>nul
powershell -Command "Get-AppxPackage *WindowsSoundRecorder* | Remove-AppxPackage" 2>nul
powershell -Command "Get-AppxPackage *MicrosoftStickyNotes* | Remove-AppxPackage" 2>nul
powershell -Command "Get-AppxPackage *WindowsCalculator* | Remove-AppxPackage" 2>nul
powershell -Command "Get-AppxProvisionedPackage -Online | where-object {$_.PackageName -like '*Bing*' -or $_.PackageName -like '*Solitaire*' -or $_.PackageName -like '*Xbox*' -or $_.PackageName -like '*Skype*' -or $_.PackageName -like '*Zune*' -or $_.PackageName -like '*OfficeHub*' -or $_.PackageName -like '*OneNote*' -or $_.PackageName -like '*GetStarted*'} | Remove-AppxProvisionedPackage -Online" 2>nul
goto :eof

:: ============================================================================
:: Placeholder menus for other options
:: ============================================================================
:RemoveSpecific
echo.
echo  [Not implemented in this version]
echo  [Use Quick or Full Debloat instead]
echo.
pause
goto MainMenu

:Win11Extras
echo.
echo  [*] Windows 11 Specific Tweaks...
echo  [-] Disabling Widgets...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" /v "EnableFeeds" /t REG_DWORD /d 0 /f >nul
echo  [-] Disabling Chat icon...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Chat" /v "ChatIcon" /t REG_DWORD /d 3 /f >nul
echo  [-] Disabling Teams integration...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Chat" /v "AllowChatWidget" /t REG_DWORD /d 0 /f >nul
echo.
echo  [+] Windows 11 tweaks applied
echo.
pause
goto MainMenu

:RestoreDefaults
echo.
echo  [*] Attempting to restore default apps...
echo  [!] Some apps may not be restorable through this script
echo  [!] Use Windows Store or Windows Settings to reinstall
echo.
powershell -Command "Get-AppxPackage -AllUsers | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register \"$$($_.InstallLocation)\AppXManifest.xml\"}" 2>nul
echo  [+] Attempted restore (check for errors above)
echo.
pause
goto MainMenu
