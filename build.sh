#!/bin/bash

cp --recursive build-resources/* .
cp --recursive build-resources/.mvn .

if [ $# -eq 0 ]; then
    ./mvnw package
else
    ./mvnw package -P$1
fi

