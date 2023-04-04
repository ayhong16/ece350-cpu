@ECHO OFF

SET PROG=%~1

cd "processor-main\Test Files\Assembly Files"
cmd /c "asm.exe ./%PROG%.s"
move ".\%PROG%.mem" "..\Memory Files"
cd "..\..\.."
cmd /c "build_testbench.bat %PROG%"
cd "processor-main"
cmd /c "vvp processor.out"
cd "../"