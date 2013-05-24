@echo off
mkdir eiffel_library
cd eiffel_library
call git clone git://github.com/oligot/gobo.git
cd gobo
call git checkout epm
set GOBO=%cd%
call epm.bat
cd ..
call git clone git://github.com/oligot/gobo-ecf.git
call git clone git://github.com/oligot/json.git
cd json
call git checkout gec
cd ..\..
