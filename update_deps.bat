@ECHO OFF
IF EXIST .\deps.f DEL /F deps.f
for /f %%i in ('FORFILES /S /M *.v /C "cmd /c echo @RELPATH"') do (
    echo %%i | find "_tb.v" > nul
    if errorlevel 1 (
        echo %%~i >> deps.f
    ) else (
        echo skipping testbench %%~i
    )
)