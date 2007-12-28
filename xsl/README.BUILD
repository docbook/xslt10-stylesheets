$Id$

Parts 0 and 1 of this document provide how-to instructions for
building the DocBook XSL Stylesheets.

Corrections and improvements from anyone to Parts 0 and 1 are
very welcome (preferably submitted in the form of patches against
this file, if you are not a DocBook Project member and can't submit
them directly). Note that the DocBook Wiki contains a page where
you can contribute notes and/or post comments about the build.

  http://wiki.docbook.org/topic/DocBookXslBuild

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

FIXME: Ideally, this Part 0 section should also provide more
details about what the third-party build dependencies are, not
just what other DocBook Project modules are needed or how to do
configuration to prepare for builds. Contributions welcome...

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
     export DOCBOOK_SVN=/opt/sandbox/docbook/trunk
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

   You can then source that by putting the following in your
   ~/.bashrc file:

     # set up some environment variables for DocBook/XML stuff
     . ~/docbk.sh

4. .xmlrc

   You need an .xmlrc file with some system-specific data for Java
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
     $DOCBOOK_SVN/buildtools/build-clean && \
     make all 2>&1 \
       XSLTENGINE=xsltproc \
       | tee DOCBOOK-BUILD.LOG && \
     $DOCBOOK_SVN/buildtools/build-check DOCBOOK-BUILD.LOG

   The preceding will cause the following:

     - runs the build using xsltproc, which is generally faster at
       building the stylesheets that Saxon is; to build with saxon
       instead of xsltproc, change the "xsltproc" above to "saxon".
     - safely cleans your workspace before the build is actually
       run (see below for details)
     - writes any error and warning messages to the
       DOCBOOK-BUILD.LOG log file
     - checks the DOCBOOK-BUILD.LOG file for errors & reports them

   NOTE: The build-clean script is just a "safe" wrapper around
   the svn-clean command; svn-clean is a perl script that's not
   part of the core subversion distribution (on my system, it's
   in the subversion-tools package). Its function is to "wipe out
   unversioned files from Subversion working copy". It is a good
   idea to use it because our own "clean" make target doesn't
   clean out everything that needs to be cleaned out to get your
   working directory back to a fresh state, and also doesn't
   prevent cruft in your workspace from accidentally getting
   packaged into a release build. So running build-clean
   (svn-clean) gives you a clean build environment and alerts you
   to cruft that needs to be deleted and also to any new files
   that you make have created but forgotten to actually check in.

3. make check (optional step)
   As an optional step to check for any major brokenness, run
   "make check", which will run a test transformation against
   the driver stylesheets for each output format (e.g.,
   html/docbook.xsl, fo/docbook.xsl, etc.).

   One recommended way to invoke "make check" is the following:

     rm -f DOCBOOK-BUILD.LOG && \
     . ~/docbk.sh && \
     make check 2>&1 \
       XSLTENGINE=xsltproc \
       | tee DOCBOOK-BUILD.LOG && \
     $DOCBOOK_SVN/buildtools/build-check DOCBOOK-BUILD.LOG

4. Fix any obvious problems.
   If build-check and/or "make check" report any problems, fix
   them. Then repeat Step 1 until you don't see any more problems.

