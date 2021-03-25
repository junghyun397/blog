#!/bin/bash

echo -e ">> Publish updates to Github..."

hugo -D

cd public

git add .
msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

git pull --rebase origin master
git push origin master

cd ..

git add .
msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

git pull --rebase origin master
git push origin master
