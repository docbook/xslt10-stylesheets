package cz.zcu.fav.kiv.editor.beans.graphics;

import cz.zcu.fav.kiv.editor.beans.parameters.Parameter;

/**
 * The <code>Figure</code> class represents a graphics figure used for illustrating values of some
 * parameters.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class Figure {
    /** The name of the figure */
    private String name;

    /** The class name asociated with the figure */
    private String className;

    /** The list of parameters associated with the figure */
    private Parameter[] parameterList;

    public Figure(String name) {
        this.name = name;
    }    

    public String getClassName() {
        return className;
    }

    public String getName() {
        return name;
    }

    public Parameter[] getParameterList() {
        return parameterList;
    }

    public void setParameterList(Parameter[] parameters) {
        this.parameterList = parameters;
    }

    public boolean equals(Object obj) {
        return ((Figure) obj).getName().equals(this.getName());
    }

    public void setClassName(String className) {
        this.className = className;
    }
}
