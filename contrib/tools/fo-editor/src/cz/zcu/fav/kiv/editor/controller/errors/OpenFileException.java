package cz.zcu.fav.kiv.editor.controller.errors;

import cz.zcu.fav.kiv.editor.controller.resource.ResourceController;

/**
 * The <code>OpenFileException</code> class is used for reporting errors rised during opening XSL
 * stylesheet files.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class OpenFileException extends Throwable implements java.io.Serializable {

    private static final long serialVersionUID = 7020184336946762911L;

    /**
     * Initializes a newly created empty <code>OpenFileException</code>.
     */
    public OpenFileException() {
        super(ResourceController.getMessage("error.open_file.wrong_form"));
    }

    /**
     * Initializes a newly created empty <code>OpenFileException</code> with specified message.
     * 
     * @param message
     *            the message decribing the rised error.
     */
    public OpenFileException(String message) {
        super(ResourceController.getMessage("error.open_file.wrong_form") + message);
    }
}
