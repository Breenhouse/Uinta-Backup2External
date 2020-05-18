@echo off
title Uinta - Backup
color 17

REM Updated 3/2/20
REM The purpose of this script is to back up the usual data from a user onto an external drive.
REM This script MUST be ran from an external drive.


REM Checks admin permissions.
net session >nul 2>&1
if %errorLevel% == 0 (
    echo Success: Administrative permissions confirmed.
) else (
    echo Failure: Current permissions inadequate. This script must be ran as admin.
    pause
    exit
)


cls

echo        **********************
echo        * Uinta Technologies *
echo        **********************
echo.
echo This script MUST be ran from an external drive while
echo also logged into the target user's profile. Otherwise,
echo some grave errors may happen. So double check.
echo.
echo Close out of all applications, or some data may not
echo copy correctly.
echo.
echo Compatible with Windows 7 and newer.
echo.
echo This script will: 
echo * Create the default folder structure
echo * Copy background
echo * Copy Chrome app data
echo * Copy Firefox app data
echo * Copy Microsoft Signatures app data
echo * Copy Google Earth Pro app data
echo * Copy Sticky Notes app data
echo * Copy user profile
echo.
echo Be sure to double check that you have all necessary data
echo backed up after using this script.
echo.
pause

cls

REM If not on C: or D: drive, will start copy.

if %~d0==C: (
    goto :driveChecking
)

if %~d0==D: ( 
    goto :driveChecking
) else (
    goto :copyFiles
)


:driveChecking

REM Checks that this script is not running off of the C: drive.
if %~d0==C: (
    echo ERROR: Detected that this script is running somewhere on the C: drive.
    echo.
    echo This script MUST be ran from an external drive.
    echo.
    pause
    exit
)

REM If D: drive, double checks with technician that it's an external drive.
if %~d0==D: (
    echo Detected that this script is running somewhere on a D: drive. Please make sure
    echo that the D: drive is an external backup drive.
    echo.
    set /p dDrive="If the D: drive is an external drive, type 'y' and press enter: "
)
    
if %dDrive%==y (
    goto :copyFiles
) 

if not %dDrive%==y (
    cls
    echo You've indicated that the D: drive is NOT an external drive.
    echo This script will exit.
    echo.
    pause
    exit
)


REM Copy files

goto :copyFiles

:copyFiles

cls

REM Create directories.

set /p clientCode="Enter client code: "
set /p clientName="Enter client name: "

cls

set clientDir=%~d0\%clientCode%\%clientName%

echo Creating directories...

REM Creates base directory.
if not exist "%clientDir%" (
    mkdir "%clientDir%"
) else (
    echo "%clientDir%" already exists.
)

REM Creates C: folder and old PC folder.
if not exist "%~d0\%clientCode%\%clientName%\C\OLDPC" (
    mkdir "%~d0\%clientCode%\%clientName%\C\OLDPC"
) else (
    echo "%~d0\%clientCode%\%clientName%\C\OLDPC" already exists.
)

REM Creates user and 111-APPDATA folder.
if not exist "%clientDir%\Users\%USERNAME%\111-APPDATA" (
    mkdir "%clientDir%\Users\%USERNAME%\111-APPDATA"
) else (
    echo "%clientDir%\Users\%USERNAME%\111-APPDATA" already exists.
)
set appDataDir=%clientDir%\Users\%USERNAME%\111-APPDATA


REM Copy AppData to external.

REM Background
if exist "%APPDATA%\Microsoft\Windows\Themes\TranscodedWallpaper.jpg" (
    echo Copying background...
    mkdir "%appDataDir%\Roaming\Microsoft\Windows\Themes"
    xcopy "%APPDATA%\Microsoft\Windows\Themes\TranscodedWallpaper.jpg" "%appDataDir%\Roaming\Microsoft\Windows\Themes\" /G /Q /K /H
)

if exist "%APPDATA%\Microsoft\Windows\Themes\TranscodedWallpaper" (
    echo Copying background...
    mkdir "%appDataDir%\Roaming\Microsoft\Windows\Themes"
    echo F|xcopy "%APPDATA%\Microsoft\Windows\Themes\TranscodedWallpaper" "%appDataDir%\Roaming\Microsoft\Windows\Themes\TranscodedWallpaper.jpg"
)

REM Chrome
if exist "%LOCALAPPDATA%\Google\Chrome\User Data\Default" (
    echo Copying Google Chrome app data...
    mkdir "%appDataDir%\Local\Google\Chrome\User Data\Default"
    xcopy "%LOCALAPPDATA%\Google\Chrome\User Data\Default" "%appDataDir%\Local\Google\Chrome\User Data\Default" /I /S /G /Q /K /H
) else (
    echo Google Chrome app data not detected.
)

REM Firefox
if exist "%APPDATA%\Mozilla\Firefox\Profiles\" (
    echo Copying Mozilla Firefox app data...
    mkdir "%appDataDir%\Roaming\Mozilla\Firefox\Profiles"
    xcopy "%APPDATA%\Mozilla\Firefox\Profiles" "%appDataDir%\Roaming\Mozilla\Firefox\Profiles" /I /S /G /Q /K /H
) else (
    echo Mozilla Firefox app data not detected.
)

REM Microsoft Signatures
if exist "%APPDATA%\Microsoft\Signatures" (
    echo Copying Microsoft Signatures app data...
    mkdir "%appDataDir%\Roaming\Microsoft\Signatures"
    xcopy "%APPDATA%\Microsoft\Signatures" "%appDataDir%\Roaming\Microsoft\Signatures" /I /S /G /Q /K /H
) else (
    echo Microsoft Signatures app data not detected.
)

REM Google Earth Pro
if exist "%USERPROFILE%\AppData\LocalLow\Google\GoogleEarth" (
    echo Copying Google Earth Pro app data...
    mkdir "%appDataDir%\LocalLow\Google\GoogleEarth"
    xcopy "%USERPROFILE%\AppData\LocalLow\Google\GoogleEarth" "%appDataDir%\LocalLow\Google\GoogleEarth" /I /S /G /Q /K /H
) else (
    echo Google Earth Pro app data not detected.
)

REM PST files
if exist "%LOCALAPPDATA%\Microsoft\Outlook\*.pst" (
    echo Copying PST files...
    mkdir "%appDataDir%\Local\Microsoft\Outlook"
    xcopy "%LOCALAPPDATA%\Microsoft\Outlook\*.pst" "%appDataDir%\Local\Microsoft\Outlook" /G /Q /K /H
) else (
    echo No PST files detected in app data.
)

REM Sticky Notes
if exist "%LOCALAPPDATA%\Packages\Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe" (
    echo Copying Microsoft Sticky Notes app data...
    mkdir "%appDataDir%\Local\Packages\Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe"
    xcopy "%LOCALAPPDATA%\Packages\Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe" "%appDataDir%\Local\Packages\Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe" /I /S /G /Q /K /H
) else (
    echo Microsoft Sticky Notes app data not detected.
)


REM Copies user profile to external.
echo Copying user profile. This could take a while, be patient...
xcopy "%USERPROFILE%" "%clientDir%\Users\%USERNAME%" /E /I /S /K /G /Q /J


REM End
echo.
echo -----------------------
echo.
echo Script completed!
echo.
echo Be sure to manually copy any necessary C: drive items and
echo double check that all required data has been backed up.
echo.
pause

exit