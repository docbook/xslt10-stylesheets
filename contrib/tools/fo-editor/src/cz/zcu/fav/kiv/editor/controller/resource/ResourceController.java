package cz.zcu.fav.kiv.editor.controller.resource;

import java.io.UnsupportedEncodingException;
import java.text.MessageFormat;
import java.util.Enumeration;
import java.util.PropertyResourceBundle;
import java.util.ResourceBundle;

import cz.zcu.fav.kiv.editor.controller.logger.Log;
import cz.zcu.fav.kiv.editor.controller.options.OptionItems;

/**
 * The <code>ResourceController</code> class contains methods for loading text resources.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class ResourceController {

    /** The bundle of text resources */
    private static ResourceBundle resource;

    /** The instance of the <code>ResourceController</code> class */
    private static ResourceController instance;

    /**
     * Singleton constructor - gets the instance of the <code>ResourceController</code> class.
     * 
     * @return the instance of the <code>ResourceController</code> class.
     */
    private static ResourceController getInstance() {
        if (instance == null)
            instance = new ResourceController();
        return instance;
    }

    /**
     * Changes the loaded resource bundle to the new bundle for actully chosen editor language.
     */
    public static void changeInstance() {
        instance = new ResourceController();
    }

    /**
     * Initializes a newly created <code>ResourceController</code> with resource bundle for actual
     * editor language.
     */
    private ResourceController() {
        ResourceController.resource = ResourceBundle.getBundle(ResourceConst.TEXT_RESOURCE_PATH,
                OptionItems.LANGUAGE);
        ResourceController.resource = createUtf8PropertyResourceBundle(ResourceController.resource);
    }

    /**
     * Gets the text resource of the actual language for the input key.
     * 
     * @param key
     *            the key of the text resource.
     * @return the text resource for the input key.
     */
    private String getString(String key) {
        return resource.getString(key);
    }

    /**
     * Gets the text resource of the actual language for the input key.
     * 
     * @param key
     *            the key of the text resource.
     * @return the text resource for the input key.
     */
    public static String getMessage(String key) {
        try {
            return ResourceController.getInstance().getString(key);
        } catch (Exception ex) {
            Log.warn("error.resource_controller.missing_key", ex, key);
            return key;
        }
    }

    /**
     * Gets the text resource of the actual language for the input key and arguments.
     * 
     * @param key
     *            the key of the text resource.
     * @param args
     *            the arguments of the text resource.
     * @return the text resource for the input key and arguments.
     */
    public static String getMessage(String key, Object... args) {
        try {
            MessageFormat format = new MessageFormat(ResourceController.getInstance()
                    .getString(key).replaceAll("'", "''"), OptionItems.LANGUAGE);
            return format.format(args);
        } catch (Exception ex) {
            Log.warn("error.resource_controller.missing_key", ex, key);
            return key;
        }
    }

    /**
     * Convert the input resource bundle to the UTF-8 resource bundle.
     * 
     * @param bundle
     *            the resource bundle.
     * @return the UTF-8 resource bundle converted from the input resource bundle.
     */
    private static ResourceBundle createUtf8PropertyResourceBundle(ResourceBundle bundle) {
        if (!(bundle instanceof PropertyResourceBundle))
            return bundle;

        return new Utf8PropertyResourceBundle((PropertyResourceBundle) bundle);
    }

    /**
     * The <code>Utf8PropertyResourceBundle</code> class define resource bundle that converts text
     * resources from ISO-8859-1 to UTF-8 encoding.
     * 
     * @author Marta Vaclavikova
     * @version 1.0, 05/2007
     */
    private static class Utf8PropertyResourceBundle extends ResourceBundle {
        /** The property resource bundle */
        PropertyResourceBundle bundle;

        /**
         * Initializes a newly created <code>Utf8PropertyResourceBundle</code> with define
         * property resource bundle.
         * 
         * @param bundle
         *            the property resource bundle.
         */
        private Utf8PropertyResourceBundle(PropertyResourceBundle bundle) {
            this.bundle = bundle;
        }

        @Override
        public Enumeration<String> getKeys() {
            return bundle.getKeys();
        }

        @Override
        protected Object handleGetObject(String key) {
            String value = (String) bundle.handleGetObject(key);
            try {
                return new String(value.getBytes("ISO-8859-1"), "UTF-8");
            } catch (UnsupportedEncodingException ex) {
                Log.warn(ex);
                return null;
            }
        }
    }
}
