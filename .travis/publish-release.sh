#!/bin/bash
set -e # Exit with nonzero exit code if anything fails
here=$(dirname "${BASH_SOURCE[0]}")
# Only commits to master should trigger deployment
# (add 'travis' for testing purposes.)
if [ "$TRAVIS_PULL_REQUEST" != "false" ] || \
   [ "$TRAVIS_BRANCH" != master -a "$TRAVIS_BRANCH" != travis ]; then
    echo "Skipping deployment"
    exit 0
fi

# Remember the SHA of the current build.
SHA=$(git rev-parse --verify HEAD)

# Turning off temporarily

# # Clone the minimum of the CDN repo needed.
# CDN_REPO="https://$GH_TOKEN@github.com/docbook/cdn.git"
# git clone $CDN_REPO cdn --depth=1 -q
# # Clean out existing content...
# rm -rf cdn/release/xsl/$VERSION
# rm -rf cdn/release/xsl-nons/$VERSION
# # ...and copy the new one.
# mkdir -p cdn/release/xsl
# mkdir -p cdn/release/xsl-nons
# rm -f cdn/release/xsl/index.html
# rm -f cdn/release/xsl-nons/index.html
# cp -a dist/docbook-xsl-$VERSION cdn/release/xsl/$VERSION
# cp -a dist/docbook-xsl-nons-$VERSION cdn/release/xsl-nons/$VERSION
# # We could normally make "current" symbolic links to "snapshot"
# # but github's policy doesn't allow to publish symbolic links in pages.
# rm -rf cdn/release/xsl/current
# rm -rf cdn/release/xsl-nons/current
# cp -a cdn/release/xsl/$VERSION cdn/release/xsl/current
# cp -a cdn/release/xsl-nons/$VERSION cdn/release/xsl-nons/current
# 
# # If there are no changes, bail out.
# # (Note that this doesn't detect additions.)
# #if (cd cdn && git diff --quiet); then
# #    echo "No changes to the output on this push; exiting."
# #    exit 0
# #fi
# 
# $here/generate_index.py cdn/release/xsl
# $here/generate_index.py cdn/release/xsl-nons
# 
# # Now prepare to commit and push to the CDN
# cd cdn
# git config user.name "Travis CI"
# git config user.email "travis-ci"
# 
# git add .
# git commit -m "Deploy XSL Stylesheets to GitHub Pages: ${SHA}"
# git push -q origin HEAD
 
echo "Ran publish-release.sh but it did nothing."
