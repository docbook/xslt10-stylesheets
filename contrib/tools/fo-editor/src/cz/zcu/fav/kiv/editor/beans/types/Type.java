package cz.zcu.fav.kiv.editor.beans.types;

import java.util.Map;
import java.util.Observable;

import cz.zcu.fav.kiv.editor.config.constants.TypeEnum;
import cz.zcu.fav.kiv.editor.controller.errors.ParserException;
import cz.zcu.fav.kiv.editor.controller.logger.Log;
import cz.zcu.fav.kiv.editor.utils.TagControl;

/**
 * The <code>Type</code> class represents a parent for types of all elements.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public abstract class Type extends Observable implements Cloneable {
    /** The name of the type */
    protected TypeEnum name;

    /** The default value of the type */
    protected DefaultType defaultValue;

    /** The value of the type */
    protected String value;

    /** The unit of the type */
    protected Unit unit;

    public void setUnit(Unit unit) {
        this.unit = unit;
    }

    /**
     * Initializes a newly created empty<code>Type</code>.
     */
    public Type() {
        defaultValue = new DefaultType();
    }
    
    public Type(TypeEnum name) {
        this.name = name;
        defaultValue = new DefaultType();
    }

    public void setDefaultValue(DefaultType defaultValue) {
        this.defaultValue = defaultValue;
    }

    public void setName(TypeEnum name) {
        this.name = name;
    }

    public String getValue() {
        return value;
    }

    /**
     * Sets the new value of the type with notifying of graphics items.    
     */
    public abstract void updateValue();
    

    /**
     * Sets the new value of the type without notifying of graphics items.
     * @param value a new value of the type.
     */
    public abstract void changeValue(String value);

    public Map<String, String> getValueList() {
        return defaultValue.getValueList();
    }

    public void setValueList(Map<String, String> values) {
        this.defaultValue.setValueList(values);
    }

    /**
     * Returns the key for input value it it is contained in the list of predefined values.
     * 
     * @param value
     *            a value of the searched value contained in the list of predefined values.
     * @return a key belonging to the input value contained in the list of predefined values.
     */
    public String getKeyFromValue(String value) {
        return defaultValue.getKeyFromValue(value);
    }

    public Object clone() {
        Type type = null;
        try {
            type = (Type) super.clone();
            type.setName(this.name);
            type.setDefaultValue((DefaultType)this.defaultValue.clone());
            type.setValue(this.value);
            if (this.unit != null)
                type.setUnit((Unit) this.unit.clone());
        } catch (CloneNotSupportedException ex) {
            Log.error(ex);
        }
        return type;
    }

    /**
     * Sets the <code>default value</code> of the type and its unit.
     */
    public void setDefault() {
        this.value = this.defaultValue.getDefaultValue();
        if (this.unit != null)
            this.unit.setDefault();
    }

    public Unit getUnit() {
        return unit;
    }

    public DefaultType getDefaultValue() {
        return defaultValue;
    }

    public TypeEnum getName() {
        return name;
    }
    
    /**
     * Assigns the new loaded value (from file, template).
     * @param value the new type value.
     * @throws ParserException if the value is invalid.
     */
    public void setLoadedValue(String value) throws ParserException {
        TagControl.controlSetTypeValue(this, value);
        updateValue();
    }

    public void setValue(String value) {
        this.value = value;
    }
    
    /**
     * Assigns the default value same as value.
     *
     */
    public void assignDefaultFromValue() {
        this.defaultValue.defaultValue = value;
        if (this.unit != null)
            this.unit.assignDefaultFromValue();
    }
    
    /**
     * Return the name of the owner element - parameter or attribute.
     *
     */
    public abstract String getOwnerName(); 
}


