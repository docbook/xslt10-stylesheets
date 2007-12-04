package cz.zcu.fav.kiv.editor.beans.common;

import java.util.Observable;

import org.w3c.dom.Node;

/**
 * The <code>GeneralElement</code> class represents a parent common for all elements like
 * <code>Parameter</code>, <code>Property</code> or <code>Attribute</code>.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class GeneralElement extends Observable {
    /** The name of the element */
    protected String name;

    /** The node associated with the element */
    protected Node node;

    /**
     * Initializes a newly created empty<code>GeneralElement</code>.
     */
    public GeneralElement() {
    }

    /**
     * Initializes a newly created empty<code>GeneralElement</code> with the specified name. The
     * <code>name</code> argument is the name of the element.
     * 
     * @param name
     *            a name of the element.
     */
    public GeneralElement(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Node getNode() {
        return node;
    }

    public void setNode(Node node) {
        this.node = node;
    }

    public boolean equals(Object obj) {
        return ((GeneralElement) obj).getName().equals(this.getName());
    }
}
