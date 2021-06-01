#!/bin/bash

msg="rebuilding site `date`"
if [ $# -eq 1 ] 
  then msg="$1"
fi

git add -A
git commit -m "$msg"

git pull --rebase origin master
git push origin master
