#!/bin/bash

if [ -z $1 ]
then
    mkdir -p src/ include/
    cd externals;tar xvzf boost_1_65_0.tar.gz
    cd ..
    make check
    make clean
elif [ $1 = 'clean' ]
then
    mkdir -p src/ include/
    rm -rf .git* test/SampleTest.cpp
    make clean
else
    echo 'ERROR:invalid args. Usage: ./setup [None or clean]'
fi
