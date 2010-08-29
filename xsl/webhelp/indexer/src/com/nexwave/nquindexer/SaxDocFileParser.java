package com.nexwave.nquindexer;


import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;

import com.nexwave.nsidita.BlankRemover;
import com.nexwave.nsidita.DocFileInfo;
import org.xml.sax.SAXParseException;

/**
 * Generic parser for populating a DocFileInfo object.
 * 
 * @version 2.0 2010-08-14
 * 
 * @author N. Quaine
 * @author Kasun Gajasinghe
 */
public class SaxDocFileParser extends org.xml.sax.helpers.DefaultHandler {
	
	//members
	protected DocFileInfo fileDesc = null;
	protected String projectDir = null;
	protected StringBuffer strbf = null;
	private String currentElName = "";
	private StringBuffer tempVal = null;
	private boolean shortdescBool = false;
	private int shortTagCpt = 0;

	//methods
	/**
	 * Constructor
	 */
	public SaxDocFileParser () {

	}
	
	/**
	 * Initializer
	 */
	public int init(String inputDir){
		return 0;
	}

	/**
	 * Parses the file to extract all the words for indexing and 
	 * some data characterizing the file. 
	 * @param file contains the fullpath of the document to parse  
	 * @return a DitaFileInfo object filled with data describing the file
	 */
	public DocFileInfo runExtractData(File file) {
		//initialization
		fileDesc = new DocFileInfo(file);
		strbf = new StringBuffer("");
		
		// Fill strbf by parsing the file
		parseDocument(file);

		return fileDesc;
	}

	public void parseDocument (File file) {
//        System.out.println(System.getProperty("org.xml.sax.driver"));
//        System.out.println(System.getProperty("javax.xml.parsers.SAXParserFactory"));
        
		//get a factory
		javax.xml.parsers.SAXParserFactory spf = javax.xml.parsers.SAXParserFactory.newInstance();

		spf.setValidating(false);
        addContent = false;
		divCount = 0;
		try {
			//get a new instance of parser
			javax.xml.parsers.SAXParser sp = spf.newSAXParser();
			// deactivate the validation
			sp.getXMLReader().setFeature("http://xml.org/sax/features/external-general-entities", false);
			sp.getXMLReader().setFeature( "http://apache.org/xml/features/nonvalidating/load-external-dtd",	false);

            //parse the file and also register this class for call backs
			System.out.println("Parsing: " + file);
			
			long start = System.currentTimeMillis();
			//System.out.println("about to parse " + file.getName() + " >>> " + start);

			if ( RemoveValidationPI (file) == 0){
			    sp.parse("xx.html", this);
			}
			
			long finish = System.currentTimeMillis();
			//System.out.println("done parsing " + file.getName() + " >>> " + finish);
			//System.out.println("time = " + (finish - start) + " milliseconds");
			
		}catch(SAXParseException spe){
            System.out.println("SaxParseException: The indexing file contains incorrect xml syntax.");
            spe.printStackTrace();
        }catch(org.xml.sax.SAXException se) {
			System.out.println("SaxException. You may need to include Xerces in your classpath. " +
                    "See documentation for details");
			se.printStackTrace(); 
		}catch(javax.xml.parsers.ParserConfigurationException pce) {
			pce.printStackTrace();
		}catch (IOException ie) {
			ie.printStackTrace();
		}
	}
    
    private boolean addContent = false;
    private boolean addHeaderInfo = false;
    private boolean doNotIndex=false;
    private int divCount = 0;
	//SAX parser Event Handlers:
	public void startElement(String uri, String localName, String qName, org.xml.sax.Attributes attributes) throws org.xml.sax.SAXException {

		//dwc: capture current element name
		currentElName = qName;

		// dwc: Adding contents of some meta tags to the index
		if((qName.equalsIgnoreCase("meta")) ) {
            addHeaderInfo = true;
			String attrName = attributes.getValue("name");
			if(attrName != null && (attrName.equalsIgnoreCase("keywords") || attrName.equalsIgnoreCase("description"))){
				strbf.append(" " + attributes.getValue("content") + " ");
			}
			// dwc: adding this to make the docbook <abstract> element
			// (which becomes <meta name="description".../> in html)
			// into the brief description that shows up in search
			// results.
			if(attrName != null && (attrName.equalsIgnoreCase("description"))){
				fileDesc.setShortdesc(BlankRemover.rmWhiteSpace(attributes.getValue("content").replace('\n', ' ')));
			}
		} // dwc: End addition

        // dwc: commenting out DITA specific lines
		if((qName.equalsIgnoreCase("title")) || (qName.equalsIgnoreCase("shortdesc"))) {
			tempVal = new StringBuffer();
		}

        if(qName.equalsIgnoreCase("meta") || qName.equalsIgnoreCase("title") || qName.equalsIgnoreCase("shortdesc")){
            addHeaderInfo = true;
        } else {
            addHeaderInfo = false;
        }

        String elementId = attributes.getValue("id"); 
        if("content".equals(elementId)) addContent = true;

        if(addContent) {
            //counts div tags starting from "content" div(inclusive). This will be used to track the end of content "div" tag.
            //see #endElement()
            if(qName.equalsIgnoreCase("div")){
                divCount++;
            }

            // dwc: Adding mechansim to grab <p class="summary"> etc. Powered by para.propagates.style etc.
            if (qName.equalsIgnoreCase("div") || qName.equalsIgnoreCase("p") || qName.equalsIgnoreCase("span")) {
                String stemp = attributes.getValue("class");
                if (stemp != null && (stemp.equalsIgnoreCase("shortdesc") || stemp.equalsIgnoreCase("summary"))) {
                    shortdescBool = true;
                }
                tempVal = new StringBuffer();
                strbf.append(" ");
            }
            if (shortdescBool) {
                shortTagCpt++;
            }

            String accessKey = attributes.getValue("accesskey");
            if(accessKey!=null && ("n".equals(accessKey) || "p".equals(accessKey) || "h".equals(accessKey))){
                doNotIndex = true;
            } else {
                doNotIndex = false;
            }
        }
		strbf.append(" ");
	}

