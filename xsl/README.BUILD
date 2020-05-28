~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
The DocBook XSL Stylesheets release build has been tested under
the bash shell on Linux, Darwin/OSX with MacPorts, and Cygwin. You
should be able to build successfully on those platforms -- if you
run the build under bash and have the necessary build dependencies
installed (see Part 0.0 below) and have your user environment set
up correctly (with environment variables set, and for doc/release
builds, with properly configured ~/.xmlc and ~/.antrc files -- see
sections 0.3, 0.4, and 0.5 below).
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Parts 0 and 1 of this document provide how-to instructions for
building the DocBook XSL Stylesheets.

Corrections and improvements from anyone to Parts 0 and 1 are
very welcome (preferably submitted in the form of patches against
this file, if you are not a DocBook Project member and can't submit
them directly). Note that the DocBook Wiki contains a page where
you can contribute notes and/or post comments about the build.

  http://wiki.docbook.org/DocBookXslBuild

Part 2 and the Parts following it provide how-instructions for
performing tasks related to DocBook XSL Stylesheets releases.
Those parts are basically relevant only to DocBook Project
members who conduct official DocBook Project releases.

DocBook Project developers are encouraged to edit/change/improve
any of the Parts in this file, and to add anything to them.

-----------------------------------------------------------------
Part 0: Build Setup
-----------------------------------------------------------------
Before building, make sure your environment is set up correctly
with information about some of the dependencies needed to build.

FIXME: The 0.0 section is probably not complete and should provide
more details about other the third-party build dependencies. Doc
contributions welcome...

0. Third-party build dependencies.
   The following is an incomplete list of some of the third-party
   tools and libraries you need to have installed before building.

   - xsltproc and xmllint
   - egrep and sed
   - Perl and the XML::XPath module
   - Java and Apache ant (for building the extension jar files)

   And if you want to build with Saxon instead of xsltproc:

   - Java
   - Saxon 6 jar file
   - Xerces-J jar files
   - Apache XML Commons Resolver jar file

   You probably should also have the Xalan 2 jar file installed.

   In addition to the above, the doc/distrib/release build requires:

   - tar, gzip, bzip2, and zip
   - openssh
   - lftp (for uploads to the Sourceforge FTP site)
   - w3m browser (default) or optionally lynx or elinks
     (for generating the plain-text release notes)
   - dblatex, xep, or fop (for building doc PDFs)

1. Core DocBook Project modules (stylesheets build)
   If you want to build and test the stylesheets (or
   changes/customizations you have made to the stylesheets),
   then: In addition to having an up-to-date working copy of
   the source for the "xsl" module, you also need to have
   up-to-date working copies of the following modules:

     buildtools
       tools needed for all builds
     gentext
       localization source files

   Optionally, to have a set of variety of simple DocBook XML
   document instances on hand to test your changes against, make
   sure to have an up-to-date working copy of the following:

     testdocs
       a variety of DocBook XML document instances

2. Modules needed for releases.
   If you are a DocBook Project developer and, in addition to
   building just the stylesheets, want to be able to also build a
   release package of the stylesheets (including the documentation
   and all other files in the package), then you also need to have
   up-to-date working copies of the following modules:

     releasetools
       tools needed for release builds
     xsl-saxon
       DocBook Saxon extensions (bundled with docbook-xsl releases)
     xsl-xalan
       DocBook Xalan extensions (bundled with docbook-xsl releases)

3. Shell Environment.
   A good way to get your environment variables set up is to
   create a file (name "docbk.sh" or whatever), with the
   following in it:

     # directory that is base directory for all your DocBook modules
     export repo_dir=/opt/sandbox/docbook/trunk
     # directory containing all your jar files
     export JARDIR=/usr/share/java
     export CLASSPATH=$CLASSPATH:$JARDIR/xml-commons-resolver-1.1.jar
     export CLASSPATH=$CLASSPATH:$JARDIR/xercesImpl.jar
     export CLASSPATH=$CLASSPATH:$JARDIR/jaxp-1.3.jar
     export CLASSPATH=$CLASSPATH:$JARDIR/xalan-2.7.0.jar
     export CLASSPATH=$CLASSPATH:$JARDIR/saxon-6.5.5.jar
     # directory containing CatalogManager.properties file
     export CLASSPATH=$CLASSPATH:/etc/xml/resolver/
     export SGML_CATALOG_FILES=/etc/sgml/catalog

   For Darwin/OSX with MacPorts, you should use these values instead:

     export JARDIR=/opt/local/share/java
     export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK/Home

   And for Cygwin, something like:

     export JAVA_HOME="c:/Java/jdk1.6.0_05" (or wherever Java is)
     export JARDIR="c:/cygwin/usr/share/java"

   You can then source that ~/docbk.sh by putting the following in
   your ~/.bashrc file:

     # set up some environment variables for DocBook/XML stuff
     . ~/docbk.sh

