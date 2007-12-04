package cz.zcu.fav.kiv.editor.controller.errors;

import cz.zcu.fav.kiv.editor.controller.resource.ResourceController;

/**
 * The <code>FileNotFoundException</code> class is used when a configuration file, templates or
 * their XML schema is missing.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class FileNotFoundException extends Throwable implements java.io.Serializable {

    private static final long serialVersionUID = -4128798341326945960L;

    /**
     * Initializes a newly created <code>FileNotFoundException</code> with missing file.
     * 
     * @param fileName
     *            the name of the missing file.
     */
    public FileNotFoundException(String fileName) {
        super(ResourceController.getMessage("error.file_not_found.file", fileName));
    }

    /**
     * Initializes a newly created empty <code>FileNotFoundException</code>.
     */
    public FileNotFoundException() {
        super(ResourceController.getMessage("error.file_not_found.dir"));
    }

    /**
     * Initializes a newly created empty <code>FileNotFoundException</code> with the rised error.
     * 
     * @param t
     *            the rised error.
     */
    public FileNotFoundException(Throwable t) {
        super(t.getMessage(), t);
    }
}