5. Further testing.
   Once you have any obvious problems fixed (that is, the kind
   that build-check and "make check" can catch, you should
   do further testing of the changes (if any) that you have made
   to the stylesheet code. Try to test with a variety of test
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

1. make distrib
   If you have followed the steps in Part 1 above to successfully
   run a "make all" build, then to build a full distribution,
   "make distrib" (to smoke-test the build and to build the docs
   and additional stuff needed for the distribution).

   One recommended way to run "make distrib" is the following:

     rm -f DOCBOOK-BUILD.LOG && \
     . ~/docbk.sh && \
     $DOCBOOK_SVN/buildtools/build-clean && \
     make all 2>&1 \
       XSLTENGINE=xsltproc \
       | tee DOCBOOK-BUILD.LOG && \
     $DOCBOOK_SVN/buildtools/build-check DOCBOOK-BUILD.LOG && \
     $DOCBOOK_SVN/releasetools/catalog-install && \
     make distrib 2>&1 \
       XSLTENGINE=xsltproc \
       PDF_MAKER=dblatex \
       | tee DOCBOOK-BUILD.LOG && \
     $DOCBOOK_SVN/releasetools/catalog-install uninstall && \
     $DOCBOOK_SVN/buildtools/build-check DOCBOOK-BUILD.LOG

   The above first runs a "make all" build, and if that succeeds
   without any errors, then runs a "make distrib" build.

   NOTE: The engine specified in PDF_MAKER is only used to build a
   PDF of the release notes. If you want to use xep instead of
   dblatex, specify PDF_MAKER=xep. (There's no option to use fop
   because fop still doesn't do an adequate job of formatting the
   release notes.)

   NOTE: The catalog-install script "installs" some XML Catalog
   settings in your environment so xsltproc/saxon will resolve the
   http://docbook.sourceforge.net/release/xsl/current/ canonical
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
   for feature enhancements or changes to public APIs.

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
     $DOCBOOK_SVN/buildtools/build-clean && \
     make all 2>&1 \
       XSLTENGINE=xsltproc \
       | tee DOCBOOK-BUILD.LOG && \
     $DOCBOOK_SVN/buildtools/build-check DOCBOOK-BUILD.LOG && \
     $DOCBOOK_SVN/releasetools/catalog-install && \
     make release 2>&1 \
       XSLTENGINE=xsltproc \
       PDF_MAKER=dblatex \
       | tee DOCBOOK-BUILD.LOG && \
     $DOCBOOK_SVN/releasetools/catalog-install uninstall && \
     $DOCBOOK_SVN/buildtools/build-check DOCBOOK-BUILD.LOG; \
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
Part 5: Tag and install a release
-----------------------------------------------------------------
This section explains how to install/upload an actual docbook-xsl
release.

0. Make sure that you have the following programs installed:

   - lftp
   - ssh
   - scp

1. To tag the release and upload all the release packages
   (including all docbook-xsl, docbook-xsl-ns, and docbook-xsl-doc
   packages) to the Sourceforge "incoming" area and to the DocBook
   Project webspace, run "make install-ns":

     make install-ns

-----------------------------------------------------------------
Part 6: Manage release files
-----------------------------------------------------------------
This section explains how to manage release files using the
file-management interface at Sourceforge.

Unfortunately, Sourceforge provides no automated way to manage
file releases, so you must complete all the following steps using
the SF file-management Web interface.

NOTE: Try hard to make sure you've got everything prepared OK,
because the SF file-management system is extremely unwieldy, and
it makes unwinding an upload mistake a major PITA. If you do make
a mistake, see the next section for details on how to fix it.

01. Go to the DocBook Project master File Release System page:

    http://sourceforge.net/project/admin/editpackages.php?group_id=21935

02. Click the "Add Release" link for the docbook-xsl package.
    The "Create a File Release" form appears.

03. In the "New Release Name" input box, type just the version
    number of this release.

04. Click "Create This Release".

    Another form appears.

05. Under "Step 1. Edit Existing Release", click the Choose button
    next to the "Upload Release Notes" input box, and browse for
    the location of the generated RELEASE-NOTES-PARTIAL.txt file
    on your system.

06. Under "Step 1. Edit Existing Release", click the Choose button
    next to the "Upload Change Log" input box, and browse for the
    location of the generated NEWS file on your system.

07. Click the "Preserve my pre-formatted text." checkbox.

08. Click the "Submit/Refresh" button.

09. In the "Step 2: Add Files To This Release" section, scroll
    down and find the docbook-xsl-1.NN.N packages (just the
    docbook-xsl packages -- not the docbook-xsl-doc or
    docbook-xsl-ns ones), and click the checkboxes next to them,
    then click the "Add Files and/or Refresh View" button.

10. In the "Step 3: Edit Files In This Release" area, for each of
    the packages, select the appropriate values from the
    Processor and File Type select boxes, and click the
    corresponding "Update/Refresh" button.

    For Processor, just choose "Any".

    For File Type, just choose either .bz2, .gz, or .zip -- don't
    choose the "Source" versions of those (these are not source
    packages).

11. In the "Step 4: Email Release Notice" area, click the "I'm
    sure" checkbox, then click the "Send Notice" button.

12. Repeat steps 1 through 11 above for the docbook-xsl-ns and
    docbook-xsl-doc packages.

13. Go to the project "Latest File Releases" page and confirm
    that releases you have created appear there.

      http://sourceforge.net/project/showfiles.php?group_id=21935

-----------------------------------------------------------------
Part 7: Fix upload mistakes
-----------------------------------------------------------------
This section explains what to do in case you've made a mistake
and need to upload replacements for packages you've uploaded
previously.

If you make a mistake and need to upload new/replacement packages
to the SF incoming area, complete the following steps to upload
the new packages.

1. Go to the DocBook Project master File Release System page:

   http://sourceforge.net/project/admin/editpackages.php?group_id=21935

2. Click the "Edit Releases" link next to whatever package(s) you
   want to delete and/or re-upload files for.

   The list of active releases for that package appears.

3. Click the "Edit this Release" link next to the whatever version
   you have uploaded.

   Another form appears.

4. Scroll down to "Step 3: Edit Files In This Release" section and
   for each of the items there, click the "I'm Sure" checkbox and
   then the "Delete File" button, and repeat until all the items
   have been deleted.

5. If the "bad" packages that you want to replace are
   still/already in the incoming area, then:

     a. Scroll back up to the "Step 2: Add Files To This Release"
        section
     b. Click the checkboxes next to the "bad" packages
     c. Click the "Add Files and/or Refresh View" button.
     d. Scroll back down to the "Step 3: Edit Files In This Release"
        section and immediately repeat step 4 to delete them.

6. Re-run the "Release Install" step above, after you have built
   the new packages.

7. Scroll back up to the "Step 2: Add Files To This Release"
   section, and click the "Add Files and/or Refresh View" button.

   The packages you uploaded in step 6 will now appear in the list
   of files in the "Step 2: Add Files To This Release" section.

8. Click the checkboxes next to the updated packages you uploaded
   in step 6, and click the "Add Files and/or Refresh View" button.

9. Scroll back down to the "Step 3: Edit Files In This Release"
   section and for each of the packages, select the appropriate
   values from the Processor and File Type select boxes, and click
   the corresponding "Update/Refresh" button.

   For Processor, just choose "Any".

   For File Type, just choose either .bz2, .gz, or .zip -- don't
   choose the "Source" versions of those (these are not source
   packages).

-----------------------------------------------------------------
Part 8: Announce a release
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

        http://sourceforge.net/project/showfiles.php?group_id=21935

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

        http://sourceforge.net/project/showfiles.php?group_id=21935

   H. Go to the project News page and confirm that the announcements
      appear:

        http://sourceforge.net/news/?group_id=21935

-----------------------------------------------------------------
Part 9: Prepare for Freshmeat update
-----------------------------------------------------------------
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
Part 11: Do post-release wrap-up
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
NOTES
-----------------------------------------------------------------

  - all previous releases are permanently archived here:

     ftp://upload.sourceforge.net/pub/sourceforge/d/do/docbook/
