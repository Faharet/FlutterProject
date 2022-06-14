@rem My First bat
@echo off
::Берем переменные с конфига
for /f "tokens=1,2 delims==" %%a in (E:\flutterfiles\lib\config.ini) do (
	if %%a==processname set processname=%%b
)
:loop 
	echo %processname%
	tasklist | find "%processname%"
	if errorlevel 1 goto NoRecord
	::Сюда писать то что нужно сделать если есть
	echo Found
	goto Done
:NoRecord
	::Сюда писать то что нужно сделать если нету
	echo Not found
:Done
goto loop
::diskpart /s lis dis
exit:

