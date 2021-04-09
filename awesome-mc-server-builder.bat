@echo off

:: directory of script
SET directory=%~dp0

echo "HELP -->"

echo "       __      _    "
echo "|___| |__ |   |_)  ."
echo "|   | |__ |__ |    ."

powershell -c "%directory%\awesome-mc-server-builder.ps1 -?"
