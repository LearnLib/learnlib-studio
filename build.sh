#!/bin/bash

cp -R build-resources/* .

if [ $# -eq 0 ]; then
    ./mvnw package
else
    ./mvnw package -P$1
fi

