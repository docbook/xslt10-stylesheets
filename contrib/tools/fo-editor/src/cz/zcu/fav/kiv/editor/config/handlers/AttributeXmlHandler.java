package cz.zcu.fav.kiv.editor.config.handlers;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.xml.sax.Attributes;
import org.xml.sax.Locator;
import org.xml.sax.helpers.DefaultHandler;

import cz.zcu.fav.kiv.editor.beans.properties.Attribute;
import cz.zcu.fav.kiv.editor.beans.properties.AttributeGroup;
import cz.zcu.fav.kiv.editor.beans.properties.TypeAttr;
import cz.zcu.fav.kiv.editor.beans.properties.UnitAttr;
import cz.zcu.fav.kiv.editor.beans.types.CommonTypes;
import cz.zcu.fav.kiv.editor.config.constants.FileConst;
import cz.zcu.fav.kiv.editor.config.constants.TagDefinition;
import cz.zcu.fav.kiv.editor.config.constants.TypeEnum;
import cz.zcu.fav.kiv.editor.config.constants.TagDefinition.AttributeTags;
import cz.zcu.fav.kiv.editor.controller.MessageWriter;
import cz.zcu.fav.kiv.editor.controller.errors.ParserException;
import cz.zcu.fav.kiv.editor.controller.resource.ResourceController;
import cz.zcu.fav.kiv.editor.utils.TagControl;

/**
 * The <code>AttributeXmlHandler</code> class is used for parsing the configuration file with
 * attributes - attributes.xml.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class AttributeXmlHandler extends DefaultHandler {
    /** The locator specifying actual line number */
    private Locator locator;

    /** The data containing editor data structure */
    private CommonTypes commonTypes;

    /** The list of attributes of one group */
    private List<Attribute> atrributeList;

    /** The list of groups containing attributes */
    private List<AttributeGroup> attributeGroupList;

    /** The group containing attributes */
    private AttributeGroup attrGroup;

    /** The attribute type */
    private TypeAttr type;

    /** The flag specifying whether the parser is inside value element */
    private boolean insideAttributeElement = false;

    /** The string buffer for content of value element */
    private StringBuffer attributeBuffer = new StringBuffer(TagDefinition.BUFFER_SIZE);

    /**
     * Initializes a newly created <code>AttributeXmlHandler</code> with <code>ConfigData</code>.
     * 
     * @param commonTypes
     *            the common types of parameters.
     */
    public AttributeXmlHandler(CommonTypes commonTypes) {
        attributeGroupList = new ArrayList<AttributeGroup>();
        this.commonTypes = commonTypes;
    }

    @Override
    public void startElement(String namespaceURI, String localName, String qName, Attributes atts) {
        AttributeTags enumTag = TagDefinition.AttributeTags.getValue(qName);
        switch (enumTag) {
        case GROUP:
            attrGroup = new AttributeGroup(atts.getValue(0));
            atrributeList = new ArrayList<Attribute>();
            break;
        case ATTRIBUTE:
            type = controlAttribute(atts.getValue(AttributeTags.TYPE.toString()), atts
                    .getValue(AttributeTags.DEFAULT.toString()), atts.getValue(AttributeTags.VALUES
                    .toString()));
            insideAttributeElement = true;
            attributeBuffer.setLength(0);
            break;
        }
    }

    @Override
    public void endElement(String namespaceURI, String localName, String qName) {
        AttributeTags enumTag = TagDefinition.AttributeTags.getValue(qName);
        switch (enumTag) {
        case GROUP:
            attrGroup.setAttributeList(atrributeList);
            attributeGroupList.add(attrGroup);
            break;
        case ATTRIBUTE:
            if (type != null)
                atrributeList.add(new Attribute(attributeBuffer.toString(), type));
            insideAttributeElement = false;
            break;
        }
    }

    @Override
    public void characters(char[] ch, int start, int length) {
        if (insideAttributeElement) {
            attributeBuffer.append(ch, start, length);
        }
    }

    /**
     * Assignes predefined type values to the attribute type that has defined a name of predefined
     * values.
     */
    private void addTypeValues(TypeAttr type) {
        switch (type.getName()) {
        case FONT:
            type.setValueList(commonTypes.getFonts());
            break;
        case COLOR:
            type.setValueList(commonTypes.getColors());
            break;
        }
    }

    /**
     * Controls if the type, values and default value of the attribute are valid.
     * 
     * @return TypeAttr if the attribute is valid.
     */
    private TypeAttr controlAttribute(String typeName, String defaultValue, String values) {
        type = new TypeAttr();
        TypeEnum typeEnum = TypeEnum.getValue(typeName);
        if (typeEnum == null) {
            MessageWriter.writeWarning(ResourceController.getMessage(
                    "parser.attributes.invalid_attribute_type",
                    FileConst.CONF_FILE_ATTRIBUTES, this.locator.getLineNumber()));
            return null;
        }
        type.setName(typeEnum);
        // values
        if (values != null) {
            try {
                String[] valueList = values.split(",");
                Map<String, String> valueMap = new LinkedHashMap<String, String>();
                for (String val : valueList) {
                    valueMap.put(val.trim(), val.trim());
                }
                type.setValueList(valueMap);
            } catch (Exception ex) {
                MessageWriter.writeWarning(ResourceController.getMessage(
                        "parser.attributes.invalid_attribute_value",
                        FileConst.CONF_FILE_ATTRIBUTES, this.locator.getLineNumber()));
                return null;
            }
        }
        // add unit
        if (type.getName().equals(TypeEnum.LENGTH)) {
            type.setUnit(new UnitAttr(commonTypes.getUnits()));
        }

        // add common types values
        addTypeValues(type);

        // default value
        try {
            TagControl.controlSetTypeValue(type, defaultValue);
            type.assignDefaultFromValue();
        } catch (ParserException ex){
            MessageWriter.writeWarning(ResourceController.getMessage(
                    "parser.attributes.invalid_attribute_default_value", FileConst.CONF_FILE_ATTRIBUTES,
                    this.locator.getLineNumber()));
            return null;
        }
        return type;
    }

    public void setDocumentLocator(Locator locator) {
        this.locator = locator;
    }

    public AttributeGroup[] getAttrGroupList() {
        return attributeGroupList.toArray(new AttributeGroup[0]);
    }
}