4. ~/.xmlc

   You need an .xmlc file with some system-specific data for Java
   and XML tools in your environment. For example:

   <?xml version='1.0' encoding='utf-8'?> <!-- -*- nxml -*- -->
   <config>
     <java classpath-separator=":" xml:id="java">
       <system-property name="javax.xml.parsers.DocumentBuilderFactory"
         value="org.apache.xerces.jaxp.DocumentBuilderFactoryImpl"/>
       <system-property name="javax.xml.parsers.SAXParserFactory"
         value="org.apache.xerces.jaxp.SAXParserFactoryImpl"/>
       <classpath path="/usr/share/java/xercesImpl.jar"/>
       <classpath path="/usr/share/java/jaxp-1.3.jar"/>
       <classpath path="/usr/share/java/xml-commons-resolver-1.1.jar"/>
     </java>
     <java xml:id="bigmem">
       <java-option name="Xmx512m"/>
     </java>
     <saxon xml:id="saxon" extends="java">
       <arg name="x" value="org.apache.xml.resolver.tools.ResolvingXMLReader"/>
       <arg name="y" value="org.apache.xml.resolver.tools.ResolvingXMLReader"/>
       <arg name="r" value="org.apache.xml.resolver.tools.CatalogResolver"/>
       <param name="use.extensions" value="1"/>
     </saxon>
     <saxon xml:id="saxon-8a" extends="saxon" class="net.sf.saxon.Transform"
       java="/usr/bin/java">
       <classpath path="/usr/share/java/saxon8.jar"/>
     </saxon>
     <saxon xml:id="saxon-6" extends="saxon" class="com.icl.saxon.StyleSheet">
       <classpath path="/usr/share/java/saxon-6.5.5.jar"/>
       <classpath path="/opt/sandbox/docbook/trunk/xsl-saxon/saxon65.jar"/>
     </saxon>
     <xsltproc xml:id="xsltproc" exec="xsltproc"></xsltproc>
     <xmllint xml:id="xmllint" exec="xmllint"></xmllint>
   </config>

   For Darwin/OSX with MacPorts, use /opt/local/share/java/ in
   place of /usr/share/java//opt/local/share/ja in place of
   /usr/share/java/

5. ~/.antrc

   To build the Saxon and Xalan XSLT extensions, you need an
   ~/.antrc file with system-specific data for your environment.

   Example for Debian with Sun JDK:

     ANT_OPTS="$ANT_OPTS \
      -Dfile.reference.saxon.jar=/usr/share/java/saxon-6.5.5.jar \
      -Dfile.reference.xalan.jar=/usr/share/java/xalan2.jar \
      -Dplatform.home=/usr/lib/jvm/java-6-sun"

   Example for Darwin/OSX with MacPorts:

     ANT_OPTS="$ANT_OPTS \
      -Dfile.reference.saxon.jar=/opt/local/share/java/saxon-6.5.5.jar \
      -Dfile.reference.xalan.jar=/opt/local/share/java/xalan.jar \
      -Dplatform.home=/System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK/Home"

   Example for Cygwin:

     ANT_OPTS="$ANT_OPTS \
      -Dfile.reference.saxon.jar=c:/cygwin/usr/share/java/saxon-6.5.5.jar \
      -Dfile.reference.xalan.jar=c:/cygwin/usr/share/java/xalan2.jar \
      -Dplatform.home=’c:/Java/jdk1.6.0_05’"

