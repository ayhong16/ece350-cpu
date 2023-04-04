@ECHO OFF

cmd /c "update_deps.bat"
cmd /c "iverilog -o ./processor-main/processor.out -c deps.f -s Wrapper_tb"