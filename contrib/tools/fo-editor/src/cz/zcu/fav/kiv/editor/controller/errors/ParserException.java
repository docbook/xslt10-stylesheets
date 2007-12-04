package cz.zcu.fav.kiv.editor.controller.errors;

import cz.zcu.fav.kiv.editor.controller.resource.ResourceController;

/**
 * The <code>ParserException</code> class is used for reporting errors rised during parsing values
 * from input files.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class ParserException extends Throwable {

    private static final long serialVersionUID = 7020184336946762911L;

    /**
     * Initializes a newly created empty <code>ParserException</code>.
     */
    public ParserException() {
        super();
    }

    /**
     * Initializes a newly created empty <code>ParserException</code> with specified message.
     * 
     * @param message
     *            the message decribing the rised error.
     */
    public ParserException(String message) {
        super(ResourceController.getMessage("error.parser_error", message));
    }
}
