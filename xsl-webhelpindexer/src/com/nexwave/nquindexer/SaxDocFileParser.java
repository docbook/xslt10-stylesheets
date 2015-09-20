package com.nexwave.nquindexer;


import java.io.*;
import java.util.Stack;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.nexwave.nsidita.BlankRemover;
import com.nexwave.nsidita.DocFileInfo;
import org.xml.sax.InputSource;
import org.xml.sax.SAXParseException;

/**
 * Generic parser for populating a DocFileInfo object.
 *
 * @author N. Quaine
 * @author Kasun Gajasinghe
 * @version 2.0 2010-08-14
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

    // OXYGEN PATCH. Keep the stack of elements
    Stack<String> stack = new Stack<String>();
    //methods

    /**
     * Constructor
     */
    public SaxDocFileParser() {

    }

    /**
     * Initializer
     */
    public int init(String inputDir) {
        return 0;
    }

    /**
     * Parses the file to extract all the words for indexing and
     * some data characterizing the file.
     *
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

    public void parseDocument(File file) {
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
//            sp.getXMLReader().setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd", false);
//          this feature isn't supported in TagSoup  

            //parse the file and also register this class for call backs
            //System.out.println("Parsing: " + file);

            long start = System.currentTimeMillis();
            //System.out.println("about to parse " + file.getName() + " >>> " + start);

            String content = RemoveValidationPI(file);
            if (content != null) {
                InputSource is = new InputSource(new StringReader(content));
                is.setSystemId(file.toURI().toURL().toString());
                sp.parse(is, this);
            }

            long finish = System.currentTimeMillis();
            //System.out.println("done parsing " + file.getName() + " >>> " + finish);
            //System.out.println("time = " + (finish - start) + " milliseconds");

        } catch (SAXParseException spe) {
            System.out.println("SaxParseException: The indexing file contains incorrect xml syntax.");
            spe.printStackTrace();
        } catch (org.xml.sax.SAXException se) {
            System.out.println("SaxException. You may need to include Xerces in your classpath. " +
                    "See documentation for details");
            se.printStackTrace();
        } catch (javax.xml.parsers.ParserConfigurationException pce) {
            pce.printStackTrace();
        } catch (IOException ie) {
            ie.printStackTrace();
        }
    }

    private boolean addContent = false;
    private boolean addHeaderInfo = false;
    private boolean doNotIndex = false;
    private int divCount = 0;
    //SAX parser Event Handlers:

    public void startElement(String uri, String localName, String qName, org.xml.sax.Attributes attributes) throws org.xml.sax.SAXException {

        //dwc: capture current element name
        // START OXYGEN PATCH, add current element in stack
        stack.add(qName);
        // END OXYGEN PATCH
        currentElName = qName;

        // dwc: Adding contents of some meta tags to the index
        if ((qName.equalsIgnoreCase("meta"))) {
            addHeaderInfo = true;
            String attrName = attributes.getValue("name");
            // OXYGEN PATCH START EXM-20576 - add scoring for keywords
            if (attrName != null && (attrName.equalsIgnoreCase("keywords")
                    || attrName.equalsIgnoreCase("description")
                    || attrName.equalsIgnoreCase("indexterms")
            )) {
                if (attrName.equalsIgnoreCase("keywords")) {
                    String[] keywords = attributes.getValue("content").split(", ");
                    for (String keyword : keywords) {
                        strbf.append(" ").append(keyword).append("@@@elem_meta_keywords@@@ ");
                    }
                } else if (attrName.equalsIgnoreCase("indexterms")) {
                    String[] indexterms = attributes.getValue("content").split(", ");
                    for (String indexterm : indexterms) {
                        strbf.append(" ").append(indexterm).append("@@@elem_meta_indexterms@@@ ");
                    }
                } else {
                    strbf.append(" ").append(attributes.getValue("content")).append(" ");
                }
            }
            // OXYGEN PATCH END EXM-20576 - add scoring for indexterms
            // dwc: adding this to make the docbook <abstract> element
            // (which becomes <meta name="description".../> in html)
            // into the brief description that shows up in search
            // results.
            if (attrName != null && (attrName.equalsIgnoreCase("description"))) {
                fileDesc.setShortdesc(BlankRemover.rmWhiteSpace(attributes.getValue("content").replace('\n', ' ')));
            }
            
            if (attrName != null && (attrName.equalsIgnoreCase("Section-Title"))) {
                fileDesc.setTitle(BlankRemover.rmWhiteSpace(attributes.getValue("content").replace('\n', ' ')));
            }
        } // dwc: End addition

        // dwc: commenting out DITA specific lines
        if ((qName.equalsIgnoreCase("title")) || (qName.equalsIgnoreCase("shortdesc"))) {
            tempVal = new StringBuffer();
        }

        addHeaderInfo = qName.equalsIgnoreCase("meta") || qName.equalsIgnoreCase("title") || qName.equalsIgnoreCase("shortdesc");

        String elementId = attributes.getValue("id");
        if ("content".equals(elementId)) addContent = true;

        if (addContent) {
            //counts div tags starting from "content" div(inclusive). This will be used to track the end of content "div" tag.
            //see #endElement()
            if (qName.equalsIgnoreCase("div")) {
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
            doNotIndex = accessKey != null && ("n".equals(accessKey) || "p".equals(accessKey) || "h".equals(accessKey));
        }
        strbf.append(" ");
    }

    //triggers when there's character data inside an element.

    public void characters(char[] ch, int start, int length) throws org.xml.sax.SAXException {

        // index certain elements. E.g. Use this to implement a
        // "titles only" index,

        //OXYGEN PATCH, gather more keywords.
        if (
	    (addContent || addHeaderInfo) &&  // DWC: Oxygen Patch had this line commented out but we need it for DocBook to keep toc from being indexed.
                !doNotIndex && !currentElName.equalsIgnoreCase("script")) {
            String text = new String(ch, start, length);
            // START OXYGEN PATCH, append a marker after each word
            // The marker is used to compute the scoring
            // Create the marker
            String originalText = text.replaceAll("\\s+", " ");
            text = text.trim();
            // Do a minimal clean
            text = minimalClean(text, null, null);
            text = text.replaceAll("\\s+", " ");
            String marker = "@@@elem_" + stack.peek() + "@@@ ";
            Matcher m = Pattern.compile("(\\w|-|:)+").matcher(text);
            if (text.trim().length() > 0 && m.find()) {
                String copyText = new String(originalText);
                text = duplicateWords(copyText, text, "-");
                copyText = new String(originalText);
                text = duplicateWords(copyText, text, ":");
                copyText = new String(originalText);
                text = duplicateWords(copyText, text, ".");
                // Replace whitespace with the marker
                text = text.replace(" ", marker);
                text = text + marker;
            }
            // END OXYGEN PATCH
            strbf.append(text);
//			System.out.println("=== marked text: " + text);
            // START OXYGEN PATCH, append the original text
            if (tempVal != null) {
                tempVal.append(originalText);
            }
            // END OXYGEN PATCH
        }
    }

    // START OXYGEN PATCH EXM-20414

    private String duplicateWords(String sourceText, String acumulator, String separator) {
//	    System.out.println("sourceText: " + sourceText + "   separator: " + separator);
        int index = sourceText.indexOf(separator);
        while (index >= 0) {
            int indexSpaceAfter = sourceText.indexOf(" ", index);
            String substring = null;
            if (indexSpaceAfter >= 0) {
                substring = sourceText.substring(0, indexSpaceAfter);
                sourceText = sourceText.substring(indexSpaceAfter);
            } else {
                substring = sourceText;
                sourceText = "";
            }

            int indexSpaceBefore = substring.lastIndexOf(" ");
            if (indexSpaceBefore >= 0) {
                substring = substring.substring(indexSpaceBefore + 1);
            }
            if (separator.indexOf(".") >= 0) {
                separator = separator.replaceAll("\\.", "\\\\.");
//		    System.out.println("++++++++++ separator: " + separator);
            }
            String[] tokens = substring.split(separator);

            for (String token : tokens) {
                acumulator = acumulator + " " + token;
//		    System.out.println("added token: " + tokens[i] + "  new text: " + acumulator);
            }

            index = sourceText.indexOf(separator);
        }

        return acumulator;
    }
    // END OXYGEN PATCH EXM-20414

    public void endElement(String uri, String localName, String qName) throws org.xml.sax.SAXException {
        // START OXYGEN PATCH, remove element from stack
        stack.pop();
        // END OXYGEN PATCH
        /*if (qName.equalsIgnoreCase("title")) {
            //add it to the list
            //myEmpls.add(tempEmp);
            fileDesc.setTitle(BlankRemover.rmWhiteSpace(tempVal.toString()));
            tempVal = null;
        }*/ if (shortdescBool) {
            shortTagCpt--;
            if (shortTagCpt == 0) {
                String shortdesc = tempVal.toString().replace('\n', ' ');
                if (shortdesc.trim().length() > 0) {
                    fileDesc.setShortdesc(BlankRemover.rmWhiteSpace(shortdesc));
                }
                tempVal = null;
                shortdescBool = false;
            }
        }

        if (qName.equalsIgnoreCase("div") && addContent) {
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
     *
     * @param file the html file
     * @return int: returns 0 if no IOException occurs, else 1.
     */
    public String RemoveValidationPI(File file) {
        StringBuilder sb = new StringBuilder();
        //The content that needs to be indexed after removing validation will be written to sb. This StringBuilder will
        //  be the source to index the content of the particular html page.
        try {
            BufferedReader br = new BufferedReader(
                    new InputStreamReader(
                            new FileInputStream(file), "UTF-8"));

            while (true) {
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
                            line = line.replaceAll("\\x3C\\x3Fxml[^\\x3E]*\\x3F\\x3E", "\n");
                        }

                        sb.append(line).append("\n");
                    } else {
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
                            line = line.replaceAll("\\x3C\\x3Fxml[^\\x3E]*\\x3F\\x3E", "\n");
                        }
                        line = line.replaceAll("\\x3C\\x21DOCTYPE[^\\x3E]*\\x3E", "\n");

                        sb.append(line);
                    }
                }
                catch (IOException e) {
                    break;
                }
            }

            br.close();
        }
        catch (IOException e) {
            return null;
        }

        return sb.toString(); // return status

    }

    // START OXYGEN PATCH, moved from subclass

    protected String minimalClean(String str, StringBuffer tempStrBuf, StringBuffer tempCharBuf) {
        String tempPunctuation = null;
        if (tempCharBuf != null) {
            tempPunctuation = new String(tempCharBuf);
        }

        str = str.replaceAll("\\s+", " ");
        str = str.replaceAll("->", " ");
        str = str.replaceAll(IndexerConstants.EUPUNCTUATION1, " ");
        str = str.replaceAll(IndexerConstants.EUPUNCTUATION2, " ");
        str = str.replaceAll(IndexerConstants.JPPUNCTUATION1, " ");
        str = str.replaceAll(IndexerConstants.JPPUNCTUATION2, " ");
        str = str.replaceAll(IndexerConstants.JPPUNCTUATION3, " ");
        if (tempPunctuation != null && tempPunctuation.length() > 0) {
            str = str.replaceAll(tempPunctuation, " ");
        }

        if (tempStrBuf != null) {
            //remove useless words
            str = str.replaceAll(tempStrBuf.toString(), " ");
        }

        // Redo punctuation after removing some words: (TODO: useful?)
        str = str.replaceAll(IndexerConstants.EUPUNCTUATION1, " ");
        str = str.replaceAll(IndexerConstants.EUPUNCTUATION2, " ");
        str = str.replaceAll(IndexerConstants.JPPUNCTUATION1, " ");
        str = str.replaceAll(IndexerConstants.JPPUNCTUATION2, " ");
        str = str.replaceAll(IndexerConstants.JPPUNCTUATION3, " ");
        if (tempPunctuation != null && tempPunctuation.length() > 0) {
            str = str.replaceAll(tempPunctuation, " ");
        }
        return str;
    }
    // END OXYGEN PATCH
}
