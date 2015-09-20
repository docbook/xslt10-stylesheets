package cz.zcu.fav.kiv.editor.beans.properties;

import java.util.ArrayList;
import java.util.List;

import cz.zcu.fav.kiv.editor.beans.common.ParentSection;
import cz.zcu.fav.kiv.editor.controller.logger.Log;

/**
 * The <code>AttributeGroup</code> class represents a group of atributes.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class AttributeGroup extends ParentSection implements Cloneable {

    /** The list of attributes in the group */
    private List<Attribute> attributeList;

    /**
     * Initializes a newly created <code>Attribute</code> with the specified name and description.
     * The <code>title</code> argument is the name of the attribute group. 
     * 
     * @param title
     *            a name of the attribute group.
     */
    public AttributeGroup(String title) {
       super(title);
    }
    
    public void setTitle(String title){
        this.title = title;
    }

    public Object clone() {
        AttributeGroup group = null;
        try {
            group = (AttributeGroup) super.clone();
            group.setTitle(this.title);

            List<Attribute> newAttributes = new ArrayList<Attribute>();
            for (int i = 0; i < attributeList.size(); i++) {
                newAttributes.add((Attribute) attributeList.get(i).clone());
            }
            group.setAttributeList(newAttributes);
        } catch (CloneNotSupportedException ex) {
            Log.error(ex);
        }
        return group;
    }

    public List<Attribute> getAttributeList() {
        return attributeList;
    }

    public void setAttributeList(List<Attribute> attributes) {
        this.attributeList = attributes;
    }

    /**
     * Clear values (sets default values) of all attribute types in the group.
     */
    public void clearValues() {
        for (Attribute attr : this.attributeList) {
            attr.clearValues();
        }
    }

    /**
     * Sets values of all attribute types in the group after their temporary values.
     */
    public void setValuesFromTemporary() {
        for (Attribute at : this.getAttributeList())
            at.setValuesFromTemporary();
    }
}
