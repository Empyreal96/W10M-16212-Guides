@echo off
title 16212 Patches by Empyreal96

echo Requesting Administrative Rights.


:init
 setlocal DisableDelayedExpansion
 set cmdInvoke=1
 set winSysFolder=System32
 set "batchPath=%~0"
 for %%k in (%0) do set batchName=%%~nk
 set "vbsGetPrivileges=%temp%\OEgetPriv_%batchName%.vbs"
 setlocal EnableDelayedExpansion

:checkPrivileges
  NET FILE 1>NUL 2>NUL
  if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )

:getPrivileges
  if '%1'=='ELEV' (echo ELEV & shift /1 & goto gotPrivileges)
  ECHO.
  ECHO.
  ECHO Invoking UAC for Privilege Escalation
  ECHO.

  ECHO Set UAC = CreateObject^("Shell.Application"^) > "%vbsGetPrivileges%"
  ECHO args = "ELEV " >> "%vbsGetPrivileges%"
  ECHO For Each strArg in WScript.Arguments >> "%vbsGetPrivileges%"
  ECHO args = args ^& strArg ^& " "  >> "%vbsGetPrivileges%"
  ECHO Next >> "%vbsGetPrivileges%"

  if '%cmdInvoke%'=='1' goto InvokeCmd 

  ECHO UAC.ShellExecute "!batchPath!", args, "", "runas", 1 >> "%vbsGetPrivileges%"
  goto ExecElevation

:InvokeCmd
  ECHO args = "/c """ + "!batchPath!" + """ " + args >> "%vbsGetPrivileges%"
  ECHO UAC.ShellExecute "%SystemRoot%\%winSysFolder%\cmd.exe", args, "", "runas", 1 >> "%vbsGetPrivileges%"

:ExecElevation
 "%SystemRoot%\%winSysFolder%\WScript.exe" "%vbsGetPrivileges%" %*
 exit /B

:gotPrivileges
 setlocal & cd /d %~dp0
 if '%1'=='ELEV' (del "%vbsGetPrivileges%" 1>nul 2>nul  &  shift /1)


rem cd /d "%~dp0"

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
echo Loading W10M Registry
reg load HKLM\RTSoftware "%OSDrive%:\Windows\System32\Config\SOFTWARE"
reg load HKLM\RTSystem "%OSDrive%:\Windows\System32\Config\SYSTEM"
echo Enabling Developer Mode
reg add "HKEY_LOCAL_MACHINE\RTSoftware\Microsoft\Windows\CurrentVersion\AppModelUnlock" /v AllowAllTrustedApps /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\RTSoftware\Microsoft\Windows\CurrentVersion\AppModelUnlock" /v AllowDevelopmentWithoutDevLicense /t REG_DWORD /d 1 /f
echo Enabling Device Portal
reg add "HKEY_LOCAL_MACHINE\RTSystem\ControlSet001\Services\WebManagement" /v Start /t REG_DWORD /d 2 /f
reg add "HKEY_LOCAL_MACHINE\RTSoftware\Microsoft\Windows\CurrentVersion\WebManagement\Authentication" /v Disabled /t REG_DWORD /d 1 /f
echo Unloading Registry
reg unload HKLM\RTSoftware
reg unload HKLM\RTSystem

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