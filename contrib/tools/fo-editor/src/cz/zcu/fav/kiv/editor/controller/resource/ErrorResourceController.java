package cz.zcu.fav.kiv.editor.controller.resource;

import java.text.MessageFormat;
import java.util.ResourceBundle;

import cz.zcu.fav.kiv.editor.controller.logger.Log;

/**
 * The <code>ErrorResourceController</code> class contains methods for loading error text
 * resources.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class ErrorResourceController {

    /** The bundle of text resources */
    private ResourceBundle resource;

    /** The instance of the <code>ErrorResourceController</code> class */
    private static ErrorResourceController instance;

    /**
     * Singleton constructor - gets the single instance of the <code>ErrorResourceController</code> class.
     * 
     * @return the instance of the <code>ErrorResourceController</code> class.
     */
    private static ErrorResourceController getInstance() {
        if (instance == null)
            instance = new ErrorResourceController();
        return instance;
    }

    /**
     * Initializes a newly created <code>ErrorResourceController</code> with error resource
     * bundle.
     */
    public ErrorResourceController() {
        this.resource = ResourceBundle.getBundle(ResourceConst.ERROR_RESOURCE_PATH);
    }

    /**
     * Gets the error text resource for the input key.
     * 
     * @param key
     *            the key of the error text resource.
     * @return the error text resource for the input key.
     */
    private String getString(String key) {
        return resource.getString(key);
    }

    /**
     * Gets the error text resource for the input key.
     * 
     * @param key
     *            the key of the error text resource.
     * @return the error text resource for the input key.
     */
    public static String getMessage(String key) {
        try {
            return ErrorResourceController.getInstance().getString(key);
        } catch (Exception ex) {
            Log.warn(ex);
            return key;
        }
    }

    /**
     * Gets the error text resource for the input key and arguments.
     * 
     * @param key
     *            the key of the error text resource.
     * @param args
     *            the arguments of the error text resource.
     * @return the error text resource for the input key and arguments.
     */
    public static String getMessage(String key, Object... args) {
        try {
            MessageFormat format = new MessageFormat(ErrorResourceController.getInstance()
                    .getString(key).replaceAll("'", "''"));
            return format.format(args);
        } catch (Exception ex) {
            Log.warn(ex);
            return key;
        }
    }
}
