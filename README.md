## DocBook XSLT 1.0 Stylesheets

[![Build Status](https://travis-ci.org/docbook/xslt10-stylesheets.svg)](https://travis-ci.org/docbook/xslt10-stylesheets)

This repository contains the DocBook XSLT 1.0 Stylesheets, now
migrated away from SourceForge.

There are still some rough edges here as the build system and various
other things are being ported.

Nevertheless, this is now the intended repository of record.

The latest stable release is available at
https://github.com/docbook/xslt10-stylesheets/releases/download/release/1.79.2/docbook-xsl-1.79.2.zip

For build instructions please refer to the [DocBook XSL Release Build Process](building.md).

# Working in this repo

Here is the procedure for making changes to this repo.

**Initial setup**

1. Create your own fork.  Go to https://github.com/docbook/xslt10-stylesheets
and click on the Fork button to create your own fork.

2. Clone your fork to your local filesystem.

3. In your clone of the repo, set up the remote:

`git remote add upstream https://github.com/docbook/xslt10-stylesheets`
`git remote -v`

**Repo procedure**

1.  In your repo, update your fork from upstream: `git fetch upstream`

2.  Create a branch: `git checkout -b bugfix_branch` 

3.  Make your changes on this branch, and compare your changes using `git diff`.

4.  Commit the changes:
    `git add filename`
    `git commit -m "message"`

5.  Push your commits:
    `git push origin bugfix_branch`

6.  On github, go to your fork and create a new pull request,
    adding a comment and hitting submit.

7.  The github repo will run the check routine. When complete, you can Merge to
    docbook.

8.  The repo will rebuild the stock snapshot which after about ten
    minutes you can view at: https://cdn.docbook.org/release/xsl/snapshot


**Creating snapshot zip files**

1.  Create a tag like this:
    `git tag -m "Snapshot release" snapshot/2019-10-01`

2.  Push the tag:
    `git push -u upstream snapshot/2019-10-01`

3.  This will trigger the build of the zip files, which will
    appear in https://github.com/docbook/xslt10-stylesheets/releases

