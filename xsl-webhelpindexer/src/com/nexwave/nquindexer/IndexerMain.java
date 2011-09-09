package com.nexwave.nquindexer;

import com.nexwave.nsidita.DirList;
import com.nexwave.nsidita.DocFileInfo;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.*;

/**
 * Main class of Stand-alone version of WebHelpIndexer
 *
 * User: Kasun Gajasinghe, University of Moratuwa, http://kasunbg.blogspot.com
 * Date: Feb 10, 2011
 *
 * @author Kasun Gajasinghe
 */

public class IndexerMain {

    // messages
    private String txt_no_inputdir = "Input directory not found:";
    private String txt_cannot_create_outputdir = "Cannot create output search directory.";
    private String txt_no_files_found = "No html files found.";
    private String txt_wrong_dita_basedir = "ERROR: Parser initialization failed. Wrong dita base dir";
    private String txt_no_relative_files_found = "No relative html files calculated.";
    private String txt_no_words_gathered = "No words have been indexed in";
    private String txt_no_html_files = "No HTML Files found in";
    private String txt_no_args = "No argument given: you must provide an htmlDir to the IndexerMain";

    private static String txt_no_lang_specified = "Language of the content is not specified. Defaults to English.";

    //working directories
    private String searchdir = "search";
    private File inputDir = null;
    private String outputDir = null;
    private String projectDir = null;

    // ANT parameters
    public String htmlDir = null;
    public String indexerLanguage = "en";

    //supported languages: add new additions to this. don't include country codes to the end such as en_US or en_UK,
    // as stemmers doesn't find a difference between them.
    private String[] supportedLanguages = {"en", "de", "fr", "zh", "ja", "ko"}; //currently extended support available for
    // English, German, French and CJK (Chinese [zh], Japanese [ja], Korean [ko]) languages only.

    // Indexing features: words to remove
    private ArrayList<String> cleanUpStrings = null;
    private ArrayList<String> cleanUpChars = null;

    //Html extension
    private String htmlExtension = "html";

    // OXYGEN PATCH START
    //Table of contents file name
    private String tocfile;
    private boolean stem;
    // OXYGEN PATCH END

    // Constructors

    public IndexerMain(String htmlDir, String indexerLanguage) {
        super();
        setHtmlDir(htmlDir);
        setIndexerLanguage(indexerLanguage);
    }

    /**
     * The content language defaults to English "en"
     *
     * @param htmlDir The directory where html files reside.
     */
    public IndexerMain(String htmlDir) {
        super();
        setHtmlDir(htmlDir);
        setIndexerLanguage("en");
    }

    /**
     * The setter for the "htmlDir" attribute (parameter of the task)
     *
     * @param htmlDir
     */
    public void setHtmlDir(String htmlDir) {
        this.htmlDir = htmlDir;
    }

    /**
     * Set the extension in which html files are generated
     *
     * @param htmlExtension The extension in which html files are generated
     */
    public void setHtmlextension(String htmlExtension) {
        this.htmlExtension = htmlExtension;
        //Trim the starting "."
        if (this.htmlExtension.startsWith(".")) {
            this.htmlExtension = this.htmlExtension.substring(1);
        }
    }

    /**
     * setter for "indexerLanguage" attribute from ANT
     *
     * @param indexerLanguage language for the search indexer. Used to differentiate which stemmer to be used.
     */
    public void setIndexerLanguage(String indexerLanguage) {
        if (indexerLanguage != null && !"".equals(indexerLanguage)) {
            int temp = indexerLanguage.indexOf('_');
            if (temp != -1) {
                indexerLanguage = indexerLanguage.substring(0, temp);
            }
            int i = 0;
            for (; i < supportedLanguages.length; i++) {
                if (indexerLanguage.equals(supportedLanguages[i])) {
                    this.indexerLanguage = supportedLanguages[i];
                    break;
                }
            }

            //if not in supported language list,
            if (i >= supportedLanguages.length) {
//                System.out.println("The given language, \""+indexerLanguage+"\", does not have extensive support for " +
//                        "searching. Check documentation for details. ");
                this.indexerLanguage = indexerLanguage;
            }
        } else {
            this.indexerLanguage = "@@"; //fail-safe mechanism, This vm should not reach this point.
        }
    }

    /**
     * com.nexwave.nquindexer.IndexerMain
     * The main class without Ant dependencies.
     * This can be used as a standalone jar.
     *
     * @param args need two parameters for this array. htmlDirectory indexerLanguage
     *             If only one parameter is there (htmlDir), indexerLanguage defaults to english
     */
    public static void main(String[] args) {

        IndexerMain indexer;
        if (args.length == 1) {
            System.out.println(txt_no_lang_specified);
            indexer = new IndexerMain(args[0]);
        } else if (args.length >= 2) {

            indexer = new IndexerMain(args[0], args[1]);
        } else {
            throw new RuntimeException("Please specify the parameters htmlDirectory and " +
                    "indexerLanguage (optional). \n " +
                    "ex: java -jar webhelpindexer.jar docs/content en \n" +
                    "The program will exit now."
            );
        }

        indexer.execute();

    }