-----------------------------------------------------------------
Part 1: Build and test the stylesheets
-----------------------------------------------------------------
This section explains how to do a developer/contributor build of
the stylesheets.

If you are not a member of the DocBook Project and/or are not
building a docbook-xsl release package -- if, for example, you
just want to be able to build and test your own changes or
customizations to the stylesheets -- then this "Part 1" section
describes the only build you need to do (you can ignore Part 2
and all other Parts following it).

1. make all
   Run "make all" to build just the stylesheets (without the docs
   or other "extras" contained in release packages). Essentially,
   all that "make all" does it to build the gentext and param
   files and gives you a working set of stylesheets to use.

   One recommended way to invoke "make all" is the following:

     rm -f DOCBOOK-BUILD.LOG && \
     . ~/docbk.sh && \
     $repo_dir/buildtools/build-clean && \
     make all 2>&1 \
       XSLTENGINE=xsltproc \
       | tee DOCBOOK-BUILD.LOG && \
     $repo_dir/buildtools/build-check DOCBOOK-BUILD.LOG

   The preceding will cause the following:

     - runs the build using xsltproc, which is generally faster at
       building the stylesheets that Saxon is; to build with saxon
       instead of xsltproc, change the "xsltproc" above to "saxon".
     - safely cleans your workspace before the build is actually
       run (see below for details)
     - writes any error and warning messages to the
       DOCBOOK-BUILD.LOG log file
     - checks the DOCBOOK-BUILD.LOG file for errors & reports them

3. make check (optional step)
   As an optional step to check for any major brokenness, run
   "make check", which will run a test transformation against
   the driver stylesheets for each output format (e.g.,
   html/docbook.xsl, fo/docbook.xsl, etc.).

   Because of problems with the 1.74.* releases, it is now
   recommended that "make check" be run multiple times with
   different XSLT processors.

   One recommended way to invoke "make check" is the following:

     rm -f DOCBOOK-BUILD.LOG && \
     . ~/docbk.sh && \
     make check 2>&1 \
       XSLTENGINE=xsltproc \
       | tee DOCBOOK-BUILD.LOG && \
     $repo_dir/buildtools/build-check DOCBOOK-BUILD.LOG

   After running with "xsltproc", you should run it again with
   "saxon":
     rm -f DOCBOOK-BUILD.LOG && \
     . ~/docbk.sh && \
     make check 2>&1 \
       XSLTENGINE=saxon \
       | tee DOCBOOK-BUILD.LOG && \
     $repo_dir/buildtools/build-check DOCBOOK-BUILD.LOG

4. Fix any obvious problems.
   If build-check and/or "make check" report any problems, fix
   them. Then repeat Step 1 until you don't see any more problems.

