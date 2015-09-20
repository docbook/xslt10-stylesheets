package cz.zcu.fav.kiv.editor.graphics.utils;

import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;

import javax.swing.JDialog;
import javax.swing.JFrame;
import javax.swing.JOptionPane;

import cz.zcu.fav.kiv.editor.controller.resource.ResourceController;

/**
 * The <code>OverwriteFileDialog</code> class is the dialog used for asking the user if the chosen
 * file should be overwritten or not.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class OverwriteFileDialog {
    /** The dialog panel with options */
    private final JOptionPane optionPane;

    /** The single instance of the dialog */
    private static OverwriteFileDialog instance;

    /**
     * Shows the <code>OverwriteFileDialog</code> dialog with three options : yes, no and cancel.
     * 
     * @param frame
     *            the parent frame of the option dialog.
     * @return the single instance of the dialog.
     */
    public static OverwriteFileDialog showDialog(final JFrame frame) {
        instance = new OverwriteFileDialog(frame);
        return instance;
    }

    /**
     * Initializes and shows a newly created <code>OverwriteFileDialog</code> dialog with three
     * options : yes, no and cancel.
     * 
     * @param frame
     *            the parent frame of the option dialog.
     */
    private OverwriteFileDialog(JFrame frame) {
        optionPane = new JOptionPane(ResourceController
                .getMessage("save_file.dialog_file_exist.text"), JOptionPane.QUESTION_MESSAGE,
                JOptionPane.YES_NO_OPTION, null, new Object[] {
                        ResourceController.getMessage("button.yes"),
                        ResourceController.getMessage("button.cancel") }, ResourceController
                        .getMessage("button.yes"));
        final JDialog dialog = new JDialog(frame, ResourceController
                .getMessage("save_file.dialog_file_exist.title"), true);
        dialog.setContentPane(optionPane);
        dialog.setDefaultCloseOperation(JDialog.DO_NOTHING_ON_CLOSE);

        optionPane.addPropertyChangeListener(new PropertyChangeListener() {
            public void propertyChange(PropertyChangeEvent e) {
                String prop = e.getPropertyName();

                if (dialog.isVisible() && (e.getSource() == optionPane)
                        && (prop.equals(JOptionPane.VALUE_PROPERTY))) {
                    dialog.setVisible(false);
                }
            }
        });
        dialog.pack();
        dialog.setLocationRelativeTo(frame);
        dialog.setVisible(true);
    }

    /**
     * Gets the user answer chosen in the option dialog.
     * 
     * @return true if the user has chosen the option yes.
     */
    public boolean getAnswer() {
        String value = optionPane.getValue().toString();
        if (value.equals(ResourceController.getMessage("button.yes")))
            return true;
        else
            return false;
    }
}
