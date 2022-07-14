@rem Script for Nikolai
@echo off
for /f "tokens=1,2 delims==" %%a in (C:\Users\smartassraty\FlutterProject\lib\scripts\config.ini) do (
    if %%a==wayToFiles set wayToFiles=%%b
    if %%a==wayToDisk set wayToDisk=%%b
    if %%a==disk set disk=%%b
)
cd %wayToFiles%
ForFiles /p "%wayToFiles%" /s /c "cmd /c del @file /f /q" /d -60
cd /d C:\Users\user2\FlutterProject\lib\scripts
start C:\Users\smartassraty\FlutterProject\lib\scripts\load.exe \\.\%disk%
echo %errorlevel%
xcopy * %wayToDisk%
echo %errorlevel%
start C:\Users\smartassraty\FlutterProject\lib\scripts\eject.exe \\.\%disk%
echo %errorlevel%
pause