package cz.zcu.fav.kiv.editor.beans.properties;

import java.util.List;

import cz.zcu.fav.kiv.editor.beans.types.Unit;

/**
 * The <code>UnitAttr</code> class represents a unit of attribute type.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class UnitAttr extends Unit {
    /** The temporary value of the attribute unit */
    protected String temporaryValue;

    /** The reference to the attribute of the unit */
    protected Attribute attribute;

    /**
     * Initializes a newly created <code>UnitAttr</code> with the specified value and predefined
     * units. The <code>value</code> argument is the value of the unit. The <code>unitList</code>
     * is a list of predefined units.
     * 
     * @param value
     *            a value of the unit.
     * @param unitList
     *            a list of predefined units.
     */
    public UnitAttr(String value, List<String> unitList) {
        super(value, unitList);
    }
    
    public UnitAttr(List<String> unitList) {
        super(unitList);
    }

    /**
     * Sets the new value of unit and marks its attribute as chosen.
     * 
     * @param value
     *            a new value of the unit.
     */
    public void changeValue(String value) {
        this.temporaryValue = value;
        this.attribute.setChosen();
    }

    /**
     * Sets the new temporary value of unit.
     */
    public void updateValue() {
        this.temporaryValue = this.value;
    }

    /**
     * Sets values of the unit after its temporary value.
     */
    public void setValuesFromTemporary() {
        if (temporaryValue != null)
            this.value = temporaryValue;
    }

    public void setAttribute(Attribute attribute) {
        this.attribute = attribute;
    }

    /**
     * Sets the <code>default and temporary value</code> of the unit.
     */
    public void setDefault() {
        super.setDefault();
        this.temporaryValue = this.defaultValue;
    }
}
