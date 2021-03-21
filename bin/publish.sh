#!/bin/sh

# This script is called by .github/workflows/publish.yml after compiling the source documents into
# HTML files in the `docs` directory.
#
# It adds and pushes the compiled files to a 'publishing' repo, where they are served as a website via
# github pages.

set -euo pipefail

git config user.name 'github-actions'
git config user.email 'github-actions@users.noreply.github.com'

echo "Copy latest build docs to publish branch"
mv docs docs-temp
git checkout gh-pages
rm -r docs
mv docs-temp docs

echo "Copying cname across too"
cp -a CNAME docs

echo "Push the changes"
git add .
git commit -am "Published at $(date)"
git push

echo "Publishing complete"
