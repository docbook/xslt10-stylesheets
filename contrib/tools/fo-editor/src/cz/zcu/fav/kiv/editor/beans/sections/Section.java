package cz.zcu.fav.kiv.editor.beans.sections;

import java.util.List;

import cz.zcu.fav.kiv.editor.beans.common.ParentSection;

/**
 * The <code>Section</code> class represents a section of editor. It contains a list of
 * <code>Subsection</code>s.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class Section extends ParentSection {
    /** The list of subsections in the section */
    private List<Subsection> subsectionList;

    /**
     * Initializes a newly created <code>Section</code> with the specified name. The
     * <code>title</code> argument is the title of the section.
     * 
     * @param title
     *            a title of the section.
     */
    public Section(String title) {
        super(title);
    }

    public List<Subsection> getSubsectionList() {
        return subsectionList;
    }

    public void setSubsectionList(List<Subsection> subsectionList) {
        this.subsectionList = subsectionList;
    }

    /**
     * Clear values (sets default values) of all subsections.
     */
    public void clearValues() {
        for (Subsection subsection : subsectionList) {
            subsection.clearValues();
            subsection.setComment(null);
        }
    }
}
