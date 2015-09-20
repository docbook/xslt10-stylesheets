package cz.zcu.fav.kiv.editor.beans.parameters;

import cz.zcu.fav.kiv.editor.beans.common.ParentParameter;

/**
 * The <code>Parameter</code> class represents an element parameter.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class Parameter extends ParentParameter {
    /** The type of the parameter */
    private TypeParam type;

    /**
     * Initializes a newly created <code>Parameter</code> with the specified name. Parameter is
     * marked as not chosen. The <code>name</code> argument is the name of the parameter.
     * 
     * @param name
     *            a name of the parameter.
     */
    
    public Parameter(String name, int lineNumber) {
        super(name, lineNumber);
        this.chosen = false;
        this.type = new TypeParam(this);
    }
    
    public Parameter(String name) {
        super(name);
        this.chosen = false;
        this.type = new TypeParam(this);
    }

    public TypeParam getType() {
        return type;
    }

    public void setType(TypeParam type) {
        this.type = type;
    }

    /**
     * Clear values (sets default values) of the parameter type and notify its observers.
     */
    public void clearValues() {
        this.getType().setDefault();
        super.clearValues();
    }

    /**
     * Update the value of the <code>Figure</code>s associated with the parameter.
     */
    public void updateFigure() {
        setChanged();
        notifyObservers();
    }

}
