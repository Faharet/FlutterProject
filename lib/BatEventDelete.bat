@rem Update Event
@echo off
::Берем значения с конфига
for /f "tokens=1,2 delims==" %%a in (E:\flutterfiles\lib\config.ini) do (
    if %%a==mytime set mytime=%%b
)
schtasks /delete /tn hardtime /f
echo Succesfull delete