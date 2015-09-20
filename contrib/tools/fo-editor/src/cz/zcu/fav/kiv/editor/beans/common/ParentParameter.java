package cz.zcu.fav.kiv.editor.beans.common;

/**
 * The <code>ParentParameter</code> class represents a parent common for all elements like
 * <code>Parameter</code> or <code>Property</code>.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class ParentParameter extends GeneralElement implements Comparable {
    /** The description of the element */
    protected String description;

    /** The purpose of the element */
    protected String purpose;

    /** The flag specifying whether the element is chosen or not */
    protected boolean chosen;
    
    protected int lineNumber;

    /**
     * Initializes a newly created empty<code>ParentParameter</code>.
     */
    public ParentParameter() {
    }

    /**
     * Initializes a newly created empty<code>ParentParameter</code> with the specified name. The
     * <code>name</code> argument is the name of the element.
     * 
     * @param name
     *            a name of the element.
     */
    public ParentParameter(String name) {
        this.name = name;
    }
    
    public ParentParameter(String name, int lineNumber) {
        this.name = name;
        this.lineNumber = lineNumber;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getPurpose() {
        return purpose;
    }

    public void setPurpose(String purpose) {
        this.purpose = purpose;
    }

    /**
     * Clear values (sets default values) of the element
     * and notifies its observers.
     */
    public void clearValues() {
        setNode(null);
        this.chosen = false;
        setChanged();
        notifyObservers(false);
    }

    public Boolean isChosen() {
        return chosen;
    }

    public void setChosen(Boolean isChosen) {
        this.chosen = isChosen;
    }

    /**
     * Choses the element - sets the flag chosen to true.
     * At the same time notifies its observers.
     */
    public void setChosen() {
        this.chosen = true;
        setChanged();
        notifyObservers(true);
    }

    public int compareTo(Object obj) {
        return ((GeneralElement) obj).getName().compareTo(this.getName());
    }

    public int getLineNumber() {
        return lineNumber;
    }
}
