package cz.zcu.fav.kiv.editor.beans;

import java.util.Collections;
import java.util.List;
import java.util.Map;

import cz.zcu.fav.kiv.editor.beans.parameters.Parameter;
import cz.zcu.fav.kiv.editor.beans.properties.Property;
import cz.zcu.fav.kiv.editor.beans.sections.Section;

/**
 * The <code>ConfigData</code> class represents main structure containing the list of parameter
 * sections and lists of predefined type values.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class ConfigData {
    /** The list of sections */
    private List<Section> sectionList;

    /** The list of parameters - keys are parameter names */
    private Map<String, Parameter> parameterList;

    /** The list of properties - keys are property names */
    private Map<String, Property> propertyList;

    /**
     * Clear values (sets default values) of all sections.
     */
    public void clearValues() {
        for (Section section : sectionList)
            section.clearValues();
    }

    /**
     * Search for an parameter with specified name.
     * 
     * @param name
     *            a name of serched parameter.
     * @return the found parameter with specified name.
     */
    public Parameter searchParameter(String name) {
        return parameterList.get(name);
    }

    /**
     * Search for a property with specified name.
     * 
     * @param name
     *            a name of serched property.
     * @return the found property with specified name.
     */
    public Property searchProperty(String name) {
        return propertyList.get(name);
    }

    @SuppressWarnings("unchecked")
    public List<Section> getSectionList() {        
        return sectionList != null? sectionList : Collections.EMPTY_LIST;
    }

    public void setSectionList(List<Section> sectionList) {
        this.sectionList = sectionList;
    }

    public Map<String, Parameter> getParameterList() {
        return parameterList;
    }

    public void setParameterList(Map<String, Parameter> parameterList) {
        this.parameterList = parameterList;
    }

    public Map<String, Property> getPropertyList() {
        return propertyList;
    }

    public void setPropertyList(Map<String, Property> propertyList) {
        this.propertyList = propertyList;
    }

}