	//triggers when there's character data inside an element.
	public void characters(char[] ch, int start, int length) throws org.xml.sax.SAXException {
		
		// dwc: Bug fix. Don't index contents of script tag.
		// dwc: TODO: Add code here to conditionally index or not
		// index certain elements. E.g. Use this to implement a
		// "titles only" index, say if you wanted to use <span/>s to
		// create space breaks in ja_JP lines to indicate word breaks.
        
		if((addContent || addHeaderInfo) && !doNotIndex && !currentElName.equalsIgnoreCase("script")){
			String text = new String(ch,start,length);
			strbf.append(text);
			if (tempVal != null) { tempVal.append(text);}
		}
	}
	
	public void endElement(String uri, String localName, String qName) throws org.xml.sax.SAXException {
		if(qName.equalsIgnoreCase("title")) {
			//add it to the list
			//myEmpls.add(tempEmp);
			fileDesc.setTitle(BlankRemover.rmWhiteSpace(tempVal.toString()));
			tempVal = null;
		}
		else if (shortdescBool) {
			shortTagCpt --;
			if (shortTagCpt == 0) {
			fileDesc.setShortdesc(BlankRemover.rmWhiteSpace(tempVal.toString().replace('\n', ' ')));
			tempVal = null;
			shortdescBool = false;
			}
		}
        
        if(qName.equalsIgnoreCase("div") && addContent){
            divCount--;
            if (divCount == 0) {
                addContent = false;
            }
        } 
	}
	
	public void processingInstruction(String target, String data) throws org.xml.sax.SAXException {
		//do nothing
		
	}
	
	/*public InputSource resolveEntity(String publicId, String systemId) 
		throws IOException, SAXException {
		
		// use the catalog to solve the doctype
		System.out.println("entities " + publicId + systemId);
		return null;
	}*/
	public org.xml.sax.InputSource resolveEntity(String publicId, String systemId)
	throws org.xml.sax.SAXException, IOException {
		//System.out.println("Entities " + publicId + "and" + systemId);
		// use dita ot (dost.jar) for resolving dtd paths using the calatog
		
	return null;
	}

    /**
     * Removes the validation in html files, such as xml version and DTDs  
     * @param file
     * @return int: returns 0 if no IOException occurs, else 1.
     */
	public int RemoveValidationPI (File file) {
		
		try {
			BufferedReader br = new BufferedReader(
	                new InputStreamReader(
	                 new FileInputStream(file),"UTF-8"));
			
			//PrintWriter pw = new PrintWriter(new FileOutputStream(new File("xx.html")));
			PrintWriter pw = new PrintWriter(new  OutputStreamWriter (new FileOutputStream(new File("xx.html")),"UTF-8"));
			 //writes the content to xx.html after removing validation. This temp file will be source to index the
            // content of the particular html page.

			while(true)
			{
				int i1, i2;
				boolean ok = true;
				try {
	
					String line = br.readLine();
	
			        
					if (line == null) {
						break;
					}
					//ok = line.matches("(.)*\\x26nbsp\\x3B(.)*");
					
					line = line.replaceAll("\\x26nbsp\\x3B", "&#160;");
	
					if (!line.contains("<!DOCTYPE html PUBLIC")) {
						//dwc: This doesn't really apply to me. I already omit the xml pi for other reasons.
						if (line.contains("<?xml version")) {
							line = line.replaceAll("\\x3C\\x3Fxml[^\\x3E]*\\x3F\\x3E","\n");
						}
						pw.write(line + "\n");
					} else  
					{
						//dwc: What is this trying to do? Nuke the DOCTYPE? Why?
						i1 = line.indexOf("<!DOCTYPE");
						i2 = line.indexOf(">", i1);
						while (i2 < 0) {
							
							line = line.concat(br.readLine());
							i2 = line.indexOf(">", i1);
						}
						String temp = line.substring(i1, i2);
						
						//ok = line.matches("(.)*\\x3C\\x21DOCTYPE[^\\x3E]*\\x3E(.)*");
						if (line.contains("<?xml version")) {
							line = line.replaceAll("\\x3C\\x3Fxml[^\\x3E]*\\x3F\\x3E","\n");
						}
						line = line.replaceAll("\\x3C\\x21DOCTYPE[^\\x3E]*\\x3E","\n");
						pw.write(line);
					}
				}
				catch (IOException e)
				{
					break;
				}
			}
	
			
			pw.flush();
			pw.close();
			br.close();
		}
		catch (IOException e)
		{
			return 1;
		}
		
		return 0; // return status

	}

}