5. Further testing.
   Once you have any obvious problems fixed (that is, the kind
   that build-check and "make check" can catch, you should
   do further testing of the changes (if any) that you have made
   m to the stylesheet code. Try to test with a variety of test
   files, not just with DocBook XML source files you've created
   yourself. Consider using the files in the "testdocs" module
   (see step 1 of the "Build Setup" section above).

   In addition to just running a transformation step ensuring it
   executes successfully, visually examine the output and make
   sure that it is what you would expect. In particular, make sure
   that any changes you have made have not broken the formatting
   anywhere, and that your changes have not had other unintended
   side effects.

6. Commit fixes or send patches.
   If you have built and smoke-tested the stylesheets successfully
   with and at done further testing and visual examination of
   output to ensure you haven't broken anything, then it's time to
   contribute your changes.

   If you are a DocBook Project developer, commit your changes to
   the DocBook Project source repository. If you are not a DocBook
   Project developer, then create a patch and either send that to
   the project by posting it using the DocBook Project tracker at
   Sourceforge, or by posting it to the docbook-apps mailing list.

==================================================================

-----------------------------------------------------------------
Part 2: Build a distribution (including reference documentation)
-----------------------------------------------------------------
This section explains how to build a full distribution of the
stylesheets, which includes the reference documentation and
accompanying files.

If you are not a member of the DocBook Project and/or have no
interest in building the reference documentation or in building a
docbook-xsl release package -- if, for example, you just want to
be able to build and test your own changes or customizations to
the stylesheets -- then you can ignore this "Part 2" section; the
"Part 1" build is all you need to do.

  Note: What's a "distribution"?
  -----------------------------------------------------------
  In the case of the DocBook XSL Stylesheets, creating a
  "distribution" of the stylesheets means that in addition
  to the stylesheet files themselves, the following occurs:

    - build of the reference docs
    - build of the release-notes files
    - preparation of any additional items bundled along with
      the stylesheets (currently, that means the DocBook
      Saxon Extensions and the DocBook Xalan extensions)
  -----------------------------------------------------------

0. Ensure repository is fully updated.
   If you're hoping to make a release of the current trunk of the
   stylesheets, make sure to "svn up" from the parent of this 
   directory (trunk/, not xsl/).

1. make distrib
   If you have followed the steps in Part 1 above to successfully
   run a "make all" build, then to build a full distribution,
   "make distrib" (to smoke-test the build and to build the docs
   and additional stuff needed for the distribution).

   One recommended way to run "make distrib" is the following:

     rm -f DOCBOOK-BUILD.LOG && \
     . ~/docbk.sh && \
     $repo_dir/buildtools/build-clean && \
     make all 2>&1 \
       XSLTENGINE=xsltproc \
       | tee DOCBOOK-BUILD.LOG && \
     $repo_dir/buildtools/build-check DOCBOOK-BUILD.LOG && \
     $repo_dir/releasetools/catalog-install && \
     make distrib 2>&1 \
       XSLTENGINE=xsltproc \
       PDF_MAKER=dblatex \
       | tee DOCBOOK-BUILD.LOG && \
     $repo_dir/releasetools/catalog-install uninstall && \
     $repo_dir/buildtools/build-check DOCBOOK-BUILD.LOG

   The above first runs a "make all" build, and if that succeeds
   without any errors, then runs a "make distrib" build.

   NOTE: The engine specified in PDF_MAKER is only used to build a
   PDF of the release notes. If you want to use xep instead of
   dblatex, specify PDF_MAKER=xep. (There's no option to use fop
   because fop still doesn't do an adequate job of formatting the
   release notes.)

   NOTE: The catalog-install script "installs" some XML Catalog
   settings in your environment so xsltproc/saxon will resolve the
   https://cdn.docbook.org/release/xsl/current/ canonical
   URL to the working directory you're actually building in
   (instead of to whatever it would normally resolve to).

   The reason for that "install" step is that there is one part of
   the doc/distrib build that relies on the litprog stylesheets,
   and the litprog stylesheets use the http: canonical URL for the
   stylesheets (instead of using a relative path, as the
   stylesheets themselves do), so the "install" step tells
   xsltproc and saxon that when they find that http: URL in the
   litprog stylesheets, they should resolve it to the path to the
   working directory you are building in (instead of to any
   installed docbook-xsl release stylesheets or whatever other
   sets of the stylesheets you may installed on your system).

   The "uninstall" step at the end causes all changes made by
   that temporary XML Catalog "install" step to be reverted.

2. Fix any problems, and commit fixes.
   If build-check reports any problems, fix them, commit your
   changes (if the fixes required changes to source files), then
   repeat Step 1 until you don't see any more problems.

-----------------------------------------------------------------
Part 3: Prepare a release
-----------------------------------------------------------------
This section explains how to prepare for an actual docbook-xsl
release. It's probably relevant only to DocBook Project
developers; so if you're not a member of the project, you can
safely ignore this part.

1. Edit the VERSION file.
   a. Update the release number in the fm:Version element.
   b. Uncomment the appropriate text in the fm:Release-Focus
      element to match the type of release this is; for example,
      "Major feature enhancements", "Minor bugfixes", etc.
   c. If necessary, edit the fm:Changes element to describe this
      release. Keep it at one sentence; e.g.; "This is a bug-fix
      release with a few feature enhancements." It's not a good
      idea to waste time doing much more than that, because the
      dumbass at Freshmeat who reviews all submissions will likely
      edit what you submit and manage to bork it up in some way.

2. Check in the VERSION file:

     svn commit -m "Version 1.NN.N released" VERSION

3. Re-make the NEWS.xml file:

     make NEWS.xml

4. Open the NEWS.xml file in your text/XML editor, select the
   sect1 section and all its child content, and paste that into
   the RELEASE-NOTES.xml file, as the second sect1 child of the
   RELEASE-NOTES.xml file's root article element (just after the
   <sect1 condition="snapshot" id="current"> section).

