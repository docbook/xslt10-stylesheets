package cz.zcu.fav.kiv.editor.beans.properties;

import cz.zcu.fav.kiv.editor.beans.types.Type;

/**
 * The <code>TypeAttr</code> class represents a type of attribute.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class TypeAttr extends Type {
    /** The temporary value of the attribute type */
    private String temporaryValue;

    /** The reference to the attribute of the type */
    private Attribute attribute;

    /**
     * Initializes a newly created empty <code>TypeAttr</code>.
     */
    public TypeAttr() {
        super();
    }

    /**
     * Sets values of the type and its unit after their temporary values.
     */
    public void setValuesFromTemporary() {
        if (this.temporaryValue != null)
            this.value = this.temporaryValue;
        if (this.unit != null)
            ((UnitAttr) this.unit).setValuesFromTemporary();
    }

    /**
     * Sets the new value of the type (standard and temporary value) and marks the
     * <code>attribute</code> as chosen.
     * 
     * @param value
     *            a new value of the type.
     */
    @Override
    public void changeValue(String value) {
        this.temporaryValue = value;
        this.attribute.setChosen();
    }

    /**
     * Sets the new temporary value of the type.
     */
    @Override
    public void updateValue() {
        this.temporaryValue = this.value;
        if (unit != null)
            unit.updateValue();
    }

    public void setAttr(Attribute attr) {
        this.attribute = attr;
    }

    /**
     * Sets the <code>default and temporary value</code> of the type and its unit.
     */
    public void setDefault() {
        super.setDefault();
        this.temporaryValue = this.getDefaultValue().getDefaultValue();
    }

    @Override
    public String getOwnerName() {
        return attribute.getName();
    }
}
