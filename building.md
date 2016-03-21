DocBook XSL Release Build Process
=================================

The build process for a snapshot or actual release is created by running the docbook-build shell script like follows:
```
/opt/buildtree/docbook/releasetools/docbook-build \
  -a ns \
  -b /opt/buildtree/docbook \
  -l /opt/scratch-release \
  -t /opt/scratch-release \
  -p /var/opt/release \
  -v 1.79.1 \
  -x zip-ns \
  -z US/Pacific \
  xsl \
  || rm -f /opt/scratch/docbook-xsl-snapshot.lock
```

Where

* `-a ns` Specifies that the 'ns' suffix is to be added to the build name of the namespace version. Saved in the `$ADDEDSUFFIX` variable.
* `-b /opt/buildtree/docbook` Specifies the source for the build, the repo directory. Saved in the `$BASEDIR` variable.
* `-l /opt/scratch-release` Location of the generated log file. Saved in the `$LOGDIR` variable.
* `-t /opt/scratch-release` Location of any generated temp files. This is where the "built" version resides before being zipped up. Saved in the `$TMPDIR` variable.
* `-p /var/opt/release` Location of the final zip files. Saved in the `$SITEBASE` variable.
* `-v 1.79.1` The numerical version of this release. Saved in the `$RELEASEVERSION` variable.
* `-x zip-ns` Name of the Makefile target for generating the zip files. Saved in the `$ZIPARG` variable.
* `-z US/Pacific` Specifies the time zone for date stamps. Saved in the `$ZONE` variable.
* `xsl` The name of the distro to build. Saved in the `$DISTROS` variable.

docbook-build script steps
--------------------------

The `docbook-build` shell script performs the following steps:

1. cd to the build directory `/opt/buildtree/docbook`.
2. Execute `svn cleanup`.
3. Execute `svn update` to make sure the latest files are in place.
4. Execute `svn info` and extract from the results the SVN version number to be placed in the `REVISION` variable, and copies it the the `REVISION` file.
5. Create a lock file to prevent two build processes from running at the same time.
6. Filter the `VERSION` file to insert the current build version taken from the `-v` option of the `docbook-build` script.
7. Checks to see if a lock file is in place from a previous build. If so, it loops with sleep 1 until a) the
LOCK_TIMEOUT count is reached and exits if so, or b) the lock has cleared and it prints "Done", creates a new
lock file, and continues.
8. Remove the previous log file that captures `STDERR` and `STDOUT`.
9. Removes the existing `VERSION` file in the source, and then does `svn update VERSION` to get the latest.
10. Runs a sed command on the `VERSION` file to replace the old <Version> content with the value of `$REVISION` created earlier.
11. Starts the logging of output to the log file.
12. Prints a date timestamp.
13. Build the XSL files using this command. This Makefile must also build the -ns version as well, because no other commands in the script do so.

    ```
    make distrib -C xsl XSLT="$repo_dir/buildtools/xslt -$ENGINE" \
      PDF_MAKER=$PDF_MAKER
    ```
14. echo some descriptive text to a file named header.txt.
15. Make a tar.bz2 file using this command:

    ```
    make zip-ns -C xsl ZIPVER=$RELEASEVERSION TMP=$TMP \
      XSLT="$repo_dir/buildtools/xslt -$ENGINE" PDF_MAKER=$PDF_MAKER
    ```
    where `$RELEASEVERSION` is the value from the -v command line option.
16. Generate a list of changes to a LatestChanges file using this command:

    ```
    svn cleanup && svn update && svn log --verbose --limit 200 > LatestChanges
    ```
17. Copy the contents of `header.txt` and `LatestChanges` to a `README.txt` file.
18. Copy the tar.bz2 files to `$SITEBASE` and cd to that directory.
19. Remove the old existing xsl and xsl-ns directories and any log file.
20. For each tar.bz2 file, bunzip it and tar extract into the $TMP directory, creating the `docbook-xsl-1.79.1`
directory there.
21. Run `mkdir xsl` and `mkdir xsl-ns` to initialize these directories.
22. Copy contents of the directories:

    ```
    cp -pR docbook-xsl-1.79.1/* xsl
    cp -pR docbook-xsl-ns-1.79.1/* xsl-ns
    ```
23. Copy the zip files, `README.txt`, and `LatestChanges` to `$SITEBASE` (`/var/opt/release`)

Uploading a distro
------------------

This section describes setting up a distribution on SourceForge. It requires a SourceForge shell account.

1. Log onto the SourceForge DocBook project and create the new release directories. Go to Files > docbook-xsl and select Add Folder, and name it 1.79.1 for the new release. Do the same for docbook-xsl-ns and docbook-xsl-doc. This creates the new directories for the new release in the location `/home/frs/project/docbook/docbook-xsl/1.79.1` for example.
2. On the build machine, cd to `$SITEBASE` (`/var/opt/release`) where the .zip and tar.bz2 files are located.
3. Use scp to copy the .zip and .tar.bz2 files to the SourceForge account, using a command like this:
`scp docbook-xsl-1.79.1.zip bobstayton,docbook@web.sourceforge.net`:
The files will land in `/home/project-web/docbook`.
4. Log into the shell account on the SourceForge machine with a command like this:
`ssh -t bobstayton,docbook@shell.sourceforge.net create`
5. `cd /home/project-web/docbook/htdocs/release/xsl`
6. rm current (this is a symlink, not an actual directory).
7. Unzip the stylesheet files and doc, creating the docbook-xsl-1.79.1 directory:

   ```
   unzip ../../../docbook-xsl-1.79.1.zip
   unzip ../../../docbook-xsl-doc-1.79.1.zip
   ```
8. Run these commands to set up the numbered and current directories:

   ```
   mv docbook-xsl-1.79.1 1.79.1
   chmod -R g+w 1.79.1
   ln -s 1.79.1 current
   ```
9. Repeat steps 5 to 8 replacing xsl with xsl-ns for the namespaced version of the stylesheets.
10. To make the zip files available for download, use commands like this to copy the zip and tar.bz2 files to the directories created in step 1 of this section:
  ```cp /home/project-web/docbook/docbook-xsl-1.79.1.zip /home/frs/project/docbook/docbook-xsl-1.79.1```
Repeat for docbook-xsl-ns and docbook-xsl-doc
11. Edit the `RELEASE-NOTES.txt` file into a short `README` file and post that there using SourceForge upload.
That will cause the `README` to be displayed below the list of files.