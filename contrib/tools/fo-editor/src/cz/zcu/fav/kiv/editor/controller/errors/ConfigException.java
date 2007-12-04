package cz.zcu.fav.kiv.editor.controller.errors;

import cz.zcu.fav.kiv.editor.controller.resource.ResourceController;

/**
 * The <code>ConfigException</code> class is used for reporting errors generated during loading configuration
 * files and templates.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class ConfigException extends Throwable implements java.io.Serializable {

    private static final long serialVersionUID = 7020184336946762911L;

    /**
     * Initializes a newly created empty <code>ConfigException</code>.
     */
    public ConfigException() {
        super();
    }

    /**
     * Initializes a newly created <code>ConfigException</code> with specified error messages and
     * error source file.
     * 
     * @param fileName
     *            the name of file where the error was generated.
     * @param message
     *            the error message.
     */
    public ConfigException(String fileName, String message) {
        super(ResourceController.getMessage("error.config_error", fileName) + "\n" + message);
    }
}
