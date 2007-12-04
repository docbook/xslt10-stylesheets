package cz.zcu.fav.kiv.editor.graphics.options;

import javax.swing.JPanel;

import cz.zcu.fav.kiv.editor.controller.options.OptionController;

/**
 * The <code>OptionStylesheetDialog</code>class is the dialog used for editing stylesheet
 * options.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class OptionStylesheetDialog extends OptionDialog {

    private static final long serialVersionUID = 7118079159557600112L;

    /** The stylesheet option dialog */
    private StylesheetOptionForm stylesheetOptionForm;

    /**
     * Shows the dialog with stylesheet options.
     */
    public static void showDialog() {
        dialog = new OptionStylesheetDialog();
        dialog.setVisible(true);
    }

    /**
     * Initializes a newly created <code>OptionStylesheetDialog</code> with its title.
     */
    public OptionStylesheetDialog() {
        super("frame.option.save.title");
    }

    @Override
    protected JPanel createForm() {
        stylesheetOptionForm = new StylesheetOptionForm();
        return stylesheetOptionForm;
    }

    @Override
    protected void saveChanges() {
        stylesheetOptionForm.saveChanges();
    }

    @Override
    protected void updateValues() {
        OptionController.setDefaultStylesheetOptions();
        stylesheetOptionForm.updateValues();
    }

}
