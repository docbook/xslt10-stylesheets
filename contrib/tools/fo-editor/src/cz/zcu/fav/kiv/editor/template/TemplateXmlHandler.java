package cz.zcu.fav.kiv.editor.template;

import org.xml.sax.Attributes;
import org.xml.sax.Locator;
import org.xml.sax.helpers.DefaultHandler;

import cz.zcu.fav.kiv.editor.beans.ConfigData;
import cz.zcu.fav.kiv.editor.beans.parameters.Parameter;
import cz.zcu.fav.kiv.editor.beans.properties.Attribute;
import cz.zcu.fav.kiv.editor.beans.properties.Property;
import cz.zcu.fav.kiv.editor.config.constants.FileConst;
import cz.zcu.fav.kiv.editor.config.constants.TagDefinition;
import cz.zcu.fav.kiv.editor.controller.MessageWriter;
import cz.zcu.fav.kiv.editor.controller.errors.ParserException;
import cz.zcu.fav.kiv.editor.controller.resource.ResourceController;
import cz.zcu.fav.kiv.editor.template.TemplateConst.TemplateTags;

/**
 * The <code>TemplateXmlHandler</code> class is used for parsing file with template.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class TemplateXmlHandler extends DefaultHandler {
    /** The locator specifying actual line number */
    private Locator locator;

    /** The data containing editor data structure */
    private ConfigData configData;

    /** The name of the file with template */
    private String templateFile;

    /** The number of the line with property element */
    private int propertyLine;

    /** The property with attribute */
    private Property property;

    /** The list of attribute values */
    private String attributeValue;

    /** The name of parameter */
    private String parameterValue;

    /** The flag specifying whether the parser is inside attribute element */
    private boolean insideAttributeElement = false;

    /** The flag specifying whether the parser is inside parameter element */
    private boolean insideParameterElement = false;

    /** The string buffer for content of attribute element */
    private StringBuffer attributeBuffer = new StringBuffer(TagDefinition.BUFFER_SIZE);

    /** The string buffer for content of parameter element */
    private StringBuffer parameterBuffer = new StringBuffer(TagDefinition.BUFFER_SIZE);

    /**
     * Initializes a newly created <code>TemplateXmlHandler</code> with <code>ConfigData</code>
     * and template name <code>templateFile</code>.
     * 
     * @param configData
     *            the data containing editor data structure.
     * @param template
     *            the name of the file with template.
     */
    public TemplateXmlHandler(ConfigData configData, String template) {
        this.configData = configData;
        this.templateFile = template;
    }

    @Override
    public void startElement(String namespaceURI, String localName, String qName, Attributes atts) {
        TemplateTags enumTag = TemplateConst.TemplateTags.getValue(qName);
        if (enumTag != null)
            switch (enumTag) {
                case ATTRIBUTE_SET:
                    property = configData.searchProperty(atts.getValue(0));
                    if (property == null)
                        MessageWriter.writeWarning(ResourceController.getMessage("parser.template.find_property", FileConst.CONF_FILE_CONFIG, atts.getValue(0), templateFile, locator.getLineNumber()));
                    else
                        property.setChosen();

                    this.propertyLine = locator.getLineNumber();
                break;
                case ATTRIBUTE:
                    insideAttributeElement = true;
                    attributeBuffer.setLength(0);            
                            attributeValue = atts.getValue(0);           
                break;
                case PARAMETER:
                    insideParameterElement = true;
                    parameterBuffer.setLength(0);
                    parameterValue = atts.getValue(0);
                break;
            }
    }

    @Override
    public void endElement(String namespaceURI, String localName, String qName) {
        TemplateTags enumTag = TemplateConst.TemplateTags.getValue(qName);
        if (enumTag != null)
            switch (enumTag) {
                case ATTRIBUTE:
                    insideAttributeElement = false;
                    try {
                        if (property != null)
                            changeAttribute(attributeBuffer.toString());
                    } catch (ParserException ce) {
                        MessageWriter.writeWarning(ResourceController.getMessage("parser.template.parse_attribute_value", templateFile, attributeBuffer.toString(), this.propertyLine));
                    }
                break;
                case PARAMETER:
                    insideParameterElement = false;
                    try {
                        changeParameter();
                    } catch (ParserException ce) {
                        MessageWriter.writeWarning(ResourceController.getMessage("parser.template.parse_parameter_value", templateFile, attributeBuffer.toString(), this.propertyLine));
                    }
                break;
            }
    }

    @Override
    public void characters(char[] ch, int start, int length) {
        if (insideAttributeElement) {
            attributeBuffer.append(ch, start, length);
        } else if (insideParameterElement) {
            parameterBuffer.append(ch, start, length);
        }
    }

    /**
     * Change type value of the actual parsed parameter.
     * 
     * @throws ParserException
     *             if the parameter value is not valid.
     */
    private void changeParameter() throws ParserException {
        Parameter parameter = configData.searchParameter(parameterBuffer.toString());
        if (parameter == null)
            MessageWriter.writeWarning(ResourceController.getMessage("parser.template.find_parameter", FileConst.CONF_FILE_CONFIG, parameterBuffer.toString(), templateFile, locator.getLineNumber()));
        else {
            // set new parameter value
            parameter.getType().setLoadedValue(parameterValue);
            parameter.setChosen();
        }

    }

    /**
     * Change type values of the actual parsed attribute specified by name.
     * 
     * @param attrName
     *            an attribute name.
     * @throws ParserException
     *             if the attribute values are not valid.
     */
    private void changeAttribute(String attrName) throws ParserException {
        Attribute searchAttr = property.searchAttribute(attrName);
        if (searchAttr != null) {
            if (attributeValue != null)
                searchAttr.getType().setLoadedValue(attributeValue);
            searchAttr.setChosen(true);
        } else
            MessageWriter.writeWarning(ResourceController.getMessage("parser.template.find_attribute", FileConst.CONF_FILE_ATTRIBUTES, attributeBuffer.toString(), templateFile, this.propertyLine));
    }

    public void setDocumentLocator(Locator locator) {
        this.locator = locator;
    }
}
