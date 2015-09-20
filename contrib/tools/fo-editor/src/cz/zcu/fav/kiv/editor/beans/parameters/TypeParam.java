package cz.zcu.fav.kiv.editor.beans.parameters;

import cz.zcu.fav.kiv.editor.beans.types.Type;

/**
 * The <code>TypeParam</code> class represents a type of parameter.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class TypeParam extends Type {

    /** The reference to the parametet of the type */
    private Parameter parameter;

    /**
     * Initializes a newly created <code>TypeParam</code> with reference to the appropriate
     * parameter.
     * 
     * @param param
     *            a reference to the type parameter.
     */
    public TypeParam(Parameter param) {
        super();
        this.parameter = param;
    }

    /**
     * Sets the new value of the type, marks the <code>parameter</code> as chosen and update
     * parameter graphics figures.
     * 
     * @param value
     *            a new value of the type.
     */
    @Override
    public void changeValue(String value) {
        this.value = value;
        parameter.setChosen();
        parameter.updateFigure();
    }

    /**
     * Sets the new value of the type and notifies its observers.
     */
    @Override
    public void updateValue() {
        setChanged();
        notifyObservers(this.value);
        if (unit != null)
            unit.updateValue();
    }

    /**
     * Sets the <code>default value</code> of the type and its unit. Notifies its observers.
     */
    public void setDefault() {
        super.setDefault();
        setChanged();
        notifyObservers(value);
    }

    @Override
    public String getOwnerName() {        
        return parameter.getName();
    }
}