5. In the section you just pasted from the NEWS.xml file into the
   RELEASE-NOTES.xml file, add a variablelist with a varlistentry
   instance for each major significant change made in this release
   that merits special mention in the release notes; generally,
   that means every major enhancement.

6. In the section you just pasted from the NEWS.xml file into the
   RELEASE-NOTES.xml file, go through each sect2 section and
   manually remove any listitem instances that have content which
   doesn't need to be included in the final release notes. In
   general, that means removing most bug fixes and "housekeeping"
   changes that do not need to be exposed to users, but changes
   for feature enhancements or changes to public APIs. Do remember
   to modify the @xml:ids for each pasted sect2 or you'll get a
   conflict later.

7. After making all changes/additions to the RELEASE-NOTES.xml
   file, check it back in with 

     svn commit -m "Updated for 1.NN.N release" RELEASE-NOTES.xml

-----------------------------------------------------------------
Part 4: Build a release
-----------------------------------------------------------------
This section explains how to build an actual docbook-xsl release.
It's probably relevant only to DocBook Project developers; so if
you're not a project member, you can safely ignore this part.

1. To build the actual release packages, run a "make release"
   build from a clean workspace.

   One recommended way to run "make release" is the following:

     rm -f DOCBOOK-BUILD.LOG && \
     . ~/docbk.sh && \
     $repo_dir/buildtools/build-clean && \
     make all 2>&1 \
       XSLTENGINE=xsltproc \
       | tee DOCBOOK-BUILD.LOG && \
     $repo_dir/buildtools/build-check DOCBOOK-BUILD.LOG && \
     $repo_dir/releasetools/catalog-install && \
     make release 2>&1 \
       XSLTENGINE=xsltproc \
       PDF_MAKER=dblatex \
       | tee DOCBOOK-BUILD.LOG && \
     $repo_dir/releasetools/catalog-install uninstall && \
     $repo_dir/buildtools/build-check DOCBOOK-BUILD.LOG; \
     rm -f DOCBOOK-BUILD.LOG

   In addition to the normal error-checking that build-check
   does, running "make release" will also automatically run
   the "make check" step.

2. If there are no errors reported from build-check or "make
   release", run a "make zip-ns" build:

     make zip-ns

   The "zip-ns" target builds both the docbook-xsl zip/gz/bz2
   packages and the corresponding docbook-xsl-ns (namespaced
   DocBook stylesheets) packages.

3. Inspect your $TEMP directory to make sure that all the packages
   have been built. What you should see is something like this:

     drwxr-xr-x 22 mike mike 4.0K Jul 23 02:40 docbook-xsl-1.73.0
     -rw-r--r--  1 mike mike 2.0M Jul 23 02:39 docbook-xsl-1.73.0.tar.bz2
     -rw-r--r--  1 mike mike 2.9M Jul 23 02:39 docbook-xsl-1.73.0.tar.gz
     -rw-r--r--  1 mike mike 3.6M Jul 23 02:39 docbook-xsl-1.73.0.zip
     -rw-r--r--  1 mike mike 1.6M Jul 23 02:40 docbook-xsl-doc-1.73.0.tar.bz2
     -rw-r--r--  1 mike mike 1.7M Jul 23 02:40 docbook-xsl-doc-1.73.0.tar.gz
     -rw-r--r--  1 mike mike 2.6M Jul 23 02:40 docbook-xsl-doc-1.73.0.zip
     drwxrwxr-x 22 mike mike 4.0K Jul 23 02:40 docbook-xsl-ns-1.73.0
     -rw-r--r--  1 mike mike 2.0M Jul 23 02:40 docbook-xsl-ns-1.73.0.tar.bz2
     -rw-r--r--  1 mike mike 2.9M Jul 23 02:40 docbook-xsl-ns-1.73.0.tar.gz
     -rw-r--r--  1 mike mike 3.6M Jul 23 02:40 docbook-xsl-ns-1.73.0.zip

  That is, you should see:

    - docbook-xsl-1.NN.N.* packages
    - docbook-xsl-doc-1.NN.N.* packages
    - docbook-xsl-ns-1.NN.N.* packages

  Note that you will not see separate docbook-xsl-ns-doc packages
  (the docs are the same for both docbook-xsl and docbook-xsl-ns).

