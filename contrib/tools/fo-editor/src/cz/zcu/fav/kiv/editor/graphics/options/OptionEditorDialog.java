package cz.zcu.fav.kiv.editor.graphics.options;

import javax.swing.JPanel;

import cz.zcu.fav.kiv.editor.controller.options.OptionController;

/**
 * The <code>OptionEditorDialog</code>class is the dialog used for editing editor options.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class OptionEditorDialog extends OptionDialog {

    private static final long serialVersionUID = 7118079845557600112L;

    /** The editor option dialog */
    private EditorOptionForm editorOptionForm;

    /**
     * Creates and shows the dialog with editor options.
     */
    public static void showDialog() {
        dialog = new OptionEditorDialog();
        dialog.setVisible(true);
    }

    /**
     * Initializes a newly created <code>OptionEditorDialog</code> with its title.
     */
    public OptionEditorDialog() {
        super("frame.option.editor.title");
    }

    @Override
    protected JPanel createForm() {
        editorOptionForm = new EditorOptionForm();
        return editorOptionForm;
    }

    @Override
    protected void saveChanges() {
        editorOptionForm.saveChanges();
    }

    @Override
    protected void updateValues() {
        OptionController.setDefaultEditorOptions();
        editorOptionForm.updateValues();
    }

}
