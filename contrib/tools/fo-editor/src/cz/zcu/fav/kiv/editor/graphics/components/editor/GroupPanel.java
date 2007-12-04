package cz.zcu.fav.kiv.editor.graphics.components.editor;

import javax.swing.BorderFactory;
import javax.swing.JPanel;
import javax.swing.SpringLayout;

import cz.zcu.fav.kiv.editor.beans.sections.Group;
import cz.zcu.fav.kiv.editor.controller.logger.Log;
import cz.zcu.fav.kiv.editor.displays.GraphicsFigure;
import cz.zcu.fav.kiv.editor.graphics.utils.SpringUtilities;

/**
 * The <code>GroupPanel</code> class is the panel containing the <em>Group</em> of parameters.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class GroupPanel extends JPanel {

    private static final long serialVersionUID = 6783432227893822418L;

    /** The size of vertical title margin */
    private static final int VERTICAL_MARGIN_TITLE = 0;

    /** The size of horizontal title margin */
    private static final int HORIZONTAL_MARGIN_TITLE = 10;

    /** The size of vertical margin of empty title */
    private static final int VERTICAL_MARGIN_EMPTY_TITLE = 5;

    /** The size of margin of components in the group panel */
    private static final int COMPONENT_MARGIN = 3;

    /** The number of rows in the group panel */
    private static final int ROW = 1;

    /**
     * Initializes a newly created <code>SubsectionSheet</code> with the group.
     * 
     * @param group
     *            the group with parameters.
     */
    public GroupPanel(Group group) {
        if (group.getTitle() != null)
            this.setBorder(BorderFactory.createCompoundBorder(BorderFactory.createEmptyBorder(
                    VERTICAL_MARGIN_TITLE, HORIZONTAL_MARGIN_TITLE, VERTICAL_MARGIN_TITLE,
                    HORIZONTAL_MARGIN_TITLE), BorderFactory.createTitledBorder(group.getTitle())));
        else
            this.setBorder(BorderFactory.createEmptyBorder(VERTICAL_MARGIN_EMPTY_TITLE,
                    HORIZONTAL_MARGIN_TITLE, VERTICAL_MARGIN_EMPTY_TITLE, HORIZONTAL_MARGIN_TITLE));

        int componentCount = 1;

        this.setLayout(new SpringLayout());

        this.add(new GroupItemsPanel(group.getElementList()));

        if (group.getFigure() != null)
            try {
                GraphicsFigure graphicsFigure = (GraphicsFigure) Class.forName(
                        group.getFigure().getClassName()).newInstance();
                graphicsFigure.setInputs(group.getFigure().getParameterList());
                this.add(graphicsFigure);
                componentCount++;
            } catch (Exception ex) {
                Log.error(ex);
            }

        SpringUtilities.makeCompactGrid(this, ROW, componentCount, COMPONENT_MARGIN,
                COMPONENT_MARGIN, COMPONENT_MARGIN, COMPONENT_MARGIN);
    }
}
