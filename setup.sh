#!/bin/bash

if [ -z $1 ]
then
    mkdir -p src/ include/
    make check
    make clean
elif [ $1 = 'clean' ]
then
    mkdir -p src/ include/
    rm -rf .git* test/*
    make clean
else
    echo 'ERROR:invalid args. Usage: ./setup [None or clean]'
fi
