package cz.zcu.fav.kiv.editor.beans.sections;

import java.util.List;

import org.w3c.dom.Comment;

import cz.zcu.fav.kiv.editor.beans.common.ParentSection;

/**
 * The <code>Subsection</code> class represents a subsection of a <code>Section</code>. It
 * contains a list of <code>Group</code>s.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class Subsection extends ParentSection {
    /** The list of group in the subsection */
    private List<Group> groupList;
    
    /** The comment associated with the subsection */
    private Comment comment;

    /**
     * Initializes a newly created <code>Subsection</code> with the specified name. The
     * <code>title</code> argument is the title of the subsection.
     * 
     * @param title
     *            a title of the subsection.
     */
    public Subsection(String title) {
        super(title);
    }

    public List<Group> getGroupList() {
        return groupList;
    }

    public void setGroupList(List<Group> groupList) {
        this.groupList = groupList;
    }

    /**
     * Clear values (sets default values) of all groups.
     */
    public void clearValues() {
        for (Group group : groupList)
            group.clearValues();
    }

    public Comment getComment() {
        return comment;
    }

    public void setComment(Comment comment) {
        this.comment = comment;
    }
}
