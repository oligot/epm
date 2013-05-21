#!/bin/sh
mkdir eiffel_library
cd eiffel_library
git clone https://github.com/oligot/gobo.git
cd gobo
git checkout epm
GOBO=`pwd` ./epm.sh
cd ..
git clone https://github.com/oligot/gobo-ecf.git
git clone https://github.com/oligot/json.git
cd json
git checkout gec
cd ../..
