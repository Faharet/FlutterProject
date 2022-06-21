@rem My First bat
@echo off
chcp 850
::Берем переменные с конфига
for /f "tokens=1,2 delims==" %%a in (E:\flutterfiles\lib\configProcess.ini) do (
	if %%a==processname set processname=%%b
)
set /A c = 1
:loop
	if %c%==1 goto On
	if %c%==2 goto Off
:On
	echo Started On
	tasklist | findstr "%processname%"
	if errorlevel 1 goto On
	set /A c = 2
	goto Done
:Off
	echo Started Off
	tasklist | findstr "%processname%"
	if errorlevel 1 goto exit
	goto Off
:Offin
	set /A c = 1
:Done
goto loop
::diskpart /s lis dis
:exit