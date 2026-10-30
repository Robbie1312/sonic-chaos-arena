@echo off
rem Sonic Chaos Arena - Windows launcher. If Python is installed it starts a tiny local web server (so the game's
rem recorder works) and opens the game; otherwise it just opens the game file. Close this window when you're done.
cd /d "%~dp0"
set PORT=8765
set GAME=sonic-chaos-arena.html
set PY=
where py >nul 2>nul
if not errorlevel 1 set PY=py
if "%PY%"=="" (
  where python >nul 2>nul
  if not errorlevel 1 set PY=python
)
if not "%PY%"=="" (
  %PY% -c "import http.server" >nul 2>nul
  if errorlevel 1 set PY=
)
rem (the Microsoft Store "python" stub fails that check, so it falls back to opening the file)
if "%PY%"=="" (
  start "" "%GAME%"
  exit /b
)
echo Sonic Chaos Arena is running at http://localhost:%PORT%/%GAME%
echo Keep this window open while you play. Close it when you're done.
start "" cmd /c "timeout /t 2 /nobreak >nul & start "" http://localhost:%PORT%/%GAME%"
%PY% -m http.server %PORT% --bind 127.0.0.1 >nul 2>nul
