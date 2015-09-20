package cz.zcu.fav.kiv.editor.template;

import java.io.IOException;
import java.io.InputStream;

import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import org.xml.sax.SAXException;
import org.xml.sax.XMLReader;

import cz.zcu.fav.kiv.editor.beans.ConfigData;
import cz.zcu.fav.kiv.editor.controller.errors.ConfigException;
import cz.zcu.fav.kiv.editor.controller.errors.FileNotFoundException;
import cz.zcu.fav.kiv.editor.controller.errors.XslParserException;
import cz.zcu.fav.kiv.editor.controller.logger.Log;

/**
 * The <code>TemplateParser</code> class contains method for parsing template files.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class TemplateParser {
    /** The parser key defining XML schema language */
    private static final String JAXP_SCHEMA_LANGUAGE = "http://java.sun.com/xml/jaxp/properties/schemaLanguage";

    /** The constants defining XML schema language */
    private static final String W3C_XML_SCHEMA = "http://www.w3.org/2001/XMLSchema";

    /** The key defining XML schema */
    private static final String JAXP_SCHEMA_SOURCE = "http://java.sun.com/xml/jaxp/properties/schemaSource";

    /** The XML parser used for reading template files */
    private XMLReader parser;

    /**
     * Initializes a newly created <code>TemplateParser</code>. Sets up the SAX parser used for
     * parsing.
     */
    public TemplateParser() {
        SAXParserFactory spf = SAXParserFactory.newInstance();
        spf.setValidating(true);
        spf.setNamespaceAware(true);

        try {
            SAXParser sp = spf.newSAXParser();
            sp.setProperty(JAXP_SCHEMA_LANGUAGE, W3C_XML_SCHEMA);
            parser = sp.getXMLReader();
            parser.setErrorHandler(new XslParserException());
        } catch (Exception ex) {
            Log.error(ex);
        }
    }

    /**
     * Parses the file with template.
     * 
     * @param configData
     *            the data containing editor data structure.
     * @param templateFile
     *            the path to the file with template.
     * @throws ConfigException
     *             if the template or its XML schema isn't well-formed.
     * @throws FileNotFoundException
     *             if the template or its XML schema doesn't exist.
     */
    public void readTemplate(ConfigData configData, String templateFile) throws ConfigException,
            FileNotFoundException {
        InputStream xsdFile = TemplateParser.class.getResourceAsStream(TemplateConst.CONF_FILE_TEMPLATE_XSD);
        if (xsdFile == null)
            throw new FileNotFoundException(TemplateConst.CONF_FILE_TEMPLATE_XSD);

        TemplateXmlHandler handler = new TemplateXmlHandler(configData, templateFile);
        parser.setContentHandler(handler);
        try {
            parser.setProperty(JAXP_SCHEMA_SOURCE, xsdFile);
            parser.parse(templateFile);
        } catch (IOException ex) {
            throw new FileNotFoundException(templateFile);
        } catch (SAXException ex) {
            throw new ConfigException(templateFile, ex.getMessage());
        }
    }

}
