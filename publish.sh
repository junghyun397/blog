#!/bin/bash

echo -e "-------------------------------------------------"
echo -e "[i] start upload changes to github..."
echo -e "-------------------------------------------------"

hugo -t hugo-notepadium

cd public
git add .

msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

git pull --rebase origin master

echo -e "-------------------------------------------------"
echo -e "[+] start upload changes; settings and document..."
echo -e "-------------------------------------------------"

git push origin master

echo -e "-------------------------------------------------"
echo -e "[o] succeed upload settings and documnent changes"
echo -e "-------------------------------------------------"

cd ..

git add .

msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

git pull --rebase origin master

echo -e "-------------------------------------------------"
echo -e "[+] start upload changes; static pages"
echo -e "-------------------------------------------------"

git push origin master

echo -e "-------------------------------------------------"
echo -e "[o] succeed upload static pages; end."
echo -e "-------------------------------------------------"

