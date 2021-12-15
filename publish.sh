#!/bin/bash

msg="rebuilding site `date`"
if [ $# -eq 2 ] 
  then msg="$2"
fi

hugo

if [[ ! "$1" == "-b" ]] || [[ ! "$1" == "--blog" ]] 
then
    cd public

    git add -A
    git commit -m "$msg"

    git pull --rebase origin master
    git push origin master

    cd ..
fi

if [[ ! "$1" == "-p" ]] || [[ ! "$1" == "--post" ]] 
then
    git add -A
    git commit -m "$msg"

    git pull --rebase origin master
    git push origin master
fi
