package cz.zcu.fav.kiv.editor.controller.errors;

/**
 * The <code>SaveFileException</code> class is used for reporting errors rised during saving XSL
 * stylesheet files.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class SaveFileException extends Throwable implements java.io.Serializable {

    private static final long serialVersionUID = 7020184336946762911L;

    /**
     * Initializes a newly created empty <code>SaveFileException</code> with the rised error.
     * 
     * @param t
     *            the rised error.
     */
    public SaveFileException(Throwable t) {
        super(t);
    }
}
