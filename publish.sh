#!/bin/bash

echo -e ">>> start upload markdown to github..."

hugo -D

cd public
git add .

msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

git pull --rebase origin master

echo -e ">>> push markdown to github..."

git push origin master

echo -e ">>> succeed upload markdown to github."

cd ..

echo -e ">>> start upload markup to github-pages..."

git add .

msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

git pull --rebase origin master

echo -e ">>> push markup to github-pages..."

git push origin master

echo -e ">> succeed upload markup to github."