    /**
     * Implementation of the execute function (Task interface)
     */
    public void execute() {
        try {
            //Use Xerces as the parser. Does not support Saxon6.5.5 parser
            System.setProperty("org.xml.sax.driver", "org.apache.xerces.parsers.SAXParser");
            System.setProperty("javax.xml.parsers.SAXParserFactory", "org.apache.xerces.jaxp.SAXParserFactoryImpl");
//           System.setProperty("org.xml.sax.driver", "com.icl.saxon.aelfred.SAXDriver");
//           System.setProperty("javax.xml.parsers.SAXParserFactory", "com.icl.saxon.aelfred.SAXParserFactoryImpl");
        } catch (SecurityException se) {
            System.out.println("[WARNING] Default parser is not set to Xerces. Make sure Saxon6.5.5 " +
                    "is not in your CLASSPATH.");
        } catch (Exception e) {
            System.out.println("[WARNING] Default parser is not set to Xerces. Make sure Saxon6.5.5 " +
                    "is not in your CLASSPATH");
        }

        ArrayList<DocFileInfo> filesDescription = null; // list of information about the topic files
        ArrayList<File> htmlFiles = null; // topic files listed in the given directory
        ArrayList<String> htmlFilesPathRel = null;
        Map<String, String> tempDico = new HashMap<String, String>();
        Iterator it;

        //File name initialization
        String htmlList = "htmlFileList.js";
        String htmlInfoList = "htmlFileInfoList.js";
        String indexName = ".js";

        //timing
        Date dateStart = new Date();

        if (htmlDir == null) {
            System.out.println(txt_no_args + ".");
            return;
        }
        // Init input directory
        inputDir = new File(htmlDir);

        // Begin of init
        // check if inputdir initialized
        if (inputDir == null) {
            DisplayHelp();
            return;
        }

        // check if inputdir exists
        if (!inputDir.exists()) {
            System.out.println(txt_no_inputdir + " " + inputDir + ".");
            return;
        }

        // check if outputdir defined
        if (outputDir == null) {
            //set the output directory: path= {inputDir}/search
            outputDir = inputDir.getPath().concat(File.separator).concat(searchdir);
        }

        // check if outputdir exists
        File tempfile = new File(outputDir);
        if (!tempfile.exists()) {
            boolean b = (new File(outputDir)).mkdir();
            if (!b) {
                System.out.println(txt_cannot_create_outputdir + " " + outputDir + ".");
                return;
            }
        }

        // check if projdir is defined
        if (projectDir == null) {
            projectDir = inputDir.getPath();
        }
        //end of init


        // Get the list of all html files but the tocs, covers and indexes
        DirList nsiDoc = new DirList(inputDir, "^.*\\." + htmlExtension + "?$", 1);
        htmlFiles = nsiDoc.getListFiles();
        // Check if found html files
        if (htmlFiles.isEmpty()) {
            System.out.println(txt_no_html_files + " " + inputDir + ".");
            return;
        }
        // Get the list of all html files with relative paths
        htmlFilesPathRel = nsiDoc.getListFilesRelTo(projectDir);

        // OXYGEN PATCH START.
        // Remove the table of content file
        Iterator<String> iterator = htmlFilesPathRel.iterator();
        while (iterator.hasNext()) {
            if (iterator.next().endsWith(tocfile + "." + htmlExtension)) {
                iterator.remove();
            }
        }
        // OXYGEN PATCH END
        if (htmlFiles == null) {
            System.out.println(txt_no_files_found);
            return;
        } else if (htmlFilesPathRel == null) {
            System.out.println(txt_no_relative_files_found);
            return;
        }

        // Create the list of the existing html files (index starts at 0)
        WriteJSFiles.WriteHTMLList(outputDir.concat(File.separator).concat(htmlList), htmlFilesPathRel, stem);

        // Parse each html file to retrieve the words:
        // ------------------------------------------

        // Retrieve the clean-up properties for indexing
        RetrieveCleanUpProps();
        // System.out.print("clean"+" " +cleanUpStrings);

        //create a default handler
        //SaxHTMLIndex spe = new SaxHTMLIndex (); // do not use clean-up props files
        //SaxHTMLIndex spe = new SaxHTMLIndex (cleanUpStrings); // use clean-up props files
        SaxHTMLIndex spe = new SaxHTMLIndex(cleanUpStrings, cleanUpChars); // use clean-up props files

        if (spe.init(tempDico) == 0) {

            //create a html file description list
            filesDescription = new ArrayList<DocFileInfo>();

            it = htmlFiles.iterator();

            // parse each html files
            while (it.hasNext()) {
                File ftemp = (File) it.next();
                // OXYGEN PATCH START. Remove table of content file
                if (!ftemp.getAbsolutePath().endsWith(tocfile + "." + htmlExtension)) {
                    // OXYGEN PATCH END
                    //tempMap.put(key, value);
                    //The HTML file information are added in the list of FileInfoObject
                    DocFileInfo docFileInfoTemp = new DocFileInfo(spe.runExtractData(ftemp, indexerLanguage, stem));

                    ftemp = docFileInfoTemp.getFullpath();
                    String stemp = ftemp.toString();
                    int i = stemp.indexOf(projectDir);
                    if (i != 0) {
                        System.out.println("the documentation root does not match with the documentation input!");
                        return;
                    }
                    int ad = 1;
                    if (stemp.equals(projectDir)) ad = 0;
                    stemp = stemp.substring(i + projectDir.length() + ad);  //i is redundant (i==0 always)
                    ftemp = new File(stemp);
                    docFileInfoTemp.setFullpath(ftemp);

                    filesDescription.add(docFileInfoTemp);
                    // OXYGEN PATCH START
                    // Remove the table of content file
                } else {
                    it.remove();
                }
                // OXYGEN PATCH END
            }
            /*remove empty strings from the map*/
            if (tempDico.containsKey("")) {
                tempDico.remove("");
            }
            // write the index files
            if (tempDico.isEmpty()) {
                System.out.println(txt_no_words_gathered + " " + inputDir + ".");
                return;
            }

//            WriteJSFiles.WriteIndex(outputDir.concat(File.separator).concat(indexName), tempDico);
            WriteJSFiles.WriteIndex(outputDir.concat(File.separator).concat(indexName), tempDico, indexerLanguage);

            // write the html list file with title and shortdesc
            //create the list of the existing html files (index starts at 0)
            WriteJSFiles.WriteHTMLInfoList(outputDir.concat(File.separator).concat(htmlInfoList), filesDescription);

            //perf measurement
            Date dateEnd = new Date();
            long diff = dateEnd.getTime() - dateStart.getTime();
            if (diff < 1000)
                System.out.println("Delay = " + diff + " milliseconds");
            else
                System.out.println("Delay = " + diff / 1000 + " seconds");
        } else {
            System.out.println(txt_wrong_dita_basedir);
        }
    }

