package cz.zcu.fav.kiv.editor.config;

import java.io.File;
import java.util.Iterator;
import java.util.Map;
import java.util.regex.Pattern;

import cz.zcu.fav.kiv.editor.beans.ConfigData;
import cz.zcu.fav.kiv.editor.beans.common.ParentParameter;
import cz.zcu.fav.kiv.editor.beans.graphics.Figure;
import cz.zcu.fav.kiv.editor.beans.parameters.Parameter;
import cz.zcu.fav.kiv.editor.beans.properties.Property;
import cz.zcu.fav.kiv.editor.beans.sections.Group;
import cz.zcu.fav.kiv.editor.beans.sections.Section;
import cz.zcu.fav.kiv.editor.beans.sections.Subsection;
import cz.zcu.fav.kiv.editor.beans.types.CommonTypes;
import cz.zcu.fav.kiv.editor.controller.logger.Log;
import cz.zcu.fav.kiv.editor.controller.options.OptionItems;

/**
 * The <code>ParamController</code> class contains method for reading XML definitions of
 * parameters and properties.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class ParamController {
    /** The model pattern used for parsing $param */
    public static final String REGEX_PARAM = "\\$[\\w\\.]+";

    /** The model pattern used for parsing $param */
    public static Pattern patternParam = Pattern.compile(REGEX_PARAM);

    /** The parser of XML parameter definitions */
    private ParameterParser parameterParserXML = null;

    /** The parser of XML property definitions */
    private PropertyParser propertyParserXML = null;

    /** The data loaded from configuration files */
    private ConfigData configData;

    /**
     * Initializes a newly created <code>ParamController</code>. Simultaneously initializes new
     * <code>ParameterParser</code> and <code>PropertyParser</code>.
     */
    public ParamController(ConfigData configData, CommonTypes types) {
        parameterParserXML = new ParameterParser(types);
        propertyParserXML = new PropertyParser();
        this.configData = configData;
    }

    /**
     * Reads XML files for all parameters. Processes the complex paramater values that depends on
     * other parameter values.
     */
    public void readParameters() {
        File directory = new File(OptionItems.XML_DEFINITION_PATH);
        if (directory.exists()) {
            parameterParserXML.readParameterDefinition(configData.getParameterList());
            parameterParserXML.processParameterDependency();
        }

        Log.info("info.progress_control.load_parameter_description");
    }

    /**
     * Reads XML files for all properties. Processes the complex attribute values that depends on
     * other parameter values.
     */
    public void readProperties() {
        File directory = new File(OptionItems.XML_DEFINITION_PATH);
        if (directory.exists()) {
            propertyParserXML.readPropertyDefinition(configData.getPropertyList());
            propertyParserXML.processPropertyDependency();
        }
        Log.info("info.progress_control.load_property_description");
    }

    /**
     * Removes all parameters and properties that couldn't be parsed.
     * 
     * @param figureList
     *            the list with graphics figures.
     */
    public void removeInvalidParam(Map<String, Figure> figureList) {
        for (Section section : configData.getSectionList()) {
            Iterator<Subsection> subsectionIter = section.getSubsectionList().iterator();
            while (subsectionIter.hasNext()) {
                Subsection subsection = subsectionIter.next();
                Iterator<Group> groupIter = subsection.getGroupList().iterator();
                while (groupIter.hasNext()) {
                    Group group = groupIter.next();
                    // parameters and properties
                    Iterator<ParentParameter> elementIter = group.getElementList().iterator();
                    while (elementIter.hasNext()) {
                        ParentParameter element = elementIter.next();
                        if (element instanceof Parameter) {
                            if (!parameterParserXML.getParsedParameterList().containsKey(
                                    element.getName()))
                                elementIter.remove();
                        }
                        if (element instanceof Property) {
                            if (!propertyParserXML.getParsedPropertyList().containsKey(
                                    element.getName()))
                                elementIter.remove();
                        }
                    }
                    // figures - remove invalid figures
                    if (group.getFigure() != null) {
                        if (!figureList.containsKey(group.getFigure().getName()))
                            group.setFigure(null);
                    }
                    if (group.getElementList().size() == 0)
                        groupIter.remove();
                }
            }
        }
    }

    public Map<String, Parameter> getParsedParameterList() {
        return parameterParserXML.getParsedParameterList();
    }
}
