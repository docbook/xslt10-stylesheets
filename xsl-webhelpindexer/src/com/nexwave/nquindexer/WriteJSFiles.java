package com.nexwave.nquindexer;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.Map;
import java.util.TreeSet;

import com.nexwave.nsidita.DocFileInfo;

/**
 * Outputs the js files with:
 * - the list of html files and their description
 * - the words retrieved from the html files and their location
 * <p/>
 * 20110803: Adding improvements from Radu/Oxygen.
 *
 * @author N. Quaine
 * @author Kasun Gajasinghe
 * @version 2.0 2010-08-13
 */
public class WriteJSFiles {

    private static String txt_VM_encoding_not_supported = "This VM does not support the specified encoding.";
    private static String txt_indices_location = "The created index files are located in ";

    /**
     * Create a javascript array listing the html files with their paths relative to the project root
     *
     * @param fileO  path and name of the file in which to output the list of html files
     * @param list   of the html files, relative to the doc root directory
     * @param doStem If true then js files will generate words stemmed
     */
    public static void WriteHTMLList(String fileO, ArrayList<String> list, boolean doStem) {
        int i = 0;
        Iterator it;

        if (list == null) {
            return;
        }
        if (fileO == null) {
            return;
        }
        it = list.iterator();

        try {
            // open a outputstream, here a file
            OutputStream fOut = new FileOutputStream(fileO);
            OutputStream bout = new BufferedOutputStream(fOut);
            OutputStreamWriter out = new OutputStreamWriter(bout, "UTF-8");

            /*fl : file list*/
            out.write("//List of files which are indexed.\n");
            out.write("fl = new Array();\n");
            String temp;
            while (it.hasNext()) {
                temp = (String) it.next();
                //System.out.println("temp : "+File.separatorChar+" "+temp.replace(File.separatorChar, '/'));
                out.write("fl[\"" + i + "\"]" + "= \"" + temp.replace(File.separatorChar, '/') + "\";\n");
                i++;
            }

            out.write("var doStem = " + doStem + "");
            out.flush();  // Don't forget to flush!
            out.close();
//	        System.out.println("the array of html is in " +	fileO);

        }
        catch (UnsupportedEncodingException e) {
            System.out.println(txt_VM_encoding_not_supported);
        }
        catch (IOException e) {
            System.out.println(e.getMessage());
        }

    }

    /**
     * Create a javascript array listing the html files with
     * their paths relative to project root, their titles and shortdescs
     *
     * @param fileO path and name of the file in which to output the list of html files
     * @param list  of the html files, relative to the doc root directory
     */
    public static void WriteHTMLInfoList(String fileO, ArrayList<DocFileInfo> list) {
        int i = 0;
        Iterator it = null;

        if (list == null) {
            return;
        }
        if (fileO == null) {
            return;
        }
        it = list.iterator();
        try {
            // open a outputstream, here a file
            OutputStream fOut = new FileOutputStream(fileO);
            // open a buffer output stream
            OutputStream bout = new BufferedOutputStream(fOut);
            OutputStreamWriter out
                    = new OutputStreamWriter(bout, "UTF-8");

            /*fil : file list*/
            out.write("fil = new Array();\n");

            DocFileInfo tempInfo;
            String tempPath;
            String tempTitle;
            String tempShortdesc;
            while (it.hasNext()) {
                // Retrieve file information: path, title and shortdesc.
                tempInfo = (DocFileInfo) it.next();
                tempPath = tempInfo.getFullpath().toString().replace(File.separatorChar, '/');
                tempTitle = tempInfo.getTitle();
                tempShortdesc = tempInfo.getShortdesc();
                //Remove unwanted white char
                if (tempTitle != null) {
                    tempTitle = tempTitle.replaceAll("\\s+", " ");
                    tempTitle = tempTitle.replaceAll("['�\"]", " ");
                    //EXM-21239 Escape "\"
                    tempTitle = tempTitle.replaceAll("\\\\", "\\\\\\\\");
                }
                if (tempShortdesc != null) {
                    tempShortdesc = tempShortdesc.replaceAll("\\s+", " ");
                    tempShortdesc = tempShortdesc.replaceAll("['�\"]", " ");
                    //EXM-21239 Escape "\"
                    tempShortdesc = tempShortdesc.replaceAll("\\\\", "\\\\\\\\");
                }
                if (tempShortdesc != null) {
                    String stripNonAlphabeticalChars = stripNonAlphabeticalChars(tempShortdesc);
                    //stripNonAlphabeticalChars = stripWords(stripNonAlphabeticalChars);
                    stripNonAlphabeticalChars = stripNonAlphabeticalChars + "...";
                    out.write("fil[\"" + i + "\"]" + "= \"" + tempPath + "@@@" + tempTitle + "@@@" + stripNonAlphabeticalChars + "\";\n");
                    i++;
                } else {
                    out.write("fil[\"" + i + "\"]" + "= \"" + tempPath + "@@@" + tempTitle + "@@@null" + "\";\n");
                    i++;


                }
            }

            out.flush();  // Don't forget to flush!
            out.close();

        }
        catch (UnsupportedEncodingException e) {
            System.out.println(txt_VM_encoding_not_supported);
        }
        catch (IOException e) {
            System.out.println(e.getMessage());
        }

    }

