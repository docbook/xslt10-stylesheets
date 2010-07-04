package com.nexwave.nquindexer;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Properties;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.Task;


import com.nexwave.nsidita.DirList;
import com.nexwave.nsidita.DocFileInfo;
/**
 * Indexer ant task.
 * 
 * @version 1.0 2008-02-26
 * 
 * @author N. Quaine
 */
public class IndexerTask extends Task {
	
	// messages
	private String txt_no_inputdir = "Input directory not found:";
	private String txt_cannot_create_outputdir = "Cannot create output search directory.";
	private String txt_no_files_found = "No html files found.";
	private String txt_wrong_dita_basedir = "ERROR: Parser initialization failed. Wrong dita base dir";
	private String txt_no_relative_files_found= "No relative html files calculated.";
	private String txt_no_words_gathered= "No words have been indexed in";
	private String txt_no_html_files="No HTML Files found in";
	private String txt_no_args="No argument given: you must provide an htmldir to the IndexerTask";
	
	//working directories
	private String searchdir = "search";
	private File inputDir = null;
	private String outputDir = null;
	private String projectDir = null;	

	// ANT parameters
	private String htmldir=null;

	// Indexing features: words to remove
	private ArrayList<String> cleanUpStrings = null;	
	private ArrayList<String> cleanUpChars = null;
	
	// Constructor
	public IndexerTask() {
		super();

	}
	/** The setter for the "htmldir" attribute (parameter of the task)
	 * @param args
	 * @throws InterruptedException 
	 */
    public void setHtmldir(String htmldir) {
        this.htmldir = htmldir;
    }

	
	/**
	 * Implementation of the execute function (Task interface)
	 */
	public void execute() throws BuildException {
		
		ArrayList<DocFileInfo> filesDescription = null; // list of information about the topic files
		ArrayList<File> htmlFiles = null; // topic files listed in the given directory
		ArrayList<String> htmlFilesPathRel = null;
		Map tempDico = new HashMap(); 
		Iterator it;
		
		//File name initialization
		String htmlList = new String ("htmlFileList.js");
		String htmlInfoList = new String ("htmlFileInfoList.js");
		String indexName = new String(".js");
		
		//timing
		Date dateStart = new Date();
		
		if (htmldir == null) {
			System.out.println(txt_no_args + ".");
			return;
		}
		// Init input directory
		inputDir = new File(htmldir);

		// Begin of init
		// check if inputdir initialized
		if (inputDir == null) {
			DisplayHelp();
			return;
		}
		
		// check if inputdir exists		
		if (!inputDir.exists()) {
			System.out.println(txt_no_inputdir + " "+ inputDir + ".");
			return;
		}
		
		// check if outputdir defined
		if (outputDir == null) {
			outputDir = new String(inputDir.getPath().concat(File.separator).concat(searchdir));
		}

		// check if outputdir exists
		File tempfile = new File(outputDir); 
		if (!tempfile.exists()) {
			boolean b = (new File(outputDir)).mkdir();
			if (!b) {
				System.out.println(txt_cannot_create_outputdir + " "+ outputDir + ".");
				return;
			}
		}
		
		// check if projdir is defined
		if (projectDir == null) {
			projectDir = new String(inputDir.getPath());
		}
		//end of init
		

		// Get the list of all html files but the tocs, covers and indexes
		//DirList nsiDoc = new DirList(inputDir, "^(?!(toc|index|search|frameset|ix01)).*\\.html$", 1);
		DirList nsiDoc = new DirList(inputDir, "^.*\\.html?$", 1);
		htmlFiles = nsiDoc.getListFiles();
		// Check if found html files
		if (htmlFiles.isEmpty()) {
			System.out.println(txt_no_html_files + " "+ inputDir + ".");
			return;
		}
		// Get the list of all html files with relative paths 
		htmlFilesPathRel = nsiDoc.getListFilesRelTo(projectDir);
		
		if (htmlFiles == null) {
			System.out.println(txt_no_files_found);
			return;
		} else if (htmlFilesPathRel == null) {
			System.out.println(txt_no_relative_files_found);
			return;			
		}
		
		// Create the list of the existing html files (index starts at 0)
		WriteJSFiles.WriteHTMLList(outputDir.concat(File.separator).concat(htmlList), htmlFilesPathRel);
		
		// Parse each html file to retrieve the words:
		// ------------------------------------------
		
		// Retrieve the clean-up properties for indexing
		RetrieveCleanUpProps();
	    //System.out.print("clean"+" " +cleanUpStrings);
	    
		//create a default handler
		//SaxHTMLIndex spe = new SaxHTMLIndex (); // do not use clean-up props files
		//SaxHTMLIndex spe = new SaxHTMLIndex (cleanUpStrings); // use clean-up props files
		SaxHTMLIndex spe = new SaxHTMLIndex (cleanUpStrings, cleanUpChars); // use clean-up props files

		if ( spe.init(tempDico) == 0 ) {

			//create a html file description list
			filesDescription = new ArrayList <DocFileInfo> ();
			
			it = htmlFiles.iterator ( ) ;
			
			// parse each html files
			while ( it.hasNext ( ) ) {
				File ftemp = (File) it.next();
				//tempMap.put(key, value);
				//The HTML file information are added in the list of FileInfoObject
				DocFileInfo docFileInfoTemp = new DocFileInfo(spe.runExtractData(ftemp));
				
				ftemp = docFileInfoTemp.getFullpath();
				String stemp = ftemp.toString();
				int i = stemp.indexOf(projectDir);
				if ( i != 0 ) {
					System.out.println("the documentation root does not match with the documentation input!");
					return;
				}
				int ad = 1;
				if (stemp.equals(projectDir)) ad = 0; 
				stemp = stemp.substring(i+projectDir.length()+ad);
				ftemp = new File (stemp);
				docFileInfoTemp.setFullpath(ftemp);
				
				filesDescription.add(docFileInfoTemp);
			}
			/*remove empty strings from the map*/
			if (tempDico.containsKey("")) {
				tempDico.remove("");
			}
			// write the index files
			if (tempDico.isEmpty()) {
				System.out.println(txt_no_words_gathered + " "+ inputDir + ".");
				return;
			}
			
			WriteJSFiles.WriteIndex(outputDir.concat(File.separator).concat(indexName), tempDico);
			
			// write the html list file with title and shortdesc
			//create the list of the existing html files (index starts at 0)
			WriteJSFiles.WriteHTMLInfoList(outputDir.concat(File.separator).concat(htmlInfoList), filesDescription);
			
			//perf measurement
			Date dateEnd = new Date();
			long diff = dateEnd.getTime() - dateStart.getTime();
			System.out.println("Delay = " + diff/1000 + " sec");
		}else {
			System.out.println(txt_wrong_dita_basedir);
			return;
		}
	}
	
