#!/bin/sh

# This script is called by .github/workflows/publish.yml after compiling the source documents into
# HTML files in the `docs` directory.
#
# It adds and pushes the compiled files to a 'publishing' repo, where they are served as a website via
# github pages.

set -euo pipefail

git config --global user.name 'HMPPS Tech Team Bot'
git config --global user.email 'hmpps-tech-team-bot@users.noreply.github.com'

echo "Copy latest build docs to publish branch"
mv docs docs-temp
git checkout gh-pages
rm -r docs
mv docs-temp docs

echo "Push the changes"
git add .
git commit -am "Published at $(date)"
git push

echo "Publishing complete"
