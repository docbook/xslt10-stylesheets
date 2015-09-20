package cz.zcu.fav.kiv.editor.config.handlers;

import java.util.HashMap;
import java.util.Map;
import java.util.regex.Matcher;

import org.xml.sax.Attributes;
import org.xml.sax.helpers.DefaultHandler;

import cz.zcu.fav.kiv.editor.beans.properties.Attribute;
import cz.zcu.fav.kiv.editor.beans.properties.Property;
import cz.zcu.fav.kiv.editor.config.ParamController;
import cz.zcu.fav.kiv.editor.config.ParameterTransformation;
import cz.zcu.fav.kiv.editor.config.constants.FileConst;
import cz.zcu.fav.kiv.editor.config.constants.TagDefinition;
import cz.zcu.fav.kiv.editor.config.constants.TypeEnum;
import cz.zcu.fav.kiv.editor.config.constants.TagDefinition.ParameterTags;
import cz.zcu.fav.kiv.editor.controller.MessageWriter;
import cz.zcu.fav.kiv.editor.controller.errors.ParserException;
import cz.zcu.fav.kiv.editor.controller.resource.ResourceController;
import cz.zcu.fav.kiv.editor.utils.TagControl;

/**
 * The <code>PropertyXmlHandler</code> class is used for parsing files with XML definitions of
 * properties.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class PropertyXmlHandler extends DefaultHandler {

    /** The property which XML file is parsed */
    private Property property;

    /** The flag indicating if the actually parsed proeperty XML is valid */
    private boolean valid = true;

    /** The name of actually parsed attribute */
    private String attributeName;

    /** The list of attributes that cannot be parsed */
    private Map<String, Attribute> unparsedAttributeList;

    /** The flag specifying whether the parser is inside <refsection> element */
    private boolean insideRefsection = false;

    /** The flag specifying whether the parser is inside <refpurpose> element */
    private boolean insideRefpurpose = false;

    /** The flag specifying whether the parser is inside <refmiscinfo otherclass="datatype"> element */
    private boolean insideRefmiscinfoDatatype = false;

    /** The flag specifying whether the parser is inside <xsl:attribute> element */
    private boolean insideXslAttribute = false;

    /** The string buffer for content of description element <refsection> */
    private StringBuffer descriptionBuffer = new StringBuffer(TagDefinition.BUFFER_SIZE_DESCRIPTION);

    /** The string buffer for content of purpose element <refpurpose> */
    private StringBuffer purposeBuffer = new StringBuffer(TagDefinition.BUFFER_SIZE_DESCRIPTION);

    /** The string buffer for content of <refmiscinfo otherclass="datatype"> element */
    private StringBuffer refmiscinfoDatatypeBuffer = new StringBuffer(TagDefinition.BUFFER_SIZE);

    /** The string buffer for content of purpose element <xsl:attribute> */
    private StringBuffer xslAttributeBuffer = new StringBuffer(TagDefinition.BUFFER_SIZE);

    /**
     * Initializes a newly created empty <code>PropertyXmlHandler</code>.
     */
    public PropertyXmlHandler(Property property) {
        this.property = property;
        unparsedAttributeList = new HashMap<String, Attribute>();
    }

    @Override
    public void startElement(String namespaceURI, String localName, String qName, Attributes atts) {
        if (insideXslAttribute) {
            xslAttributeBuffer.append("<" + qName);
            for (int i = 0; i < atts.getLength(); i++) {
                xslAttributeBuffer.append(" " + atts.getQName(i) + "=\"" + atts.getValue(i) + "\"");
            }
            xslAttributeBuffer.append(">");
        }
        ParameterTags enumTag = TagDefinition.ParameterTags.getEnumValue(qName);
        switch (enumTag) {
        case REFSECTION:
            insideRefsection = true;
            descriptionBuffer.setLength(0);
            break;
        case REFPURPOSE:
            insideRefpurpose = true;
            purposeBuffer.setLength(0);
            break;
        case REFMISCINFO:
        	if (atts.getType(ParameterTags.OTHERCLASS) == null) {
                MessageWriter.writeWarning(ResourceController.getMessage(
                        "parser.property.invalid_type", FileConst.CONF_FILE_CONFIG, property
                                .getName(), property.getLineNumber()));
                valid = false;
                return;
        	}
            if (atts.getType(ParameterTags.OTHERCLASS).equals(ParameterTags.DATATYPE.toString())) {
                insideRefmiscinfoDatatype = true;
                refmiscinfoDatatypeBuffer.setLength(0);
            }
            break;
        case XSL_ATTRIBUTE:
            insideXslAttribute = true;
            attributeName = atts.getValue(ParameterTags.NAME);
            xslAttributeBuffer.setLength(0);
            break;
        }

        if (insideRefsection) {
            descriptionBuffer.append("<" + qName + ">");
        }
    }

    @Override
    public void endElement(String namespaceURI, String localName, String qName) {
        if (insideRefsection) {
            descriptionBuffer.append("</" + qName + ">");
        }
        ParameterTags enumTag = TagDefinition.ParameterTags.getEnumValue(qName);
        switch (enumTag) {
        case REFSECTION:
            insideRefsection = false;
            if (descriptionBuffer.length() != 0)
                property.setDescription(ParameterTransformation.htmlTransform(descriptionBuffer
                        .toString()));
            break;
        case REFPURPOSE:
            insideRefpurpose = false;
            property.setPurpose(purposeBuffer.toString());
            break;
        case REFMISCINFO:
            if (insideRefmiscinfoDatatype) {
                insideRefmiscinfoDatatype = false;
                if (!TypeEnum.ATTRIBUTE_SET.toString().equals(refmiscinfoDatatypeBuffer.toString())) {
                    MessageWriter.writeWarning(ResourceController.getMessage(
                            "parser.property.invalid_type", FileConst.CONF_FILE_CONFIG, property
                                    .getName(), property.getLineNumber()));
                    valid = false;
                }
            }
            break;
        case XSL_ATTRIBUTE:
            insideXslAttribute = true;
            // save attribute value
            // TODO parsing attribute values for each property according to its .xml
            // if (attributeName != null)
            // controlXslAttributeValue();
            break;
        }
        if (insideXslAttribute)
            xslAttributeBuffer.append("</" + qName + ">");
    }

    @Override
    public void characters(char[] ch, int start, int length) {
        if (insideRefsection) {
            String nextPart = new String(ch, start, length);
            nextPart = nextPart.replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("&",
                    "&amp;");
            descriptionBuffer.append(nextPart);
        } else if (insideRefpurpose) {
            purposeBuffer.append(ch, start, length);
        } else if (insideRefmiscinfoDatatype) {
            refmiscinfoDatatypeBuffer.append(ch, start, length);
        } else if (insideXslAttribute) {
            xslAttributeBuffer.append(ch, start, length);
        }
    }

    public boolean isValid() {
        return valid;
    }

    /**
     * Controls if the actually parsed attribute value can be parsed - is supported and if it is
     * valid and can be parsed without other parameters. If the attribute cannot be parsed, it is
     * assignes to the <code>unparsedAttributeList</code>.
     */
    private void controlXslAttributeValue() {
        Attribute attr = property.searchAttribute(attributeName);
        if (attr == null) {
            // unsupported attribute
            MessageWriter.writeWarning(ResourceController.getMessage(
                    "parser.property.unsupported_attribute", FileConst.CONF_FILE_CONFIG, property
                            .getName(), property.getLineNumber(), attributeName));
            return;
        }
        String paramValue = xslAttributeBuffer.toString().trim();
        Matcher matcher = ParamController.patternParam.matcher(paramValue);
        if (!matcher.find()) {
            // raw value
            try {
                TagControl.controlSetTypeValue(attr.getType(), paramValue.replaceAll("'", "")
                        .replaceAll("<[//]?xsl:text>", ""));
                attr.getType().assignDefaultFromValue();
            } catch (ParserException ex) {
                MessageWriter.writeWarning(ResourceController.getMessage(
                        "parser.property.invalid_value", FileConst.CONF_FILE_CONFIG, property
                                .getName(), property.getLineNumber(), attributeName));
            }
        } else {
            attr.getType().setValue(paramValue);
            unparsedAttributeList.put(attributeName, attr);
        }
    }

    public Map<String, Attribute> getUnparsedAttributeList() {
        return unparsedAttributeList;
    }
}
