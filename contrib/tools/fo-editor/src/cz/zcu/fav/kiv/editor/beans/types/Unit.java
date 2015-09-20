package cz.zcu.fav.kiv.editor.beans.types;

import java.util.List;
import java.util.Observable;

import cz.zcu.fav.kiv.editor.controller.logger.Log;

/**
 * The <code>Unit</code> class represents a parent for unit of elements.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public abstract class Unit extends Observable implements Cloneable {
    /** The value of the unit */
    protected String value;

    /** The default value of the unit */
    protected String defaultValue;

    /** The list of predefined values of the unit */
    protected List<String> valueList;

    /**
     * Initializes a newly created <code>Unit</code> with the specified value and predefined
     * units. The <code>value</code> argument is the value of the unit. The <code>unitList</code>
     * is a list of predefined units.
     * 
     * @param value
     *            a value of the unit.
     * @param unitList
     *            a list of predefined units.
     */
    public Unit(String value, List<String> unitList) {
        this.value = value;
        this.defaultValue = value;
        this.valueList = unitList;
    }

    public Unit(List<String> unitList) {
        this.valueList = unitList;
        this.value = "";
        this.defaultValue = "";
    }

    public String getDefaultValue() {
        return defaultValue;
    }

    public void setDefaultValue(String defaultValue) {
        this.defaultValue = defaultValue;
    }

    /**
     * Sets the default value of the unit - assignes the default value to the main value.
     */
    public void setDefault() {
        this.value = defaultValue;
    }

    public String getValue() {
        return value;
    }

    public abstract void updateValue();

    public abstract void changeValue(String value);

    public Object clone() {
        Unit unit = null;
        try {
            unit = (Unit) super.clone();
            unit.setValue(this.value);
            unit.setDefaultValue(this.defaultValue);
        } catch (CloneNotSupportedException ex) {
            Log.error(ex);
        }
        return unit;
    }

    /**
     * Assigns the default value from value.
     */
    public void assignDefaultFromValue() {
        this.defaultValue = this.value;
    }

    public List<String> getValueList() {
        return valueList;
    }

    public void setValueList(List<String> values) {
        this.valueList = values;
    }

    public void setValue(String value) {
        this.value = value;
    }

}
