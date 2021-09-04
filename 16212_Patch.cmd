@echo off
title 16212 Patches by Empyreal96
:home
cd /d "%~dp0"

echo Make sure you have connected to Mass Storage Mode on the device!
echo Make sure you have launched this script as Administrator!
echo.
echo Please Enter The Drive Letter for "MainOS"
echo example: g
echo.
set /p OSDrive=:
if /i "%OSDrive%" == "" goto home
goto Apply

:Apply
reg load HKLM\RTSoftware "%OSDrive%:\Windows\System32\Config\SOFTWARE"
reg add "HKEY_LOCAL_MACHINE\RTSoftware\Microsoft\Windows\CurrentVersion\AppModelUnlock" /v AllowAllTrustedApps /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\RTSoftware\Microsoft\Windows\CurrentVersion\AppModelUnlock" /v AllowDevelopmentWithoutDevLicense /t REG_DWORD /d 1 /f
reg unload HKLM\RTSoftware

pause
exit







:: Developer Mode .reg edits
:: [HKEY_LOCAL_MACHINE\RTSoft\Microsoft\Windows\CurrentVersion\AppModelUnlock]
:: "AllowAllTrustedApps"=dword:00000001
:: "AllowDevelopmentWithoutDevLicense"=dword:00000001
::
:: [HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Appx]
:: "AllowAllTrustedApps"=dword:00000001
:: "AllowDevelopmentWithoutDevLicense"=dword:00000001
::