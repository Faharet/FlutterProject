for /f "tokens=1,2 delims==" %%a in (C:\Users\smartassraty\FlutterProject\lib\scripts\config.ini) do (
    if %%a==mytime set mytime=%%b
    if %%a==script set script=%%b
)
schtasks /create /sc weekly /d SAT /tn hardtime /sd %date% /st %mytime% /tr %scriptone%
echo %errorlevel%