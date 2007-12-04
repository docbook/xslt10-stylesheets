package cz.zcu.fav.kiv.editor.beans.properties;

import cz.zcu.fav.kiv.editor.beans.common.ParentParameter;

/**
 * The <code>Property</code> class represents an element property.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class Property extends ParentParameter {
    /** The list of attribute groups */
    private AttributeGroup[] attributeGroupList;

    /**
     * Initializes a newly created <code>Attribute</code> with the specified name and the list of
     * attribute groups. The <code>name</code> argument is the name of the property. The
     * <code>attributeGroups</code> argument is the list of <code>AttributeGroup</code>s.
     * 
     * @param name
     *            a name of the property.
     * @param attributeGroups
     *            a list of attribute groups.
     */
    public Property(String name, AttributeGroup[] attributeGroups, int lineNumber) {
        super(name, lineNumber);
        this.attributeGroupList = attributeGroups;
    }

    public AttributeGroup[] getAttributeGroupList() {
        return attributeGroupList;
    }

    /**
     * Search for an attribute with specified name.
     * 
     * @param name
     *            a name of serched attribute.
     * @return the found attribute with specified name.
     */
    public Attribute searchAttribute(String name) {
        for (AttributeGroup group : attributeGroupList) {
            int ind = group.getAttributeList().indexOf(new Attribute(name));
            if (ind >= 0)
                return group.getAttributeList().get(ind);
        }
        return null;
    }

    /**
     * Sets values of all groups of types after their temporary values.
     */
    public void setValuesFromTemporary() {
        for (AttributeGroup pan : attributeGroupList)
            pan.setValuesFromTemporary();
    }

    /**
     * Clear values (sets default values) of all groups of types.
     */
    public void clearValues() {
        super.clearValues();
        for (AttributeGroup group : this.attributeGroupList) {
            group.clearValues();
        }
    }
}
