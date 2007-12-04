package cz.zcu.fav.kiv.editor.graphics.components.editor;

import java.awt.BorderLayout;
import java.awt.Dimension;
import java.util.List;

import javax.swing.BorderFactory;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JSplitPane;
import javax.swing.plaf.basic.BasicSplitPaneUI;

import cz.zcu.fav.kiv.editor.beans.sections.Section;
import cz.zcu.fav.kiv.editor.graphics.console.MessageConsole;

/**
 * The <code>EditorBody</code> class represents the body of the editor.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class EditorBody extends JPanel {

    private static final long serialVersionUID = 6221409996382853643L;

    /** The size of vertical panel margin */
    private static final int MARGIN_VERTICAL = 3;

    /** The size of horizontal panel margin */
    private static final int MARGIN_HORIZONTAL = 5;

    /** The height of the top part of the panel */
    private static final int PANEL_TOP_HEIGHT = 500;

    /** The width of the tree menu of the panel */
    private static final int PANEL_TREE_WIDTH = 200;

    /** The height of the panel */
    private static final int PANEL_HEIGHT = 600;

    /** The width of the panel */
    public static final int PANEL_WIDTH = 820;

    /** The split pane of the editor */
    private JSplitPane splitPaneTop;

    /**
     * Initializes a newly created <code>EditorBody</code> with the list of <en>Section</em>s
     * with parameters.
     * 
     * @param sectionList
     *            the list of sections with parameters.
     */
    public EditorBody(List<Section> sectionList) {
        this.setLayout(new BorderLayout(MARGIN_VERTICAL, MARGIN_HORIZONTAL));

        // split tree menu x right panel
        splitPaneTop = new JSplitPane(JSplitPane.HORIZONTAL_SPLIT);
        splitPaneTop.setDividerLocation(PANEL_TREE_WIDTH);
        splitPaneTop.setBorder(null);
        ((BasicSplitPaneUI) splitPaneTop.getUI()).getDivider().setBorder(
                BorderFactory.createEmptyBorder());

        // tree menu
        TreeMenu treeMenu = TreeMenu.getInstance(this, sectionList);
        JScrollPane treeView = new JScrollPane(treeMenu);
        treeView.setPreferredSize(new Dimension(PANEL_TREE_WIDTH, PANEL_TOP_HEIGHT));
        treeView.setBorder(null);
        splitPaneTop.setLeftComponent(treeView);

        // right panel
        splitPaneTop.setRightComponent(treeMenu.getFirstSheet());

        // split console x top panel
        JSplitPane splitPane = new JSplitPane(JSplitPane.VERTICAL_SPLIT);
        splitPane.setBorder(null);
        ((BasicSplitPaneUI) splitPane.getUI()).getDivider().setBorder(
                BorderFactory.createEmptyBorder());
        splitPane.setTopComponent(splitPaneTop);
        splitPane.setBottomComponent(MessageConsole.getInstance());
        splitPane.setDividerLocation(PANEL_TOP_HEIGHT);

        add(splitPane, BorderLayout.CENTER);

        this.setPreferredSize(new Dimension(PANEL_WIDTH, PANEL_HEIGHT));
    }

    /**
     * Changes the right panel of the editor body to the actually selected panel.
     * 
     * @param panel
     *            the new selected panel.
     */
    public void setEditorSheet(JPanel panel) {
        splitPaneTop.setRightComponent(panel);
    }
}