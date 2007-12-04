package cz.zcu.fav.kiv.editor.config.handlers;

import java.util.LinkedHashMap;
import java.util.Map;
import java.util.regex.Matcher;

import org.xml.sax.Attributes;
import org.xml.sax.helpers.DefaultHandler;

import cz.zcu.fav.kiv.editor.beans.parameters.Parameter;
import cz.zcu.fav.kiv.editor.beans.parameters.TypeParam;
import cz.zcu.fav.kiv.editor.beans.parameters.UnitParam;
import cz.zcu.fav.kiv.editor.beans.types.CommonTypes;
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
 * The <code>ParameterXmlHandler</code> class is used for parsing files with XML definitions of
 * parameters.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class ParameterXmlHandler extends DefaultHandler {

    /** The parameter which XML file is parsed */
    private Parameter parameter;

    /** The list of common types */
    private static CommonTypes commonTypes;

    /** The flag indicating if the actually parsed parameter XML is valid */
    private boolean valid = true;

    /**
     * The flag indicating if the actually parsed parameter value can be parsed without dependencies
     * on other parameters
     */
    private boolean parsed = false;

    /** The list of default values of the parameter */
    private Map<String, String> valueList;

    /** The flag specifying whether the parser is inside <refsection> element */
    private boolean insideRefsection = false;

    /** The flag specifying whether the parser is inside <refpurpose> element */
    private boolean insideRefpurpose = false;

    /** The flag specifying whether the parser is inside <refmiscinfo otherclass="datatype"> element */
    private boolean insideRefmiscinfoDatatype = false;

    /** The flag specifying whether the parser is inside <refmiscinfo otherclass="value"> element */
    private boolean insideRefmiscinfoValue = false;

    /**
     * The flag specifying whether the parser is inside <refmiscinfo otherclass="value"><alt>
     * element
     */
    private boolean insideRefmiscinfoValueAlt = false;

    /** The flag specifying whether the parser is inside <refmiscinfo otherclass="list-type"> element */
    private boolean insideRefmiscinfoListType = false;

    /** The flag specifying whether the parser is inside <xsl:param> element */
    private boolean insideXslParam = false;

    /** The string buffer for content of description element <refsection> */
    private StringBuffer descriptionBuffer = new StringBuffer(TagDefinition.BUFFER_SIZE_DESCRIPTION);

    /** The string buffer for content of <refpurpose> element */
    private StringBuffer purposeBuffer = new StringBuffer(TagDefinition.BUFFER_SIZE_DESCRIPTION);

    /** The string buffer for content of <xsl:param> element */
    private StringBuffer insideXslParamBuffer = new StringBuffer(
            TagDefinition.BUFFER_SIZE_DESCRIPTION);

    /** The string buffer for content of <refmiscinfo otherclass="datatype"> element */
    private StringBuffer refmiscinfoDatatypeBuffer = new StringBuffer(TagDefinition.BUFFER_SIZE);

    /** The string buffer for content of <refmiscinfo otherclass="value"> element */
    private StringBuffer refmiscinfoValueBuffer = new StringBuffer(TagDefinition.BUFFER_SIZE);

    /** The string buffer for content of <refmiscinfo otherclass="value"><alt> element */
    private StringBuffer refmiscinfoValueAltBuffer = new StringBuffer(TagDefinition.BUFFER_SIZE);

    /** The string buffer for content of <refmiscinfo otherclass="list-type"> element */
    private StringBuffer refmiscinfoListTypeBuffer = new StringBuffer(TagDefinition.BUFFER_SIZE);

    /**
     * Initializes a newly created empty <code>ParameterXmlHandler</code>.
     */
    public ParameterXmlHandler(Parameter parameter, CommonTypes types) {
        this.parameter = parameter;
        commonTypes = types;
    }

    @Override
    public void startElement(String namespaceURI, String localName, String qName, Attributes atts) {
        if (insideXslParam) {
            insideXslParamBuffer.append("<" + qName);
            for (int i = 0; i < atts.getLength(); i++) {
                insideXslParamBuffer.append(" " + atts.getQName(i) + "=\"" + atts.getValue(i)
                        + "\"");
            }
            insideXslParamBuffer.append(">");
        }
        ParameterTags enumTag = ParameterTags.getEnumValue(qName);
        switch (enumTag) {
        case REFMETA:
            valueList = new LinkedHashMap<String, String>();
            break;
        case REFSECTION:
            insideRefsection = true;
            descriptionBuffer.setLength(0);
            break;
        case REFPURPOSE:
            insideRefpurpose = true;
            purposeBuffer.setLength(0);
            break;
        case REFMISCINFO:
            ParameterTags attrOtherClass = ParameterTags.getEnumValue(atts
                    .getValue(ParameterTags.OTHERCLASS));
            switch (attrOtherClass) {
            case DATATYPE:
                insideRefmiscinfoDatatype = true;
                break;
            case VALUE:
                insideRefmiscinfoValue = true;
                refmiscinfoValueBuffer.setLength(0);
                break;
            case LIST_TYPE:
                insideRefmiscinfoListType = true;
                break;
            }
            break;
        case ALT:
            insideRefmiscinfoValueAlt = true;
            refmiscinfoValueAltBuffer.setLength(0);
            break;
        case XSL_PARAM:
            insideXslParamBuffer.setLength(0);
            // parse select
            if (valid)
                insideXslParam = parseXslParamSelect(atts);
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
        ParameterTags enumTag = ParameterTags.getEnumValue(qName);
        switch (enumTag) {
        case REFMETA:
            controlType();
            break;
        case REFSECTION:
            insideRefsection = false;
            if (descriptionBuffer.length() != 0)
                parameter.setDescription(ParameterTransformation.htmlTransform(descriptionBuffer
                        .toString().trim()));
            break;
        case REFPURPOSE:
            insideRefpurpose = false;
            parameter.setPurpose(purposeBuffer.toString());
            break;
        case REFMISCINFO:
            if (insideRefmiscinfoDatatype) {
                insideRefmiscinfoDatatype = false;
            }
            if (insideRefmiscinfoListType) {
                insideRefmiscinfoListType = false;
            }
            if (insideRefmiscinfoValue) {
                insideRefmiscinfoValue = false;
                if (refmiscinfoValueAltBuffer.length() != 0)
                    valueList.put(refmiscinfoValueBuffer.toString(), refmiscinfoValueAltBuffer
                            .toString()
                            + " (" + refmiscinfoValueBuffer.toString() + ")");
                else
                    valueList.put(refmiscinfoValueBuffer.toString(), refmiscinfoValueBuffer
                            .toString());
            }
            break;
        case ALT:
            insideRefmiscinfoValueAlt = false;
            break;
        case XSL_PARAM:
            if ((valid) && (insideXslParam))
                controlXslParamValue();
            insideXslParam = false;
            break;
        }
        if (insideXslParam)
            insideXslParamBuffer.append("</" + qName + ">");
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
        } else if (insideRefmiscinfoValue) {
            if (insideRefmiscinfoValueAlt)
                refmiscinfoValueAltBuffer.append(ch, start, length);
            else
                refmiscinfoValueBuffer.append(ch, start, length);
        } else if (insideRefmiscinfoListType) {
            refmiscinfoListTypeBuffer.append(ch, start, length);
        } else if (insideXslParam) {
            String nextPart = new String(ch, start, length);
            nextPart = nextPart.replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("&",
                    "&amp;");
            insideXslParamBuffer.append(nextPart);
        }
    }

    /**
     * Controls if the parameter type definition is valid. Assigns to paramter type the list of
     * predefined values.
     */
    private void controlType() {
        TypeEnum typeName = TypeEnum.getValue(refmiscinfoDatatypeBuffer.toString());
        if (typeName == null) {
            MessageWriter.writeWarning(ResourceController.getMessage(
                    "parser.parameters.invalid_type", FileConst.CONF_FILE_CONFIG, parameter
                            .getName(), parameter.getLineNumber()));
            valid = false;
            return;
        }
        parameter.getType().setName(typeName);
        // open list
        if ((parameter.getType().getName().equals(TypeEnum.LIST))
                && (refmiscinfoListTypeBuffer.toString().equals(ParameterTags.OPEN)))
            parameter.getType().setName(TypeEnum.LIST_OPEN);

        // length - assigne units
        if (parameter.getType().getName().equals(TypeEnum.LENGTH))
            parameter.getType().setUnit(new UnitParam(commonTypes.getUnits(), parameter));

        // list values
        if ((parameter.getType().getName().equals(TypeEnum.LIST) || (parameter.getType().getName()
                .equals(TypeEnum.LIST_OPEN)))
                && (valueList.size() != 0))
            parameter.getType().getDefaultValue().setValueList(valueList);
        addTypeValues(parameter.getType());
    }

    /**
     * Assigns to the parameter a list of default values.
     * 
     * @param type
     *            the parameter type.
     */
    private void addTypeValues(TypeParam type) {
        switch (type.getName()) {
        case FONT:
            type.setValueList(commonTypes.getFonts());
            break;
        case COLOR:
            type.setValueList(commonTypes.getColors());
            break;
        }
    }

    public boolean isValid() {
        return valid;
    }

    /**
     * Assignes the content of the attribute <code>select</code> of the element <xsl:param> to the
     * <code>insideXslParamBuffer</code>. Controls whether the parameter has no other condition
     * than 'FO'.
     * 
     * @param atts
     *            the attributes of the element <xsl:param>.
     * @return true if the <xsl:param> has no other condition than 'FO'.
     */
    private boolean parseXslParamSelect(Attributes atts) {
        // condition="fo"
        if ((atts.getValue(ParameterTags.CONDITION) != null)
                && (!atts.getValue(ParameterTags.CONDITION).equals(ParameterTags.FO)))
            return false;
        // select
        if ((atts.getValue(ParameterTags.SELECT)) != null) {
            insideXslParamBuffer.append(atts.getValue(ParameterTags.SELECT));
        }
        return true;
    }

    /**
     * Controls the content of the element <xsl:param>. If the content is not simple (cannot be
     * parsed without others parameters) then <code>parsed</code> is set to false. If the content
     * is not valid then <code>valid</code> is set to false.
     */
    private void controlXslParamValue() {
        String paramValue = insideXslParamBuffer.toString();
        // rtf
        if (parameter.getType().getName().equals(TypeEnum.RTF)) {
            parameter.getType().setValue(paramValue.trim());
            parameter.getType().assignDefaultFromValue();
            parsed = true;
            return;
        }
        Matcher matcher = ParamController.patternParam.matcher(paramValue);
        if (!matcher.find()) {
            // raw value
            try {
                TagControl.controlSetTypeValue(parameter.getType(), paramValue.replaceAll("'", "")
                        .replaceAll("<[//]?xsl:text>", ""));
                parameter.getType().assignDefaultFromValue();
                parsed = true;
            } catch (ParserException ex) {
                MessageWriter.writeWarning(ResourceController.getMessage(
                        "parser.parameters.invalid_value", FileConst.CONF_FILE_CONFIG, parameter
                                .getName(), parameter.getLineNumber()));
                valid = false;
            }
        } else {
            parameter.getType().setValue(paramValue.trim());
        }
    }

    public boolean isParsed() {
        return parsed;
    }
}
