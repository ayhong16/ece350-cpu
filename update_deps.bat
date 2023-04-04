@ECHO OFF
IF EXIST .\deps.f DEL /F deps.f


@REM for /r %%i in (*) do ( echo %%~nxi )

for /R %%F in ("*.v?") do (
    echo %%~nxF | find "_tb.v" > nul
    if errorlevel 1 (
        echo %%F | find "vivado" > nul
        if errorlevel 1 (
            call :Sub %%~F
        )
    )
)
ECHO .\processor-main\Wrapper_tb.v >> deps.f

goto :eof

:Sub
set str=%*
set str=%str:C:\Users\ayhon\ECE350\ece350-cpu\=.\%
echo.%str% >> deps.f