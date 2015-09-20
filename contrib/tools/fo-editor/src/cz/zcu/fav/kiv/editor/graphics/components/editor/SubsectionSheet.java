package cz.zcu.fav.kiv.editor.graphics.components.editor;

import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.Font;

import javax.swing.Box;
import javax.swing.BoxLayout;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JSeparator;

import cz.zcu.fav.kiv.editor.beans.sections.Group;
import cz.zcu.fav.kiv.editor.beans.sections.Subsection;
import cz.zcu.fav.kiv.editor.graphics.utils.GridLayoutUtilities;

/**
 * The <code>SubsectionSheet</code> class is the panel containing groups of parameters, that
 * belongs to the <em>Subsection</em>.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class SubsectionSheet extends JPanel {

    private static final long serialVersionUID = -1940480099930144654L;

    /** The name of the sheet section */
    private String name;

    /** The number of sheet columns */
    private static int COLUMN = 1;

    /** The size of the sheet horizontal margin */
    private static final int MARGIN_HORIZONTAL = 0;

    /** The size of the sheet vertical margin */
    private static final int MARGIN_VERTICAL = 5;

    /** The size of the font used for sheet title */
    private static final int TITLE_FONT = 13;

    /**
     * Initializes a newly created <code>SubsectionSheet</code> with the subsection.
     * 
     * @param subsection
     *            the subsection with groups of parameters.
     */
    public SubsectionSheet(Subsection subsection) {
        this.name = subsection.getTitle();
        this.setLayout(new BorderLayout());

        // top with title
        JPanel topPanel = new JPanel();
        topPanel.setLayout(new BoxLayout(topPanel, BoxLayout.Y_AXIS));
        topPanel.add(Box.createRigidArea(new Dimension(MARGIN_HORIZONTAL, MARGIN_VERTICAL)));

        JLabel titleLabel = new JLabel(name, JLabel.LEFT);
        titleLabel.setFont(new Font("Sans-Serif", Font.BOLD, TITLE_FONT));
        topPanel.add(titleLabel);

        topPanel.add(Box.createRigidArea(new Dimension(MARGIN_HORIZONTAL, MARGIN_VERTICAL)));
        topPanel.add(new JSeparator(JSeparator.HORIZONTAL));
        topPanel.add(Box.createRigidArea(new Dimension(MARGIN_HORIZONTAL, 2 * MARGIN_VERTICAL)));
        this.add(topPanel, BorderLayout.PAGE_START);

        // panel with parameters
        JPanel groupPanel = new JPanel();
        groupPanel.setLayout(new GridLayoutUtilities(subsection.getGroupList().size(), COLUMN));

        for (Group group : subsection.getGroupList()) {
            groupPanel.add(new GroupPanel(group));
        }
        JScrollPane sheetPanel = new JScrollPane(groupPanel,
                JScrollPane.VERTICAL_SCROLLBAR_AS_NEEDED, JScrollPane.HORIZONTAL_SCROLLBAR_NEVER);
        sheetPanel.setBorder(null);
        this.add(sheetPanel, BorderLayout.CENTER);
    }

    /**
     * Returns the name of the sheet section.
     */
    public String toString() {
        return name;
    }

}
