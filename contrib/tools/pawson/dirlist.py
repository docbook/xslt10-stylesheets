#dirlist.py,  Dave Pawson; Help from Uche Ogbuji
#Write a disk directory out in XML format.
#
# Update:9 May 05. 1.1  Re-worked for Linux using 4Suite.
#       : Added datetime and size
# Update: 17 May 05 1.2
#         Rev 1.1
#       : Corrected getops processing
#       : Todo. work out what to do with messages for pipelining.
#       : A clean solution would omit this.
# Update:22 May 05
# Cleaned up size conversion, added /? for win32 users.
# 
# Update: 23 May 05
#       : Uche mentioned PEP 8! Duly updated. Is that a pep talk?
#
#
#
# Update: 15 June 05
#       : Directory names, on win32 showing up as C:\dir\dir
#       : Changed to work as url's
#       : C:/dir/dir  (OK with file:/)
#       : Additional parameter, -n  to stop recursion beyond
#                            top directory
#       : Files filtered by global string constant... Should it be a param?
#       : defaults to all nnn.xml files, where n is an integer
# Update: 25 June 05
#       : Removed bug. Filtering on pattern did not wrap enough code.
# Copyright Dave Pawson, Uche Ogbuji 2005
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

from  shutil import copy2
import sys
import getopt
import os.path
import re
import time
from xml.dom.ext.reader import Sax2
from xml import xpath
from stat import *
import md5
from Ft.Xml import MarkupWriter # Download from
#http://sourceforge.net/project/showfiles.php?group_id=39954&package_id=41020&release_id=320824

#
#
#
version = "1.4"
date = "2005-06-26T14:19:16Z"
prog = "dirlist"

filePattern ="[a-z.]+\.xml$"

#debug=7
#
#recurse through the path, writing directory and filenames
#if date=true, add date attribute
#if size=true, add size attribute
#
def recurse_dir(path, writer, date, size, md5op,recurs):
    for cdir, subdirs, files in os.walk(path):
        writer.startElement(u'directory',
                            attributes={u'name': unicode(cdir)})
        patt=re.compile(filePattern) # only look for requisite files
        for f in files:
            if (patt.match(f)):
                accessedTime = formatTime(os.stat(os.path.join(cdir,f))[ST_MTIME])
                sz = formatSize(os.stat(os.path.join(cdir,f))[ST_SIZE])
                md5 = md5sum(os.path.join(cdir,f))
                writer.startElement(u'file',attributes={u'name': unicode(f)})
                
                if (date):
                    writer.attribute(u'date', unicode(accessedTime))
                if (size):
                    writer.attribute(u'sz', unicode(sz))
                if (md5op):
                    writer.attribute(u'md5',unicode(md5))
                writer.endElement(u'file')
        if (recurs):
            for subdir in subdirs: recurse_dir(os.path.join(cdir, subdir),
                                           writer,date,size,md5op,recurs)
        writer.endElement(u'directory')
        break


#
#Convert Time to local time
#print datetime.datetime(2004,5,5).strftime('%x')
def formatTime(tics):
    import datetime
    # Converting Epoch Seconds to DMYHMS
    t = datetime.datetime.fromtimestamp(tics)
    # print t.strftime('%Y-%m-%d')
    return t.strftime('%Y-%m-%d')


#
# Convert size to kB or Mb.
# Omit the L from the size, for readability.
#
def formatSize(b):
    if (b < 1024):
        return repr(b)[:-1]+"b"
    if (b < (1024 * 1024)):
        return repr(b / 1024)[:-1]+"Kb"
    else:
        return repr(b / (1024*1024))+"Mb"


#
#Calculate the md5sum for given file
#
def md5sum(fname):
    myfile = open(fname)
    m = md5.new()
    md5sums = 0
    for aline in myfile.readlines():
        m.update(aline)
        myfile.close()
    return m.hexdigest()



#
#Return the id value from a given xml file, or null string if not found
#
#

def getID(fname):
    print fname
    # create Reader object
    reader = Sax2.Reader()
    # parse the document
    doc = reader.fromStream(fname)
    nodes = xpath.Evaluate('//*[local-name()="id"]',doc.documentElement)
    return nodes[0].firstChild.nodeValue

    
        
    



#
#Obtain a list of files in a given directory
#returns a possibly empty dictionary of NNN:dir/noteNNN.txt
#
def genXML(directory, out, addDate,addSize, md5op,recurs):
    writer = MarkupWriter(out, indent=u"yes")
    writer.startDocument()
    recurse_dir(directory, writer, addDate, addSize, md5op,recurs)


#
# Print usage instructions
#
def usage():
    usg = """
    %s.py Version %s" 
    Usage: \n python %s.py  [options] -p path -o outputXMLFile 
    \t\t Produces an XML file,
    \t\t\t listing the directory (path) provided 
    \t\t Options:
    \t\t -d --date  Add date attribute
    \t\t -s --size  Add size attribute
    \t\t -m --mdsum Add md5sum attribute
    \t\t -n --norecurse Do not recurse into directories
    \t\t\t -p[--path] Path to directory to process
    \t\t\t -o output file.
    \t\t\t Omit the output option to generate output to stdout
    """ \
    % (prog, version, prog)
    print usg


#
# Main program entry
#
def main():
    if len(sys.argv) < 2:
        usage()
        sys.exit(2)
    outfile = sys.stdout
    outfile = ""
    directory = None
    addDate = False
    md5op = False
    addSize = False
    recurs = True
    try:
        opts, args = \
              getopt.getopt(sys.argv[1:],
                            "hsdmnp:o:",
                            ["help","size","date","md5sum","norecurse","path=","output="])
    except getopt.GetoptError:
        print "\t\tInvalid arguments"
        usage()  # print help information and exit:
        sys.exit(2)
    if (len(opts) < 1):
        print "Insufficient arguments", len(args)
        usage()
        sys.exit(2)
    for o, a in opts:
        if o in ("?", "//?"):
            usage()
            sys.exit()
        if o in ("-p","--path"):
            directory = os.path.realpath(a)
        if o in ("-d", "--date"):
            addDate = True
        if o in ("-m", "--md5sum"):
            md5op=True
        if o in ("-s", "--size"):
            addSize = True
        if o in ("-h", "--help"):
            usage()
            sys.exit()
        if o in ("-n", "--norecurse"):
            recurs = False
        if o in ("-o","--output"):
            outfile = a
    if not( os.path.isdir(directory)):
        sys.stderr.write ("\t\t Error, '%s' is not a directory\n" % directory) 
        sys.exit(2)
    try:
        if (outfile <> ""):
            out = open(outfile,'w')
        else:
            out = sys.stdout
    except EnvironmentError:
        sys.stderr.write("%s not writable, Quitting" %outfile)
        sys.exit(2)


#
# Call the main method.
#
    genXML(directory, out, addDate, addSize, md5op,recurs)
    if (outfile != ""):
        out.close()


if __name__ == '__main__':
    main()

#http://www.jorendorff.com/articles/python/path/
