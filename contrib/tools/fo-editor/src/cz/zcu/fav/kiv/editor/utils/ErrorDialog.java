package cz.zcu.fav.kiv.editor.utils;

import javax.swing.JOptionPane;

import cz.zcu.fav.kiv.editor.controller.resource.ResourceController;
import cz.zcu.fav.kiv.editor.graphics.MainFrame;

/**
 * The <code>ErrorDialog</code> class displays the error dialog containing the description of the
 * application error.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class ErrorDialog {

    /**
     * Shows the error dialog with the description of the input error.
     * 
     * @param error
     *            the error to display in the error dialog.
     */
    public static void showDialog(Exception error) {
        JOptionPane.showMessageDialog(MainFrame.getInstance(), error.getStackTrace(),
                ResourceController.getMessage("error_dialog.title"), JOptionPane.ERROR_MESSAGE);
    }
}
