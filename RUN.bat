@echo off
:: Elevate to Administrator if not already
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process cmd -ArgumentList '/c %~f0' -Verb RunAs"
    exit /b
)

:: Set PowerShell execution policy for CurrentUser
powershell -NoProfile -Command "Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force"

:: Run the Install.ps1 script
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Install.ps1"

pause