	/**
     * Prints the usage information for this class to <code>System.out</code>.
     */
    private static void DisplayHelp() {
    	String lSep = System.getProperty("line.separator");
        StringBuffer msg = new StringBuffer();
        msg.append("USAGE:" + lSep);        
        msg.append("   java -classpath TesterIndexer inputDir outputDir projectDir" + lSep);
        msg.append("with:" + lSep);
        msg.append("   inputDir (mandatory) :  specify the html files ' directory to index" + lSep);
        msg.append("   outputDir (optional) : specify where to output the index files" + lSep);
        msg.append("   projectDir (optional) : specify the root of the documentation directory" + lSep);
        msg.append("Example:" + lSep);
        msg.append("   java -classpath TesterIndexer /home/$USER/DITA/doc" + lSep);
        msg.append("Example 2:" + lSep);
        msg.append("   java -classpath TesterIndexer /home/$USER/DITA/doc/customer/concepts /home/$USER/temp/search /home/$USER/DITA/doc/" + lSep);
        System.out.println(msg.toString());
    }
    private int RetrieveCleanUpProps (){

    	// Files for punctuation (only one for now)
        String[] punctuationFiles = new String[] {"punctuation.props"};
        FileInputStream input;
        String tempStr= new String();
        File ftemp;
        Collection c = new ArrayList<String>();
                
		// Get the list of the props file containing the words to remove (not the punctuation)
        DirList props = new DirList(inputDir, "^(?!(punctuation)).*\\.props$", 1);
		ArrayList<File>wordsList = props.getListFiles();
		System.out.println("props files:"+wordsList);
		
		Properties enProps =new Properties ();
		String propsDir = new String (inputDir.getPath().concat(File.separator).concat(searchdir));
		
		// Init the lists which will contain the words and chars to remove 
		cleanUpStrings = new ArrayList<String>();
		cleanUpChars = new ArrayList<String>();
		
	    try {
	    	// Retrieve words to remove
	    	for (int i =0; i<wordsList.size(); i++)
	    	{
	    		ftemp = wordsList.get(i);
	    		if (ftemp.exists()){
		    		enProps.load(input = new FileInputStream(ftemp.getAbsolutePath()));
				    input.close();
				    c = enProps.values();
				    cleanUpStrings.addAll(c);
	    			enProps.clear();
	    		}
	    	}

	    	// Retrieve char to remove (punctuation for ex.)
	    	for (int i =0; i<punctuationFiles.length; i++)
	    	{
	    		tempStr = propsDir.concat(File.separator).concat(punctuationFiles[i]);
	    		ftemp = new File (tempStr);
	    		if (ftemp.exists()){
		    		enProps.load(input = new FileInputStream(tempStr));
				    input.close();
				    c = enProps.values();
				    cleanUpChars.addAll(c);
			    	enProps.clear();	    		}
	    	}
	    }
	    catch (IOException e) {
	        e.printStackTrace();
	        return 1;
	    }
    	return 0;
    }

}
