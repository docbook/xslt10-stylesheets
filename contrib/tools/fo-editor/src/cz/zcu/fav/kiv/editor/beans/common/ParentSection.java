package cz.zcu.fav.kiv.editor.beans.common;

/**
 * The <code>ParentSection</code> class represents a parent for all 
 * classes representing a group of items.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class ParentSection {
    /** The title of the group  */
    protected String title;

    /**
     * Initializes a newly created <code>ParentSection</code> with
     * the specified name. The <code>title</code> argument is the
     * title of the group.
     *
     * @param   title   a title of the group.
     */
    public ParentSection(String title) {
        this.title = title;
    }

    public String getTitle() {
        return title;
    }
}
