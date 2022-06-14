@rem My First bat
@echo off
::Берем переменные с конфига
for /f "tokens=1,2 delims==" %%a in (E:\flutterfiles\lib\config.ini) do (
	if %%a==processname set processname=%%b
)
set /A a = 1
:loop
	if %a%==1 goto On
	if %a%==2 goto Off
:On
	tasklist | find "%processname%"
	if errorlevel 1 goto On
	::Сюда писать то что нужно сделать если есть
	set /A a = 2
	goto Done
:Off
	tasklist | find "%processname%"
	if errorlevel 1 goto Offin
	::Сюда писать то что нужно сделать если есть
	goto Off
:Offin

	set /A a = 1
:Done
goto loop
::diskpart /s lis dis
:exit