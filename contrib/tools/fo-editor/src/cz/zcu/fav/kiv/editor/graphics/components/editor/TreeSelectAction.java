package cz.zcu.fav.kiv.editor.graphics.components.editor;

import javax.swing.JTree;
import javax.swing.event.TreeSelectionEvent;
import javax.swing.event.TreeSelectionListener;
import javax.swing.tree.DefaultMutableTreeNode;

/**
 * The <code>TreeSelectAction</code> class represents the action performed when a leaf of tree
 * menu is selected. Displays the <em>SubsectionSheet</em> belonging to the selected leaf.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class TreeSelectAction implements TreeSelectionListener {

    /** The panel representing the editor body */
    private EditorBody editorBody;

    /**
     * Initializes a newly created <code>TreeSelectAction</code>.
     * 
     * @param editorBody
     *            the panel representing the editor body.
     */
    public TreeSelectAction(EditorBody editorBody) {
        this.editorBody = editorBody;
    }

    /**
     * Action performed when a tree node is selected. Displays the subsection sheet belonging to the
     * selected node.
     */
    public void valueChanged(TreeSelectionEvent selectEvent) {
        DefaultMutableTreeNode node = (DefaultMutableTreeNode) ((JTree) selectEvent.getSource())
                .getLastSelectedPathComponent();
        if (node.isLeaf()) {
            this.editorBody.setEditorSheet((SubsectionSheet) node.getUserObject());
        }
    }

}
