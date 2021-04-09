@echo off

:: directory of script
SET directory=%~dp0

:: powershell script
SET psscript=%directory%awesome-mc-server-builder.ps1

echo "       __      _    "
echo "|___| |__ |   |_)  ."
echo "|   | |__ |__ |    ."

powershell -c "get-help %psscript% -full"

timeout 5

:: basic usage
powershell -c "%psscript%"
