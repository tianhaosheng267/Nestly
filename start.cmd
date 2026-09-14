@echo off
setlocal
cd /d "%~dp0"
where ruby.exe >nul 2>&1
if errorlevel 1 (
  if exist "C:\Ruby33-x64\bin\ruby.exe" (
    set "PATH=C:\Ruby33-x64\bin;%PATH%"
  ) else (
    echo Ruby was not found. Install Ruby+Devkit 3.3 and reopen your terminal.
    exit /b 1
  )
)
echo Starting Nestly at http://127.0.0.1:3000
echo Press Ctrl+C to stop.
ruby bin/rails server -b 127.0.0.1 %*
exit /b %errorlevel%
