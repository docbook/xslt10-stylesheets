package cz.zcu.fav.kiv.editor.config;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import org.xml.sax.SAXException;
import org.xml.sax.XMLReader;

import cz.zcu.fav.kiv.editor.beans.properties.Attribute;
import cz.zcu.fav.kiv.editor.beans.properties.Property;
import cz.zcu.fav.kiv.editor.config.handlers.PropertyXmlHandler;
import cz.zcu.fav.kiv.editor.controller.MessageWriter;
import cz.zcu.fav.kiv.editor.controller.ProgressControl;
import cz.zcu.fav.kiv.editor.controller.errors.XslParserException;
import cz.zcu.fav.kiv.editor.controller.logger.Log;
import cz.zcu.fav.kiv.editor.controller.options.OptionItems;
import cz.zcu.fav.kiv.editor.controller.resource.ResourceController;

/**
 * The <code>PropertyParser</code> class contains methods for parsing files with XML definitions
 * of properties.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class PropertyParser {
    /** The XML parser used for reading XML files */
    private XMLReader parser;
    
    /** The list of parsed properties */
    private Map<String, Property> parsedPropertyList;
    
    /** The list of unparsed attributes */
    private Map<String, Attribute> unparsedAttributeList;

    /**
     * Initializes a newly created <code>PropertyParser</code>. Sets up the SAX parser used for
     * parsing.
     */
    public PropertyParser() {
        try {
            SAXParserFactory spf = SAXParserFactory.newInstance();
            spf.setValidating(false);

            SAXParser saxParser = spf.newSAXParser();
            parser = saxParser.getXMLReader();
            parser.setErrorHandler(new XslParserException());
           
            unparsedAttributeList = new HashMap<String, Attribute>();
            parsedPropertyList = new HashMap<String, Property>();
        } catch (Exception ex) {
            Log.error(ex);
        }
    }

    /**
     * In sequence parses for every property its XML definition file.
     * 
     * @param propertyList
     *            the list of property names loaded from the main configuration file.
     */
    public void readPropertyDefinition(Map<String, Property> propertyList) {
        Iterator<Map.Entry<String, Property>> iter = propertyList.entrySet().iterator();
        while (iter.hasNext()) {
            Map.Entry<String, Property> prop = iter.next();
            parseProperty(prop.getValue());
        }   
    }

    /**
     * For input property parses its XML definition file.
     * 
     * @param element
     *            the property which XML file is parsed.
     */
    private void parseProperty(Property element) {
        try {
            PropertyXmlHandler handler = new PropertyXmlHandler(element);
            parser.setContentHandler(handler);
            parser.parse(OptionItems.XML_DEFINITION_PATH + File.separator + element.getName()
                    + ".xml");
            if (handler.isValid()) {
                parsedPropertyList.put(element.getName(), element);
                ProgressControl.addStatMessage(ResourceController.getMessage("frame.intro.progress.read_file", OptionItems.XML_DEFINITION_PATH + File.separator + element.getName()+".xml"));
            }
            //unparsed attributes
            if (handler.getUnparsedAttributeList().size() > 0)
                unparsedAttributeList.putAll(handler.getUnparsedAttributeList());
        } catch (IOException ex) {
            MessageWriter.writeWarning(ResourceController.getMessage(
                    "parser.xml_definition_file.missing_file", element.getName(),
                    OptionItems.XML_DEFINITION_PATH));
        } catch (SAXException ex) {
            Log.warn("error.param_parser.parser_error", ex);
        }
    }
    
    /**
     * Process values of parameters from <code>unparsedAttributeList</code>.
     */
    public void processPropertyDependency() {
//TODO  parse complicated dependent attribute values        
//        Iterator it = unparsedAttributeList.entrySet().iterator();
//        while (it.hasNext()) {
//            Map.Entry pairs = (Map.Entry)it.next();
//          pairs.getKey()  (Attribute)pairs.getValue()
//         }
    }

    public Map<String, Property> getParsedPropertyList() {
        return parsedPropertyList;
    }
   
}
