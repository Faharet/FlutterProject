@rem Event
@echo off
::Берем значения с конфига
for /f "tokens=1,2 delims==" %%a in (E:\flutterfiles\lib\configTimeStart.ini) do (
    if %%a==mytime set mytime=%%b
)
schtasks /create /sc weekly /d SAT /tn hardtime /sd %date% /st %mytime% /tr c:\Windows\System32\bat.bat