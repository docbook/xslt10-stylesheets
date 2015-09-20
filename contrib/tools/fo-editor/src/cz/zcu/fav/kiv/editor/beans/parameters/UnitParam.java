package cz.zcu.fav.kiv.editor.beans.parameters;

import java.util.List;

import cz.zcu.fav.kiv.editor.beans.types.Unit;

/**
 * The <code>UnitParam</code> class represents a unit of parameter type.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class UnitParam extends Unit {
    /** The reference to the parametet of the unit */
    private Parameter parameter;

    /**
     * Initializes a newly created <code>UnitParam</code> with the specified value, predefined
     * units and reference to the appropriate parameter. The <code>value</code> argument is the
     * value of the unit. The <code>unitList</code> is a list of predefined units. The
     * <code>parameter</code> argument is an appropriate parameter.
     * 
     * @param value
     *            a value of the unit.
     * @param unitList
     *            a list of predefined units.
     * @param parameter
     *            a reference to the unit parameter.
     */
    public UnitParam(String value, List<String> unitList, Parameter parameter) {
        super(value, unitList);
        this.parameter = parameter;
    }
    
    public UnitParam(List<String> unitList, Parameter parameter) {
        super(unitList);
        this.parameter = parameter;
    }

    /**
     * Sets the new value of unit and notifies its observers.
     */
    @Override
    public void updateValue() {
        setChanged();
        notifyObservers(value);
    }

    /**
     * Sets the new value of unit and marks its parameter as chosen.
     * 
     * @param value
     *            a new value of the unit.
     */
    @Override
    public void changeValue(String value) {
        this.value = value;
        parameter.setChosen();
    }
    
    /**
     * Sets the default value of the unit - assignes the default value to the main value and notifies its observers.     
     */
    public void setDefault() {
      super.setDefault();
        setChanged();
        notifyObservers(value);
    }
}
