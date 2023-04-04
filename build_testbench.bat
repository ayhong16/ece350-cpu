@ECHO OFF

SET PROG=%~1

cmd /c "update_deps.bat"
cmd /c "iverilog -o ./processor-main/processor.out -c deps.f -s Wrapper_tb  -P Wrapper_tb.FILE=\""%PROG%\"""