    /**
     * Create javascript index files alphabetically.
     *
     * @param fileOutStr      contains the path and the suffix of the index files to create.
     *                        The first letter of the key is added to the given suffix. For example: e.g. a.js, b.js etc...
     * @param indexMap        its keys are the indexed words and
     *                        its values are the list of the files which contain the word.
     * @param indexerLanguage The language of the content that gets indexed
     */
    public static void WriteIndex(String fileOutStr, Map<String, ?> indexMap, String indexerLanguage) {
        OutputStreamWriter out;
        OutputStream bout;
        OutputStream fOut;
        String tstr;

        // check arguments
        if (indexMap == null || fileOutStr == null) {
            return;
        }

        // Collect the key of the index map
        TreeSet<String> sortedKeys = new TreeSet<String>();
        sortedKeys.addAll(indexMap.keySet());
        Iterator keyIt = sortedKeys.iterator();
        tstr = (String) keyIt.next();

        File fileOut = new File(fileOutStr);

        /* Writes the index to Three JS files, namely: index-1.js, index-2.js, index-3.js
		 * Index will be distributed evenly in these three files.
		 * tstr is the current key
		 * keyIt is the iterator of the key set
		 * */
        int indexSize = sortedKeys.size();
        for (int i = 1; i <= 3; i++) {
            try {
                // open a outputstream, here a file
                fOut = new FileOutputStream(fileOut.getParent() + File.separator + "index-" + i + fileOut.getName());
                bout = new BufferedOutputStream(fOut);
                out = new OutputStreamWriter(bout, "UTF-8");

                try {
                    /* Populate a javascript hashmap:
                      The key is a word to look for in the index,
                      The value is the numbers of the files in which the word exists.
                      Example: w["key"]="file1,file2,file3";*/
                    int count = 0;
                    if (i == 1)
                        out.write("var indexerLanguage=\"" + indexerLanguage + "\";\n");
                    out.write("//Auto generated index for searching.\n");
                    while (keyIt.hasNext()) {        //&& (tempLetter == tstr.charAt(0))
                        out.write("w[\"" + tstr + "\"]" + "=\"" + indexMap.get(tstr) + "\";\n");
                        tstr = (String) keyIt.next();
                        count++;
                        if (indexSize / count < 3) {
                            break;
                        }
                    }
                    out.write("\n");
                    out.flush();  // Don't forget to flush!
                    out.close();
                }
                catch (UnsupportedEncodingException e) {
                    System.out.println(txt_VM_encoding_not_supported);
                }
            }
            catch (IOException e) {
                System.out.println(e.getMessage());
            }
        }
        System.out.println(txt_indices_location + fileOutStr);
    }


    /**
     * Remove all non alphabetical chars from the end of a text.
     *
     * @param input The text who will be striped.
     * @return The striped text.
     */
    private static String stripNonAlphabeticalChars(String input) {
        String output = input;
        for (int i = input.length() - 1; i > 0; i--) {
            char charAt = input.charAt(i);
            int k = (int) charAt;
            if ((k > 65 && k < 91) || (k > 97 && k < 123) || (k > 48 && k < 58)) {
                return output;
            } else {
                output = output.substring(0, output.length() - 1);
            }
        }
        return output;
    }

    private static String stripWords(String input) {
        int idx = input.lastIndexOf(" ");
        if (idx != -1) {
            return input.substring(0, idx);
        } else {
			return input;
		}
	}
}