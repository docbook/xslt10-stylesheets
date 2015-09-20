package cz.zcu.fav.kiv.editor.beans.sections;

import java.util.List;

import cz.zcu.fav.kiv.editor.beans.common.ParentParameter;
import cz.zcu.fav.kiv.editor.beans.common.ParentSection;
import cz.zcu.fav.kiv.editor.beans.graphics.Figure;
import cz.zcu.fav.kiv.editor.beans.parameters.Parameter;
import cz.zcu.fav.kiv.editor.beans.properties.Property;

/**
 * The <code>Group</code> class represents a group of parameters and properties.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class Group extends ParentSection {
    /** The graphics figure defined for parameters in the group */
    private Figure figure;

    /** The list of parameters and properties in the group */
    private List<ParentParameter> elementList;

    /**
     * Initializes a newly created <code>Group</code> with the specified name. The
     * <code>title</code> argument is the title of the group.
     * 
     * @param title
     *            a title of the group.
     */
    public Group(String title) {
        super(title);
    }

    /**
     * Clear values (sets default values) of all parameters and properties.
     */
    public void clearValues() {
        for (ParentParameter elem : this.elementList) {
            if (elem instanceof Property)
                ((Property) elem).clearValues();
            if (elem instanceof Parameter)
                ((Parameter) elem).clearValues();
        }
    }

    public List<ParentParameter> getElementList() {
        return elementList;
    }

    public void setElementList(List<ParentParameter> parameterList) {
        this.elementList = parameterList;
    }

    public Figure getFigure() {
        return figure;
    }

    public void setFigure(Figure figure) {
        this.figure = figure;
    }
}
