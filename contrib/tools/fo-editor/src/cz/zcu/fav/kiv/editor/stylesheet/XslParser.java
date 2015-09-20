package cz.zcu.fav.kiv.editor.stylesheet;

import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.DOMImplementation;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.traversal.DocumentTraversal;
import org.w3c.dom.traversal.NodeFilter;
import org.w3c.dom.traversal.NodeIterator;
import org.xml.sax.SAXException;
import org.xml.sax.XMLReader;

import cz.zcu.fav.kiv.editor.beans.ConfigData;
import cz.zcu.fav.kiv.editor.controller.errors.OpenFileException;
import cz.zcu.fav.kiv.editor.controller.errors.SaveFileException;
import cz.zcu.fav.kiv.editor.controller.errors.XslParserException;
import cz.zcu.fav.kiv.editor.controller.logger.Log;
import cz.zcu.fav.kiv.editor.controller.options.OptionItems;

/**
 * The <code>XslParser</code> class contains methods for reading and saving XSL stylesheet files.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class XslParser {

    /** The size of indent used in output XSL files */
    public static final int INDENT = 2;

    /**
     * Opens and reads the input XSL file. Creates a DOM structure of the opened XSL document.
     * 
     * @param file
     *            the name of the XSL file that will be opened.
     * @param configData
     *            the data containing editor data structure.
     * @return DOM structure of the opened XSL document.
     * @throws OpenFileException
     *             if the file cannot be opened.
     */
    public static Document readXsltFile(String file, ConfigData configData)
            throws OpenFileException {
        Document doc = null;
        try {
            SAXParserFactory spf = SAXParserFactory.newInstance();
            spf.setValidating(false);
            spf.setNamespaceAware(true);

            SAXParser sp = spf.newSAXParser();
            XMLReader parser = sp.getXMLReader();
            parser.setErrorHandler(new XslParserException());

            XsltFileHandler handler = new XsltFileHandler(configData);
            parser.setContentHandler(handler);
            parser.setProperty("http://xml.org/sax/properties/lexical-handler", handler);
            parser.setProperty("http://xml.org/sax/properties/declaration-handler", handler);

            parser.parse(file);

            doc = handler.getDocument();
        } catch (SAXException ex) {
            Log.error(ex);
            throw new OpenFileException(ex.getMessage());
        } catch (Exception ex) {
            Log.error(ex);
            throw new OpenFileException();
        }
        return doc;
    }

    /**
     * Saves changes of actually opened XSL stylesheet file and saves the DOM structure to the XSL file.
     * 
     * @param file
     *            the name of the XSL file that will be saved.
     * @param document
     *            the DOM structure of the file that will be saved.
     * @throws SaveFileException
     *             if the file cannot be saved.
     */
    public static void saveXsltFile(String file, Document document, ConfigData configData) throws SaveFileException {
        SaveFileHandler.saveStylesheet(document, configData);
        try {
            TransformerFactory tf = TransformerFactory.newInstance();
            tf.setAttribute("indent-number", INDENT);
            Transformer writer = tf.newTransformer();
            writer.setOutputProperty(OutputKeys.INDENT, "yes");
            writer.setOutputProperty("encoding", OptionItems.ENCODING);

            writer.setOutputProperty(OutputKeys.METHOD, "xml");

            OutputStreamWriter osw = new OutputStreamWriter(new FileStreamOutput(
                    new FileOutputStream(new File(file))), Charset.forName(OptionItems.ENCODING));

            writer.transform(new DOMSource(document), new StreamResult(osw));
        } catch (Exception ex) {
            Log.error(ex);
            throw new SaveFileException(ex);
        }
    }

    /**
     * Creates a new DOM structure of an empty XSL stylesheet.
     * 
     * @return a DOM structure of an empty XSL stylesheet.
     */
    public static Document createXsltFile() {
        Document doc = null;
        try {
            DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
            DocumentBuilder builder = dbf.newDocumentBuilder();
            DOMImplementation impl = builder.getDOMImplementation();
            doc = impl.createDocument(OptionItems.XSL_NAMESPACE, "xsl:stylesheet", null);
            // XSL namespace
            Element element = doc.getDocumentElement();
            element.setAttribute("xmlns:xsl", OptionItems.XSL_NAMESPACE);
            // FO namespace
            if (OptionItems.ADD_FO_NAMESPACE)
                element.setAttribute("xmlns:fo", OptionItems.FO_NAMESPACE);
            element.setAttribute("version", OptionItems.STYLESHEET_VERSION);

            // add imports
            addImportFiles(doc);
        } catch (ParserConfigurationException ex) {
            Log.error(ex);
        }
        return doc;
    }

    /**
     * Adds to the DOM structure elements defining import of other XSL stylesheets.
     * 
     * @param document
     *            the DOM structure of the XSL stylesheet.
     */
    private static void addImportFiles(Document document) {
        Element importElem;
        int lastChar = 0;
        Pattern pattern = Pattern.compile(";");
        Matcher matcher = pattern.matcher(OptionItems.IMPORT_FILE);
        while (matcher.find()) {
            importElem = document.createElement("xsl:import");
            importElem.setAttribute("href", OptionItems.IMPORT_FILE.substring(lastChar,
                    matcher.start()).trim());
            lastChar = matcher.end();
            document.getDocumentElement().appendChild(importElem);
        }
        if (lastChar < OptionItems.IMPORT_FILE.trim().length()) {
            importElem = document.createElement("xsl:import");
            importElem.setAttribute("href", OptionItems.IMPORT_FILE.substring(lastChar,
                    OptionItems.IMPORT_FILE.trim().length()));
            document.getDocumentElement().appendChild(importElem);
        }
    }

    /**
     * Removes all comments in DOM structure of the XSL stylesheet.
     * 
     * @param document
     *            the DOM structure of the XSL stylesheet.
     */
    public static void removeComments(Document document) {
        NodeIterator nodeList = ((DocumentTraversal) document).createNodeIterator(document
                .getDocumentElement(), NodeFilter.SHOW_COMMENT, null, false);
        Node comment;
        List<Node> commentList = new ArrayList<Node>();
        while ((comment = nodeList.nextNode()) != null)
            commentList.add(comment);
        removeNodes(commentList);
    }

    /**
     * Removes all nodes from the list.
     * 
     * @param nodeList
     *            the list of nodes that will be removed.
     */
    public static void removeNodes(List<Node> nodeList) {
        for (Node node : nodeList) {
            removeNode(node);
        }
    }

    /**
     * Remove the input node.
     * 
     * @param node
     *            the node that will be removed.
     */
    public static void removeNode(Node node) {
        node.getParentNode().removeChild(node);
    }
}
