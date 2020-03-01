#!/bin/bash

echo -e "[i] start upload changes to github..."

echo -e "[+] start build static page with hugo theme..."

hugo -t hugo-notepadium

hugo -t hugo-notepadium

echo -e "[o] succeed build static page with hugo..."

cd public
git add .

msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

git pull --rebase origin master

echo -e "[+] start upload changes; settings and document..."

git push origin master

echo -e "[o] succeed upload settings and documnent changes"

cd ..

git add .

msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

git pull --rebase origin master

echo -e "[+] start upload changes; static pages"

git push origin master

echo -e "[o] succeed upload static pages; end."
