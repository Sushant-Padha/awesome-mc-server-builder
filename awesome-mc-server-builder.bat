@echo off

:: directory of script
SET directory=%~dp0

:: powershell script
SET psscript=%directory%awesome-mc-server-builder.ps1

timeout 3

:: basic usage
powershell -c "%psscript%"
