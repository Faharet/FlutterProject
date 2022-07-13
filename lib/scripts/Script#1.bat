@rem Script for Nikolai
@echo off
for /f "tokens=1,2 delims==" %%a in (config.ini) do (
    if %%a==way set way=%%b
    if %%a==disk set disk=%%b
)
cd %way%
ForFiles /p "%way%" /s /c "cmd /c del @file /f /q" /d -60
cd /d C:\Users\user2\FlutterProject\lib\scripts
start diskejecter.exe \\.\%disk% true
xcopy * %disk%
start diskejecter.exe \\.\%disk% false
pause