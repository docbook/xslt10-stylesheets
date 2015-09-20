package cz.zcu.fav.kiv.editor.controller.options;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.util.Locale;
import java.util.Properties;

import cz.zcu.fav.kiv.editor.controller.logger.Log;
import cz.zcu.fav.kiv.editor.controller.resource.LanguageEnum;

/**
 * The <code>OptionController</code> class is used for loading and saving editor options.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class OptionController {
    /** The properties storing options of the application */
    private static Properties property;

    /**
     * Fills application properties <code>property</code> firstly by default option values and
     * then by the option values loaded from the editor configuration file. The option values loaded
     * from the configuration file rewrites the corresponding default option values.
     * 
     * Then maps values from application properties <code>property</code> to the corresponding
     * variables defined in <code>OptionItems</code>.
     */
    public static void readOptions() {
        property = new Properties();

        loadDefaultOptions();
        readOptionFile();

        mapEditorOptionItems();
        mapStylesheetOptionItems();
        mapBatchOptionItems();
        Log.info("info.progress_control.load_file", OptionItems.OPTION_PATH);
    }

    /**
     * Rewrites application properties <code>property</code> by default option values specifying
     * stylesheet options. Then maps values from system properties <code>property</code> (only
     * those specifying stylesheet options) to the corresponding variables defined in
     * <code>OptionItems</code>.
     */
    public static void setDefaultStylesheetOptions() {
        OptionItems.getDefaultStylesheetSettings(property);
        mapStylesheetOptionItems();
    }

    /**
     * Rewrites application properties <code>property</code> by default option values specifying
     * editor options. Then maps values from system properties <code>property</code> (only those
     * specifying editor options) to the corresponding variables defined in <code>OptionItems</code>.
     */
    public static void setDefaultEditorOptions() {
        OptionItems.getDefaultEditorSettings(property);
        mapEditorOptionItems();
    }

    /**
     * Loads editor configuration files and saves its content to the system properties
     * <code>property</code>.
     */
    private static void readOptionFile() {
        try {
            property.loadFromXML(new FileInputStream(System.getProperty("user.dir")
                    + File.separator + OptionItems.OPTION_PATH));
            Log.info("info.option_controller.load_file");
        } catch (Exception ex) {
            Log.warn("error.option_controller.file_not_found", ex, OptionItems.OPTION_PATH);
        }
    }

    /**
     * Sets all default option values to the system properties <code>property</code>.
     */
    private static void loadDefaultOptions() {
        OptionItems.getDefaultEditorSettings(property);
        OptionItems.getDefaultStylesheetSettings(property);
        OptionItems.getDefaultBatchSettings(property);
        Log.info("info.option_controller.load_default_option");
    }

    /**
     * Maps values from system properties <code>property</code> to the corresponding variables
     * defined in <code>OptionItems</code>. Maps only variables specifying editor options (<code>LANGUAGE</code>,
     * <code>XML_DEFINITION_PATH</code>, <code>ERASE_CONSOLE</code>).
     */
    private static void mapEditorOptionItems() {
        OptionItems.LANGUAGE = LanguageEnum.parseLocale(property
                .getProperty(OptionItems.KEY_LANGUAGE));
        Locale.setDefault(OptionItems.LANGUAGE);

        OptionItems.XML_DEFINITION_PATH = property.getProperty(OptionItems.KEY_XML_DEFINITION_PATH);
        OptionItems.ERASE_CONSOLE = Boolean.parseBoolean(property
                .getProperty(OptionItems.KEY_ERASE_CONSOLE));
    }

    /**
     * Maps values from system properties <code>property</code> to the corresponding variables
     * defined in <code>OptionItems</code>. Maps only variables specifying stylesheet options (<code>ADD_FO_NAMESPACE</code>,
     * <code>REARRANGE_SAVE</code>, <code>GENERATE_COMMENTS</code>,
     * <code>USE_PARAM_SELECT</code>, <code>ENCODING</code>, <code>NEWLINE</code>,
     * <code>STYLESHEET_VERSION</code>, <code>IMPORT_FILE</code>).
     */
    private static void mapStylesheetOptionItems() {
        OptionItems.ADD_FO_NAMESPACE = Boolean.parseBoolean(property
                .getProperty(OptionItems.KEY_ADD_FO_NAMESPACE));
        OptionItems.REARRANGE_SAVE = Boolean.parseBoolean(property
                .getProperty(OptionItems.KEY_REARRANGE_SAVE));
        OptionItems.GENERATE_COMMENTS = Boolean.parseBoolean(property
                .getProperty(OptionItems.KEY_GENERATE_COMMENTS));
        OptionItems.USE_PARAM_SELECT = Boolean.parseBoolean(property
                .getProperty(OptionItems.KEY_USE_PARAM_SELECT));
        if (EncodingEnum.containsEncoding(property.getProperty(OptionItems.KEY_ENCODING)))
            OptionItems.ENCODING = property.getProperty(OptionItems.KEY_ENCODING);
        if (NewlineEnum.containsNewline(property.getProperty(OptionItems.KEY_NEWLINE)))
            OptionItems.NEWLINE = NewlineEnum.getNewline(property
                    .getProperty(OptionItems.KEY_NEWLINE));
        OptionItems.STYLESHEET_VERSION = property.getProperty(OptionItems.KEY_STYLESHEET_VERSION);
        OptionItems.IMPORT_FILE = property.getProperty(OptionItems.KEY_IMPORT_FILE);

    }

    /**
     * Maps values from system properties <code>property</code> to the corresponding variables
     * defined in <code>OptionItems</code>. Maps only variables specifying batch options (<code>BATCH_FILE</code>,
     * <code>SAVE_BEFORE_RUN</code>).
     */
    private static void mapBatchOptionItems() {
        OptionItems.BATCH_FILE = property.getProperty(OptionItems.KEY_BATCH_FILE);
        OptionItems.SAVE_BEFORE_RUN = Boolean.parseBoolean(property
                .getProperty(OptionItems.KEY_SAVE_BEFORE_RUN));
    }

    /**
     * Maps all variables defined in <code>OptionItems</code> to the corresponding values in the
     * system properties <code>property</code>.
     */
    private static void saveOptionItems() {
        // editor options
        property.put(OptionItems.KEY_LANGUAGE, OptionItems.LANGUAGE.toString());
        property.put(OptionItems.KEY_XML_DEFINITION_PATH, OptionItems.XML_DEFINITION_PATH);
        property.put(OptionItems.KEY_ERASE_CONSOLE, OptionItems.ERASE_CONSOLE.toString());

        // stylesheet options
        property.put(OptionItems.KEY_ADD_FO_NAMESPACE, OptionItems.ADD_FO_NAMESPACE.toString());
        property.put(OptionItems.KEY_REARRANGE_SAVE, OptionItems.REARRANGE_SAVE.toString());
        property.put(OptionItems.KEY_GENERATE_COMMENTS, OptionItems.GENERATE_COMMENTS.toString());
        property.put(OptionItems.KEY_USE_PARAM_SELECT, OptionItems.USE_PARAM_SELECT.toString());
        property.put(OptionItems.KEY_ENCODING, OptionItems.ENCODING);
        property.put(OptionItems.KEY_NEWLINE, OptionItems.NEWLINE.getKey());
        property.put(OptionItems.KEY_IMPORT_FILE, OptionItems.IMPORT_FILE);
        property.put(OptionItems.KEY_STYLESHEET_VERSION, OptionItems.STYLESHEET_VERSION);

        // batch options
        property.put(OptionItems.KEY_BATCH_FILE, OptionItems.BATCH_FILE);
        property.put(OptionItems.KEY_SAVE_BEFORE_RUN, OptionItems.SAVE_BEFORE_RUN.toString());
    }

    /**
     * Saves values in the system properties <code>property</code> to the editor configuration
     * file.
     */
    public static void storeOptionItems() {
        saveOptionItems();
        try {
            property.storeToXML(new FileOutputStream(OptionItems.OPTION_PATH),
                    OptionItems.OPTION_PATH);
            Log.info("info.option_controller.save_file", OptionItems.OPTION_PATH);
        } catch (Exception ex) {
            Log.error("error.option_controller.store", ex);
        }
    }

}
