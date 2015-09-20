package cz.zcu.fav.kiv.editor.graphics.components.editor;

import java.awt.Color;
import java.util.List;

import javax.swing.ImageIcon;
import javax.swing.JPanel;
import javax.swing.JTree;
import javax.swing.tree.DefaultMutableTreeNode;
import javax.swing.tree.DefaultTreeCellRenderer;
import javax.swing.tree.TreePath;
import javax.swing.tree.TreeSelectionModel;

import cz.zcu.fav.kiv.editor.beans.sections.Section;
import cz.zcu.fav.kiv.editor.beans.sections.Subsection;
import cz.zcu.fav.kiv.editor.graphics.images.EditorIcon;

/**
 * The <code>TreeMenu</code> class is the panel containing the tree menu of the editor.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class TreeMenu extends JPanel {

    private static final long serialVersionUID = 8347821460376344167L;

    /** The single instance of the panel with the tree menu */
    private static TreeMenu instance;

    /** The tree menu */
    private JTree tree;

    /** The list of tree nodes */
    private DefaultMutableTreeNode nodeList;

    /**
     * Singleton constructor - gets the single instance of the <code>TreeMenu</code> class.
     * 
     * @param editorBody
     *            the body of the editor.
     * @param sectionList
     *            the list of sections.
     * @return the single instance of the <code>TreeMenu</code>.
     */
    public static TreeMenu getInstance(EditorBody editorBody, List<Section> sectionList) {
        if (instance == null) {
            instance = new TreeMenu(editorBody, sectionList);
        }
        return instance;
    }

    /**
     * Initializes a newly created <code>TreeMenu</code> with the list of <en>Section</em>s with
     * parameters and the editor body which part the <code>TreeMenu</code> creates.
     * 
     * @param editorBody
     *            the body of the editor.
     * @param sectionList
     *            the list of sections.
     */
    public TreeMenu(EditorBody editorBody, List<Section> sectionList) {
        nodeList = createNodes(sectionList);
        tree = new JTree(nodeList);
        tree.getSelectionModel().setSelectionMode(TreeSelectionModel.SINGLE_TREE_SELECTION);

        // Listen for when the selection changes.
        tree.addTreeSelectionListener(new TreeSelectAction(editorBody));

        // leaf icon
        DefaultTreeCellRenderer renderer = (DefaultTreeCellRenderer) tree.getCellRenderer();
        ImageIcon leafIcon = EditorIcon.createTabIcon();
        renderer.setLeafIcon(leafIcon);

        // select leaf
        TreePath treePath = new TreePath(nodeList.getFirstLeaf().getPath());
        tree.setSelectionPath(treePath);

        tree.setRootVisible(false);
        this.add(tree);
        this.setBackground(Color.white);
    }

    /**
     * Creates the structure of tree nodes containing parameter sections.
     * 
     * @param sectionList
     *            the list of sections.
     * @return the root node of the tree menu.
     */
    private DefaultMutableTreeNode createNodes(List<Section> sectionList) {
        DefaultMutableTreeNode top = new DefaultMutableTreeNode();
        DefaultMutableTreeNode sectionNode = null;

        for (Section section : sectionList) {
            sectionNode = new DefaultMutableTreeNode(section.getTitle());
            top.add(sectionNode);
            // subsections
            for (Subsection subsection : section.getSubsectionList()) {
                sectionNode.add(new DefaultMutableTreeNode(new SubsectionSheet(subsection)));
            }
        }
        return top;
    }

    /**
     * Gets the section sheet belonging to the first tree node.
     * 
     * @return the section sheet belonging to the first tree node.
     */
    public SubsectionSheet getFirstSheet() {
        return (SubsectionSheet) nodeList.getFirstLeaf().getUserObject();
    }
}
