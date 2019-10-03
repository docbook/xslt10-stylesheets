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
DIST=dist

# Clone the minimum of the CDN repo needed.
CDN_REPO="https://$GH_TOKEN@github.com/docbook/cdn.git"

git clone $CDN_REPO cdn --depth=1 -q

# Clean out existing content...
rm -rf cdn/release/xsl/$VERSION
rm -rf cdn/release/xsl-nons/$VERSION
rm -f cdn/release/xsl/index.html
rm -f cdn/release/xsl-nons/index.html

# ...and copy the new one.
mkdir -p cdn/release/xsl
mkdir -p cdn/release/xsl-nons
cp -a $DIST/docbook-xsl-$VERSION cdn/release/xsl/$VERSION
cp -a $DIST/docbook-xsl-nons-$VERSION cdn/release/xsl-nons/$VERSION

# I'm sure there's a more efficient way to do this, but...
for dir in "cdn/release/xsl/$VERSION" "cdn/release/xsl-nons/$VERSION"; do
    for file in ".urilist" ".CatalogManager.properties.example"; do
        find $dir -name $file -exec rm {} \;
    done
done

# We could normally make "current" symbolic links to "snapshot"
# but github's policy doesn't allow to publish symbolic links in pages.
if [ "$VERSION" != "snapshot" ]; then
    rm -rf cdn/release/xsl/current
    rm -rf cdn/release/xsl-nons/current
    cp -a cdn/release/xsl/$VERSION cdn/release/xsl/current
    cp -a cdn/release/xsl-nons/$VERSION cdn/release/xsl-nons/current
fi

# copy documentation
rm -rf docbook-xsl-$VERSION
unzip -q $DIST/docbook-xsl-doc-$VERSION.zip
cp -a docbook-xsl-$VERSION/doc cdn/release/xsl/$VERSION/

# If there are no changes, bail out.
cd cdn
if [ `git status --porcelain | wc -l` = 0 ]; then
    echo "No changes to the output on this push; exiting."
    exit 0
else
    cd ..
fi

$here/generate_index.py cdn/release/xsl
$here/generate_index.py cdn/release/xsl-nons

# Now prepare to commit and push to the CDN
cd cdn
git status

git config user.name "Travis CI"
git config user.email "travis-ci"

git add .
git commit -m "Deploy XSL Stylesheets to GitHub Pages: ${SHA}"
git push -q origin HEAD

