package cz.zcu.fav.kiv.editor.displays;

import javax.swing.JPanel;

import cz.zcu.fav.kiv.editor.beans.parameters.Parameter;

/**
 * The <code>GraphicsFigure</code> class represents a parent for all graphics figures.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public abstract class GraphicsFigure extends JPanel {

    private static final long serialVersionUID = -6123711841424326935L;

    /**
     * Sets the list of parameter that are an input data source for the graphics figure.
     * 
     * @param parameterList
     */
    public abstract void setInputs(Parameter[] parameterList);
}
