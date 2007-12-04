package cz.zcu.fav.kiv.editor.beans.properties;

import cz.zcu.fav.kiv.editor.beans.common.GeneralElement;
import cz.zcu.fav.kiv.editor.controller.logger.Log;

/**
 * The <code>Attribute</code> class represents an atribute of property.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class Attribute extends GeneralElement implements Cloneable {
    /** The list of attribute types */
    private TypeAttr type;

    /** The flag specifying whether the attribute is chosen or not */
    private boolean chosen;

    /** The temporary value of the attribute */
    private boolean temporaryChosen;

    public Attribute(String name) {
        this.name = name;
    }

    /**
     * Initializes a newly created <code>Attribute</code> with the specified name and the
     * type. Marks the attribute as not chosen. The <code>name</code> argument is the name of the
     * attribute. The <code>type</code> argument is the type of attribute.
     * 
     * @param name
     *            a name of attribute.
     * @param type
     *            a type of attribute.
     */
    public Attribute(String name, TypeAttr type) {
        super(name);
        this.type = type;
        this.chosen = false;
    }

    public Boolean isChosen() {
        return chosen;
    }

    /**
     * Sets the attribute <code>chosen</code> parameter according the input argument and assignes
     * the value to the <code>temporaryChosen</code>.
     * 
     * @param isChosen
     *            a value specifying whether the attribute is chosen or not.
     */
    public void setChosen(Boolean isChosen) {
        this.chosen = isChosen;
        this.temporaryChosen = isChosen;
    }

    public void setChosen() {
        this.temporaryChosen = true;
        setChanged();
        notifyObservers(true);
    }

    /**
     * Sets the <code>temporaryChosen</code> parameter according the input argument.
     * 
     * @param isChosen
     *            a value specifying whether the attribute is chosen or not.
     */
    public void changeChosen(Boolean isChosen) {
        this.temporaryChosen = isChosen;
    }

    public Object clone() {
        Attribute attribute = null;
        try {
            attribute = (Attribute) super.clone();
            attribute.setName(this.name);

            attribute.setType((TypeAttr)this.type.clone());
        } catch (CloneNotSupportedException ex) {
            Log.error(ex);
        }
        return attribute;
    }

    /**
     * Clear values (sets default values) of the attribute types.
     */
    public void clearValues() {
        type.setDefault();
        this.chosen = false;
        this.node = null;
    }

    /**
     * Sets values of all types after their temporary values. Sets <code>chosen</code> after
     * <code>temporaryChosen</code>.
     */
    public void setValuesFromTemporary() {
        type.setValuesFromTemporary();
        this.chosen = temporaryChosen;
    }

    public void setType(TypeAttr type) {
        this.type = type;
    }

    public TypeAttr getType() {
        return type;
    }
}