=================================================================
                    WARNING WARNING WARNING
                    WARNING WARNING WARNING
                    WARNING WARNING WARNING
   ---------------------------------------------------------
   All steps in Part 5 and from here forward are relevant
   only to DocBook Project developers and are "unreversible"
   steps that you should not run unless you're doing an
   actual release (instead of just testing).
   ---------------------------------------------------------
                    WARNING WARNING WARNING
                    WARNING WARNING WARNING
                    WARNING WARNING WARNING
=================================================================

-----------------------------------------------------------------
Part 5: Install a release
-----------------------------------------------------------------
This section explains how to install/upload an actual docbook-xsl
release.

0. Make sure that you have the following programs installed:

   - lftp
   - ssh
   - scp

-----------------------------------------------------------------
Manual upload of release packages
-----------------------------------------------------------------
Below are instructions for manually uploading and installing 
release packages in order to make them available at the project
site (http://docbook.sourceforge.net/release/).

1. Use scp or equivalent to transfer the following files 

   - docbook-xsl-<version>.zip
   - docbook-xsl-ns-<version>.zip
   - docbook-xsl-doc-<version>.zip 

   to the /home/project-web/docbook/htdocs/release/xsl 
   directory at web.sourceforge.net using scp, WinSCP, or another 
   equivalent tool. The login string is 

     <username>,docbook@web.sourceforge.net

     For example, using scp:

     scp docbook-xsl-1.77.1.zip bobstayton,docbook@web.sourceforge.net:htdocs/release/xsl


2. Start a SourceForge shell session, like so:

     ssh -t <username>,docbook@shell.sourceforge.net create

     After logging in, you should see the files you uploaded in this directory:

     /home/project-web/docbook/htdocs/release/xsl

3. Unzip the distribution.

   In the shell, execute commands as follows for the docbook-xsl 
   package (the 1.77.1 version is used as an example):

     cd /home/project-web/docbook/htdocs/release/xsl
     unzip docbook-xsl-1.77.1.zip
     # and unzip the documentation into the same directory
     unzip docbook-xsl-doc-1.77.1.zip
     mv docbook-xsl-1.77.1 1.77.1
     chmod -R g+w 1.77.1

4. If the release is not a .0 release, then make it the "current" release.

     # current is a symlink, so just use rm
     rm current
     ln -s 1.77.1 current

5. Repeat (and modify where applicable) the commands in step 3 for 
   the docbook-xsl-ns package.

6. The documentation packages contain reference.txt.gz and 
   reference.pdf.gz. Unzip these archives (to ensure working links 
   on the documentation index page).

7. Delete ZIP files and temporary directories.

For more information about file management and shell services at 
SourceForge, see

     https://sourceforge.net/apps/trac/sourceforge/wiki/WikiStart

*****************************************************************


-----------------------------------------------------------------
Part 6: Manage release files
-----------------------------------------------------------------


Unfortunately, Sourceforge provides no automated way to manage
file releases, so you must complete all the following steps using
the SF file-management Web interface.

The file-management Web interface has been updated. Please ee:
https://sourceforge.net/apps/trac/sourceforge/wiki/Release%20files%20for%20download

1.  On the SourceForge DocBook page, select Files.

2.  Select docbook-xsl.

3.  Select Add Folder, and enter the new release number.

4.  Change to the new folder, and select Add File.
Here you can upload these files:

  docbook-xsl-1.XX.X.zip
  docbook-xsl-1.XX.X.tar.bz2

5.  Upload a README text file, which will be displayed at the bottom
of that folder's page.

6.  Repeat the process for the namespaced stylesheets
docbook-xsl-ns-1.XX.X by putting
the files under the docbook-xsl-ns folder.

7.  Repeat the process for the stylesheet documentation
package docbook-xsl-doc-1.XX.X.


-----------------------------------------------------------------
Part 7: Announce a release
-----------------------------------------------------------------
This section explains how to announce a release.

1. Announcing to docbook-apps.
   To automatically post release announcements for the
   docbook-xsl and docbook-xsl-ns packages to the docbook-apps
   mailing list, run "make announce-ns":
 
     make announce-ns

2. Announcing at Sourceforge.

   Just as it lacks an automated way to manage file releases,
   Sourceforge also lacks any automated way to post release
   announcements at its site, so you must complete all the
   following steps using the SF News submission interface.

   A. Go to the project news admin page:

        http://sourceforge.net/news/admin/?group_id=21935

   B. Click Submit.

      The News submission form appears.

   C. In the Subject field, enter the following:

        "DocBook XSL 1.NN.N released"

      Where 1.NN.N is the version number for this release.

   D. In the Details area, enter something like the following:

        This release includes bug fixes and a few feature changes.

        https://sourceforge.net/projects/docbook/files/

   E. Click the Submit button.
      The News submission form re-appears.

   F. In the Subject field, enter the following:

        "DocBook XSL-NS 1.NN.N released"

      Where 1.NN.N is the version number for this release.

   G. In the Details area, enter something like the following.

        The DocBook XSL-NS stylesheets are namespaced versions of the
        DocBook XSL stylesheets, intended for use with DocBook 5
        documents.

        This release includes bug fixes and a few feature changes.

        https://sourceforge.net/projects/docbook/files/

   H. Go to the project News page and confirm that the announcements
      appear:

        http://sourceforge.net/news/?group_id=21935

-----------------------------------------------------------------
Part 8: Do post-release wrap-up
-----------------------------------------------------------------
This section explains the "wrap up" steps you need to do
following an official release.

1. Open the VERSION file.

2. Change the content of the PreviousRelease element to the
   version number you have just released.

3. Change the content of the PreviousReleaseRevision element to
   the number of the repository revision from which you built the
   release.

4. Change the content of the fm:Version element to the version
   number of the next anticipated release, with the string "-pre"
   appended; for example:

     <fm:Version>1.73.1-pre</fm:Version>

9. Check the VERSION file back in.

    svn commit \
      -m "Restored VERSION file to snapshot state" VERSION

-----------------------------------------------------------------
Part 9: Prepare for Freshmeat update
-----------------------------------------------------------------

*****************************************************************
* NOTE: The part of the build that updates Freshmeat is not
* currently working, so you can ignore this section.
*****************************************************************

This section explains how to prepare for updating Freshmeat with
information about a release.

You can send release updates to Freshmeat automatically, using
the freshmeat-submit script. But to use freshmeat-submit, you
will need to have a .netrc file in your home directory.

The contents of ~/.netrc file should look like this:

  machine freshmeat
    login userName
    password ********

Where "userName" is your Freshmeat username, and "********" is
your freshmeat password.

-----------------------------------------------------------------
Part 10: Update Freshmeat
-----------------------------------------------------------------

*****************************************************************
* NOTE: The part of the build that updates Freshmeat is not
* currently working, so you can ignore this section.
*****************************************************************

This section explains how to update Freshmeat with information
about a release.

To send release updates to Freshmeat automatically (without
needing to use the Freshmeat Web interface), complete the
following steps.

1. Go to the Latest File Releases page:

   http://sourceforge.net/project/showfiles.php?group_id=21935

   In the Release column, mouse over the "N.NN.N" link for the
   docbook-xsl package you have released. The URL for that link
   will look something like this

     http://sourceforge.net/project/showfiles.php?group_id=21935&package_id=16608&release_id=525619

2. Copy the value of the "release_id" parameter from that URL.

3. Run "make freshmeat" to send a release update to Freshmeat.

     make freshmeat SFRELID=NNNNNN FMGO=

   As the value of SFRELID, is the release_id value from step 2.

4. Repeat steps 1 and 2 to locate the release_id for the
   docbook-xsl-ns package.

5. Run "make freshmeat-ns" to send a release update to Freshmeat.

     make freshmeat-ns SFRELID=NNNNNN FMGO=


-----------------------------------------------------------------
NOTES
-----------------------------------------------------------------

  - all previous releases are permanently archived here:

     ftp://upload.sourceforge.net/pub/sourceforge/d/do/docbook/
