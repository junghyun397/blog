#!/bin/bash

echo "$1"

if [[ ! "$1" == "-b" ]] || [[ ! "$1" == "--blog" ]]
then
    echo "b"
fi
