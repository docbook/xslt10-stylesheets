package cz.zcu.fav.kiv.editor.config;

import java.io.IOException;
import java.io.InputStream;
import java.util.Map;

import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import org.xml.sax.SAXException;
import org.xml.sax.XMLReader;

import cz.zcu.fav.kiv.editor.beans.ConfigData;
import cz.zcu.fav.kiv.editor.beans.graphics.Figure;
import cz.zcu.fav.kiv.editor.beans.parameters.Parameter;
import cz.zcu.fav.kiv.editor.beans.properties.AttributeGroup;
import cz.zcu.fav.kiv.editor.beans.types.CommonTypes;
import cz.zcu.fav.kiv.editor.config.constants.FileConst;
import cz.zcu.fav.kiv.editor.config.handlers.AttributeXmlHandler;
import cz.zcu.fav.kiv.editor.config.handlers.ConfigXmlHandler;
import cz.zcu.fav.kiv.editor.config.handlers.FigureXmlHandler;
import cz.zcu.fav.kiv.editor.config.handlers.TypeXmlHandler;
import cz.zcu.fav.kiv.editor.controller.errors.ConfigException;
import cz.zcu.fav.kiv.editor.controller.errors.FileNotFoundException;
import cz.zcu.fav.kiv.editor.controller.errors.XslParserException;
import cz.zcu.fav.kiv.editor.controller.logger.Log;

/**
 * The <code>ConfigParser</code> class contains methods for parsing configuration files.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class ConfigParser {

    /** The parser key defining XML schema language */
    private static final String JAXP_SCHEMA_LANGUAGE = "http://java.sun.com/xml/jaxp/properties/schemaLanguage";

    /** The constants defining XML schema language */
    private static final String W3C_XML_SCHEMA = "http://www.w3.org/2001/XMLSchema";

    /** The key defining XML schema */
    private static final String JAXP_SCHEMA_SOURCE = "http://java.sun.com/xml/jaxp/properties/schemaSource";

    /** The XML parser used for reading configuration files */
    private XMLReader parser;
    
    /**
     * Initializes a newly created <code>ConfigParser</code>. Sets up the SAX parser used for
     * parsing.
     */
    public ConfigParser() {
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
     * Parses the configuration file with graphics figures - graphics.xml.
     * 
     * @param parameterList
     *            the list of loaded parameters.
     * @param figureList
     *            the list of loaded figures.                 
     * @throws ConfigException
     *             if the configuration file or its XML schema isn't well-formed.
     * @throws FileNotFoundException
     *             if the configuration file or its XML schema doesn't exist.
     */
    public void readFigures(Map<String, Parameter> parameterList, Map<String, Figure> figureList)
            throws ConfigException, FileNotFoundException {
        InputStream xsdFile = ConfigParser.class
                .getResourceAsStream(FileConst.CONF_FILE_FIGURES_XSD);
        if (xsdFile == null)
            throw new FileNotFoundException(FileConst.CONF_FILE_FIGURES_XSD);

        FigureXmlHandler handler = new FigureXmlHandler(parameterList, figureList);
        parser.setContentHandler(handler);
        try {
            parser.setProperty(JAXP_SCHEMA_SOURCE, xsdFile);
            parser.parse(FileConst.CONF_FILE_FIGURES);         
        } catch (IOException ex) {
            throw new FileNotFoundException(FileConst.CONF_FILE_FIGURES);
        } catch (SAXException ex) {
            throw new ConfigException(FileConst.CONF_FILE_FIGURES, ex.getMessage());
        }
    }

    /**
     * Parses the configuration file with attributes - attributes.xml.
     * 
     * @param commonTypes
     *            common types of parameters.
     * @return a list of loaded attributes - key is attribute name.
     * @throws ConfigException
     *             if the configuration file or its XML schema isn't well-formed.
     * @throws FileNotFoundException
     *             if the configuration file or its XML schema doesn't exist.
     */
    public AttributeGroup[] readAttributes(CommonTypes commonTypes) throws ConfigException,
            FileNotFoundException {
        InputStream xsdFile = ConfigParser.class
                .getResourceAsStream(FileConst.CONF_FILE_ATTRIBUTES_XSD);
        if (xsdFile == null)
            throw new FileNotFoundException(FileConst.CONF_FILE_ATTRIBUTES_XSD);

        AttributeXmlHandler handler = new AttributeXmlHandler(commonTypes);
        parser.setContentHandler(handler);
        try {
            parser.setProperty(JAXP_SCHEMA_SOURCE, xsdFile);
            parser.parse(FileConst.CONF_FILE_ATTRIBUTES);
            return handler.getAttrGroupList();
        } catch (IOException ex) {
            throw new FileNotFoundException(FileConst.CONF_FILE_ATTRIBUTES);
        } catch (SAXException ex) {
            throw new ConfigException(FileConst.CONF_FILE_ATTRIBUTES, ex.getMessage());
        }
    }

    /**
     * Parses the configuration file with layout of parameters and attribute-sets - config.xml.
     * 
     * @param configData
     *            so far loaded data from configuration files.
     * @param attributeGroupList
     *            the list of attribute groups.
     * @throws ConfigException
     *             if the configuration file or its XML schema isn't well-formed.
     * @throws FileNotFoundException
     *             if the configuration file or its XML schema doesn't exist.
     */
    public Map<String, Figure> readConfig(ConfigData configData, AttributeGroup[] attributeGroupList)
            throws ConfigException, FileNotFoundException {
        InputStream xsdFile = ConfigParser.class
                .getResourceAsStream(FileConst.CONF_FILE_CONFIG_XSD);
        if (xsdFile == null)
            throw new FileNotFoundException(FileConst.CONF_FILE_CONFIG_XSD);

        ConfigXmlHandler handler = new ConfigXmlHandler(attributeGroupList);
        parser.setContentHandler(handler);
        try {
            parser.setProperty(JAXP_SCHEMA_SOURCE, xsdFile);
            parser.parse(FileConst.CONF_FILE_CONFIG);
            configData.setSectionList(handler.getSections());
            configData.setPropertyList(handler.getPropertyList());
            configData.setParameterList(handler.getParameterList());
            return handler.getFigureList();
        } catch (IOException ex) {
            throw new FileNotFoundException(FileConst.CONF_FILE_CONFIG);
        } catch (SAXException ex) {
            throw new ConfigException(FileConst.CONF_FILE_CONFIG, ex.getMessage());
        }
    }

    /**
     * Parses the configuration file with types - types.xml.
     * 
     * @throws ConfigException
     *             if the configuration file or its XML schema isn't well-formed.
     * @throws FileNotFoundException
     *             if the configuration file or its XML schema doesn't exist.
     */
    public CommonTypes readTypes() throws ConfigException, FileNotFoundException {
        InputStream xsdFile = ConfigParser.class.getResourceAsStream(FileConst.CONF_FILE_TYPE_XSD);
        if (xsdFile == null)
            throw new FileNotFoundException(FileConst.CONF_FILE_TYPE_XSD);

        TypeXmlHandler handler = new TypeXmlHandler();
        parser.setContentHandler(handler);
        try {
            parser.setProperty(JAXP_SCHEMA_SOURCE, xsdFile);

            parser.parse(FileConst.CONF_FILE_TYPE);
            return new CommonTypes(handler.getUnitList(), handler.getColorList(), handler.getFontList());
        } catch (IOException ex) {
            throw new FileNotFoundException(FileConst.CONF_FILE_TYPE);
        } catch (SAXException ex) {
            throw new ConfigException(FileConst.CONF_FILE_TYPE, ex.getMessage());
        }
    }
}
