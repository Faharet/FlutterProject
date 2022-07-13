for /f "tokens=1,2 delims==" %%a in (config.ini) do (
    if %%a==mytime set mytime=%%b
    if %%a==scriptone set scriptone=%%b
    if %%a==scripttwo set scripttwo=%%b
)
schtasks /create /sc weekly /d SAT /tn hardtime /sd %date% /st %mytime% /tr %scriptone%