    /**
     * Prints the usage information for this class to <code>System.out</code>.
     */
    private static void DisplayHelp() {
        String lSep = System.getProperty("line.separator");
        StringBuilder msg = new StringBuilder();
        msg.append("USAGE:").append(lSep);
        msg.append("   java -classpath TesterIndexer inputDir outputDir projectDir").append(lSep);
        msg.append("with:").append(lSep);
        msg.append("   inputDir (mandatory) :  specify the html files ' directory to index").append(lSep);
        msg.append("   outputDir (optional) : specify where to output the index files").append(lSep);
        msg.append("   projectDir (optional) : specify the root of the documentation directory").append(lSep);
        msg.append("Example:").append(lSep);
        msg.append("   java -classpath TesterIndexer /home/$USER/DITA/doc").append(lSep);
        msg.append("Example 2:").append(lSep);
        msg.append("   java -classpath TesterIndexer /home/$USER/webhelp/docs/content /home/$USER/docs/content/search /home/$USER/webhelp/docs").append(lSep);
        System.out.println(msg.toString());
    }

    private int RetrieveCleanUpProps() {

        // Files for punctuation (only one for now)
        String[] punctuationFiles = new String[]{"punctuation.props"};
        FileInputStream input;
        String tempStr;
        File ftemp;
        Collection c = new ArrayList<String>();

        // Get the list of the props file containing the words to remove (not the punctuation)
        DirList props = new DirList(inputDir, "^(?!(punctuation)).*\\.props$", 1);
        ArrayList<File> wordsList = props.getListFiles();
//		System.out.println("props files:"+wordsList);
        //TODO all properties are taken to a single arraylist. does it ok?.
        Properties enProps = new Properties();
        String propsDir = inputDir.getPath().concat(File.separator).concat(searchdir);

        // Init the lists which will contain the words and chars to remove
        cleanUpStrings = new ArrayList<String>();
        cleanUpChars = new ArrayList<String>();

        try {
            // Retrieve words to remove
            for (File aWordsList : wordsList) {
                ftemp = aWordsList;
                if (ftemp.exists()) {
                    enProps.load(input = new FileInputStream(ftemp.getAbsolutePath()));
                    input.close();
                    c = enProps.values();
                    cleanUpStrings.addAll(c);
                    enProps.clear();
                }
            }

            // Retrieve char to remove (punctuation for ex.)
            for (String punctuationFile : punctuationFiles) {
                tempStr = propsDir.concat(File.separator).concat(punctuationFile);
                ftemp = new File(tempStr);
                if (ftemp.exists()) {
                    enProps.load(input = new FileInputStream(tempStr));
                    input.close();
                    c = enProps.values();
                    cleanUpChars.addAll(c);
                    enProps.clear();
                }
            }
        }
        catch (IOException e) {
            e.printStackTrace();
            return 1;
        }
        return 0;
    }

    // OXYGEN PATCH START
    // Set table of content file

    public void setTocfile(String tocfile) {
        this.tocfile = tocfile;
    }
    // If true then generate js files with stemming words

    public void setStem(boolean stem) {
        this.stem = stem;
    }
    // OXYGEN PATCH END
}
