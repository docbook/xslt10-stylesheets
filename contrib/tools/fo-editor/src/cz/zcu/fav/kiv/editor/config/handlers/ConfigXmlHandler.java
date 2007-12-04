package cz.zcu.fav.kiv.editor.config.handlers;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import org.xml.sax.Attributes;
import org.xml.sax.Locator;
import org.xml.sax.helpers.DefaultHandler;

import cz.zcu.fav.kiv.editor.beans.common.ParentParameter;
import cz.zcu.fav.kiv.editor.beans.graphics.Figure;
import cz.zcu.fav.kiv.editor.beans.parameters.Parameter;
import cz.zcu.fav.kiv.editor.beans.properties.AttributeGroup;
import cz.zcu.fav.kiv.editor.beans.properties.Property;
import cz.zcu.fav.kiv.editor.beans.sections.Group;
import cz.zcu.fav.kiv.editor.beans.sections.Section;
import cz.zcu.fav.kiv.editor.beans.sections.Subsection;
import cz.zcu.fav.kiv.editor.config.constants.FileConst;
import cz.zcu.fav.kiv.editor.config.constants.TagDefinition;
import cz.zcu.fav.kiv.editor.config.constants.TagDefinition.ConfigTags;
import cz.zcu.fav.kiv.editor.controller.MessageWriter;
import cz.zcu.fav.kiv.editor.controller.resource.ResourceController;

/**
 * The <code>ConfigXmlHandler</code> class is used for parsing the configuration file with layout
 * of parameters and attribute-sets - config.xml.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class ConfigXmlHandler extends DefaultHandler {
    /** The locator specifying actual line number */
    private Locator locator;

    /** The list of parameters - key is parameter name */
    private Map<String, Parameter> parameterList;

    /** The list of groups containing attributes */
    private AttributeGroup[] attributeGroupList;

    /** The list of properties - key is property name */
    private Map<String, Property> propertyList;
    
    /** The list of graphics figures */
    private Map<String, Figure> figureList = null;

    /** The group */
    private Group group;

    /** The list of sections */
    private List<Section> sectionList;

    /** The section */
    private Section section;

    /** The list of subsections */
    private List<Subsection> subsectionList;

    /** The subsection */
    private Subsection subsection;

    /** The list of groups */
    private List<Group> groupList;

    /** The list of elements - <code>Parameter</code> and <code>Property<code> */
    private List<ParentParameter> elementList;

    /** The flag specifying whether the parser is inside parameter element */
    private boolean insideParameterElement = false;

    /** The flag specifying whether the parser is inside property element */
    private boolean insidePropertyElement = false;

    /** The string buffer for content of parameter element */
    private StringBuffer parameterBuffer = new StringBuffer(TagDefinition.BUFFER_SIZE);

    /** The string buffer for content of property element */
    private StringBuffer propertyBuffer = new StringBuffer(TagDefinition.BUFFER_SIZE);

    /**
     * Initializes a newly created <code>ConfigXmlHandler</code> with list of
     * <code>AttributeGroup</code>s.
     * 
     * @param attributeGroupList
     *            the list of attribute groups.
     */
    public ConfigXmlHandler(AttributeGroup[] attributeGroupList) {
        sectionList = new ArrayList<Section>();
        this.parameterList = new TreeMap<String, Parameter>();
        this.attributeGroupList = attributeGroupList;
        this.propertyList = new TreeMap<String, Property>();
        this.figureList = new TreeMap<String, Figure>();
    }

    @Override
    public void startElement(String namespaceURI, String localName, String qName, Attributes atts) {
        ConfigTags enumTag = TagDefinition.ConfigTags.getValue(qName);
        switch (enumTag) {
            case SECTION:
                section = new Section(atts.getValue(0));
                subsectionList = new ArrayList<Subsection>();
            break;
            case SUBSECTION:
                subsection = new Subsection(atts.getValue(0));
                groupList = new ArrayList<Group>();
            break;
            case GROUP:
                group = new Group(atts.getValue(0));
                if (atts.getValue(1) != null) {
                    Figure fig = new Figure(atts.getValue(1));
                    group.setFigure(fig);
                    figureList.put(atts.getValue(1), fig); 
                }
                elementList = new ArrayList<ParentParameter>();
            break;
            case PARAMETER:
                insideParameterElement = true;
                parameterBuffer.setLength(0);
            break;
            case ATTRIBUTE_SET:
                insidePropertyElement = true;
                propertyBuffer.setLength(0);
            break;
        }
    }

    @Override
    public void endElement(String namespaceURI, String localName, String qName) {
        ConfigTags enumTag = TagDefinition.ConfigTags.getValue(qName);
        switch (enumTag) {
            case SECTION:
                if (subsectionList.size() != 0) {
                    section.setSubsectionList(subsectionList);
                    sectionList.add(section);
                }
            break;
            case SUBSECTION:
                if (groupList.size() != 0) {
                    subsection.setGroupList(groupList);
                    subsectionList.add(subsection);
                }
            break;
            case GROUP:
                if (elementList.size() != 0) {
                    group.setElementList(elementList);
                    groupList.add(group);
                }
            break;
            case PARAMETER:
                insideParameterElement = false;
                Parameter newParameter = new Parameter(parameterBuffer.toString(), locator.getLineNumber());
                if (!parameterList.containsKey(parameterBuffer.toString())) {
                    parameterList.put(parameterBuffer.toString(), newParameter);
                    elementList.add(newParameter);
                } else {
                    MessageWriter.writeWarning(ResourceController.getMessage(
                            "parser.config.duplicate_parameter",
                            FileConst.CONF_FILE_CONFIG, parameterBuffer.toString(), this.locator.getLineNumber()));
                }
             break;
            case ATTRIBUTE_SET:
                insidePropertyElement = false;
                Property newProperty = new Property(propertyBuffer.toString(), cloneGroups(attributeGroupList), locator.getLineNumber());
                propertyList.put(propertyBuffer.toString(), newProperty);
                elementList.add(newProperty);
            break;
        }
    }

    @Override
    public void characters(char[] ch, int start, int length) {
        if (insideParameterElement) {
            parameterBuffer.append(ch, start, length);
        } else if (insidePropertyElement) {
            propertyBuffer.append(ch, start, length);
        }
    }

    /**
     * Makes copies of all attribute groups.
     * 
     * @param groupList
     *            the list of atribute groups.
     * @return a copy of the input list of attribute groups.
     */
    private AttributeGroup[] cloneGroups(AttributeGroup[] groupList) {
        AttributeGroup[] newGroups = new AttributeGroup[groupList.length];
        for (int i = 0; i < groupList.length; i++) {
            newGroups[i] = (AttributeGroup) groupList[i].clone();
        }
        return newGroups;
    }

    public void setDocumentLocator(Locator locator) {
        this.locator = locator;
    }

    public List<Section> getSections() {
        return sectionList;
    }

    public Map<String, Property> getPropertyList() {
        return propertyList;
    }

    public Map<String, Parameter> getParameterList() {
        return parameterList;
    }

    public Map<String, Figure> getFigureList() {
        return figureList;
    }
}
