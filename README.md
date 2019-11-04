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
```
git remote add upstream https://github.com/docbook/xslt10-stylesheets
git remote -v
```

**Repo procedure**

1.  In your local fork, update your fork from the main repo (upstream): `git fetch upstream`

2.  Make sure you are on your master branch: `git checkout master`

3.  Merge upstream into your local fork: `git rebase upstream/master`

4.  Push these changes to your github fork to put that fork in synch with the main repo:  `git push origin master`

5.  Create a branch: `git checkout -b bugfix_branch` 

6.  Make your changes on this branch, and compare your changes using `git diff`.

7.  Commit the changes:
```
git add filename
git commit -m "message"
```

8.  Push your commits:
    `git push -u origin bugfix_branch`

9.  On github, go to your fork or the main repo and create a new pull request, adding a comment and hitting submit.

10.  The github repo will run the check routine which takes about 10 minutes.  When complete, you can Merge to docbook.

11.  The repo will rebuild the stock snapshot, which after about ten minutes you can view at: https://cdn.docbook.org/release/xsl/snapshot

12.  To immediately resynch your fork and delete the branch:

```
git checkout master
git fetch upstream
git rebase upstream/master
git push
git branch -d bugfix_branch
```

**Creating snapshot zip files**

1.  Create a tag like this:
    `git tag -m "Snapshot release" snapshot/2019-10-01`

2.  Push the tag:
    `git push -u upstream snapshot/2019-10-01`

3.  This will trigger the build of the zip files, which will
    eventually appear in https://github.com/docbook/xslt10-stylesheets/releases

