#!/bin/bash

msg="rebuilding site `date`"
if [ $# -eq 1 ] 
  then msg="$1"
fi

cd public
git pull origin matser
cd ..

git add -A
git commit -m "$msg"

git pull --rebase origin master
git push origin master
