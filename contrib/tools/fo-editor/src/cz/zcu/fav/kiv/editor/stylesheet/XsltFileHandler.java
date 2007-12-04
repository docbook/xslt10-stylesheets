package cz.zcu.fav.kiv.editor.stylesheet;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Stack;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Comment;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Text;
import org.xml.sax.Attributes;
import org.xml.sax.ContentHandler;
import org.xml.sax.DTDHandler;
import org.xml.sax.Locator;
import org.xml.sax.SAXException;
import org.xml.sax.ext.DeclHandler;

import org.xml.sax.ext.LexicalHandler;
import org.xml.sax.helpers.DefaultHandler;

import cz.zcu.fav.kiv.editor.beans.ConfigData;
import cz.zcu.fav.kiv.editor.beans.properties.Property;
import cz.zcu.fav.kiv.editor.config.constants.TagDefinition;
import cz.zcu.fav.kiv.editor.controller.resource.ResourceController;

/**
 * The <code>XsltFileHandler</code> class reads the input XSL stylesheet file element by element and creates from them a DOM structure.
 * Simultaneously reports all errros in the input XSL file.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class XsltFileHandler extends DefaultHandler implements ContentHandler, LexicalHandler,
        DeclHandler, DTDHandler {
    private ConfigData data;

    // locator
    private Locator locator;

    private Document document;

    private Element element = null;

    private Element stylesheet;

    private Comment comment;

    private Stack<Element> stack;

    private int parameterBeginLine;

    private int attributeBeginLine;

    private Property property;

    private Map<String, String> namespaces;
    
    private boolean insideCDATA;

    // string buffers
    private StringBuffer commentBuffer = new StringBuffer(TagDefinition.BUFFER_SIZE);

    private StringBuffer elementBuffer = new StringBuffer(TagDefinition.BUFFER_SIZE);
    
    private StringBuffer cdataBuffer = new StringBuffer(TagDefinition.BUFFER_SIZE);

    public XsltFileHandler(ConfigData data) {
        super();
        this.data = data;
    }

    public void startDocument() {
        try {
            DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
            DocumentBuilder builder = dbf.newDocumentBuilder();

            document = builder.newDocument();
            stylesheet = document.createElement(XslTagConst.STYLESHEET);
        } catch (Exception ex) {

        }
        stack = new Stack<Element>();
        namespaces = new HashMap<String, String>();
    }

    public void startElement(String namespaceURI, String localName, String qName, Attributes atts)
            throws SAXException {
        if (qName.equals(XslTagConst.STYLESHEET)) {
            //attributes
            if (atts.getLength() > 0)
                appendAttributes(stylesheet, atts);
            
            // namespaces
            if (namespaces.size() > 0) {
                appendNamespaces(stylesheet);
            }

            document.appendChild(stylesheet);
            stack.push(stylesheet);
        } else {
            if (stack.empty())
                throw new SAXException(ResourceController
                        .getMessage("open_file.stylesheet_invalid"));
            element = document.createElement(qName);
            //attributes
            if (atts.getLength() > 0)
                appendAttributes(element, atts);
            
            // namespaces
            if (namespaces.size() > 0) 
                appendNamespaces(element);
            
            stack.peek().appendChild(element);
            stack.push(element);
        }

        if (qName.equals(XslTagConst.PARAM)) {
            parameterBeginLine = locator.getLineNumber();
        } else if (qName.equals(XslTagConst.ATTRIBUTE)) {
            attributeBeginLine = locator.getLineNumber();
        } else if ((qName.equals(XslTagConst.ATTRIBUTE_SET))
                && (stack.peek().getParentNode().getNodeName().equals(XslTagConst.STYLESHEET))) {
            property = OpenFileHadler
                    .parserPropertyTag(stack.peek(), locator.getLineNumber(), data);
        }

        elementBuffer.setLength(0);
    }

    private void appendNamespaces(Element node) {
        for (Iterator it = namespaces.entrySet().iterator(); it.hasNext();) {
            Map.Entry entry = (Map.Entry) it.next();
            if (entry.getKey().toString().length() > 0)
                node.setAttributeNS("http://www.w3.org/2000/xmlns/", "xmlns:"
                        + entry.getKey().toString(), entry.getValue().toString());
            else
                node.setAttributeNS("http://www.w3.org/2000/xmlns/", "xmlns", entry.getValue()
                        .toString());
        }
        namespaces = new HashMap<String, String>();
    }
    
    private void appendAttributes(Element node, Attributes atts) {
        for (int i = 0; i < atts.getLength(); i++) {
            node.setAttribute(atts.getQName(i), atts.getValue(i));
        }
    }

    public void endElement(String namespaceURI, String localName, String qName) {
        if (elementBuffer.length() > 0) {
            if (elementBuffer.toString().trim().length() > 0) {
                Text text = document.createTextNode(elementBuffer.toString().trim());
                stack.peek().appendChild(text);
            }
            elementBuffer.setLength(0);
        }

        if (qName.equals(XslTagConst.PARAM)
                && (stack.peek().getParentNode().getNodeName().equals(XslTagConst.STYLESHEET))) {
            OpenFileHadler.parserParameterTag(stack.peek(), parameterBeginLine, data);
        } else if (qName.equals(XslTagConst.ATTRIBUTE_SET)) {
            property = null;
        } else if ((qName.equals(XslTagConst.ATTRIBUTE)) && (property != null)) {
            OpenFileHadler.parserPropertyAttribute(stack.peek(), attributeBeginLine, property);
        }

        stack.pop();
    }

    public void characters(char[] ch, int start, int length) {
        if (insideCDATA)
            cdataBuffer.append(ch, start, length);
        else
            elementBuffer.append(ch, start, length);
    }

    public void startPrefixMapping(String prefix, String uri) throws SAXException {
        namespaces.put(prefix, uri);
    }

    public void setDocumentLocator(Locator locator) {
        this.locator = locator;
    }

    public void comment(char[] ch, int start, int length) throws SAXException {
        commentBuffer.append(ch, start, length);
        comment = document.createComment(commentBuffer.toString());
        if (!stack.empty())
            stack.peek().appendChild(comment);
        else
            document.appendChild(comment);
        commentBuffer.setLength(0);
    }

    public void endCDATA() throws SAXException {
        insideCDATA = false;
        stack.peek().appendChild(document.createCDATASection(cdataBuffer.toString()));
        cdataBuffer.setLength(0);
    }

    public void endDTD() throws SAXException {
    }

    public void endEntity(String name) throws SAXException {
    }

    public void startCDATA() throws SAXException {
        insideCDATA = true;
    }

    public void startDTD(String name, String publicId, String systemId) throws SAXException {
    }

    public void startEntity(String name) throws SAXException {
    }

    public Document getDocument() {
        return document;
    }

    public void attributeDecl(String arg0, String arg1, String arg2, String arg3, String arg4)
            throws SAXException {
    }

    public void elementDecl(String arg0, String arg1) throws SAXException {
    }

    public void externalEntityDecl(String arg0, String arg1, String arg2) throws SAXException {
    }

    public void internalEntityDecl(String arg0, String arg1) throws SAXException {
    }

}
