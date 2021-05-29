#!/bin/bash

msg="rebuilding site `date`"
if [ $# -eq 1 ] 
  then msg="$1"
fi

hugo -D

cd public

git add .
git commit -m "$msg"

git pull --rebase origin master
git push origin master

cd ..

git add .
git commit -m "$msg"

git pull --rebase origin master
git push origin master
