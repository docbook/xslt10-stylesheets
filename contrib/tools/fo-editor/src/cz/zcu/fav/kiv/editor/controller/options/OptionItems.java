package cz.zcu.fav.kiv.editor.controller.options;

import java.util.Locale;
import java.util.Properties;

import cz.zcu.fav.kiv.editor.controller.resource.LanguageEnum;
import cz.zcu.fav.kiv.editor.controller.resource.ResourceController;
import cz.zcu.fav.kiv.editor.graphics.TopMenu;

/**
 * The <code>OptionItems</code> class contains variables defining all options used in the
 * application.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class OptionItems {
    /** The configuration file where options of the application are stored */
    public static final String OPTION_PATH = "options.xml";

    /** The version of the application */
    public static final String APPLICATION_VERSION = "1.0.1";

    /** The stylesheet XSL namespace */
    public static final String XSL_NAMESPACE = "http://www.w3.org/1999/XSL/Transform";

    /** The stylesheet FO namespace */
    public static final String FO_NAMESPACE = "http://www.w3.org/1999/XSL/Format";

    // ------------- editor options ------------------------

    /** The property key of the language used in the editor */
    public static final String KEY_LANGUAGE = "fo_parameter_editor.language";

    /** The language used in the editor */
    public static Locale LANGUAGE = LanguageEnum.getDefaultLocale();

    /**
     * Changes language used in the editor by the input language locale, if the language locale is
     * supported by the editor. Updates all text expression in the application according to the new
     * language.
     * 
     * @param language
     *            the locale of the language that will be set as current editor language.
     */
    public static void changeLanguage(Locale language) {
        OptionItems.LANGUAGE = language;
        ResourceController.changeInstance();
        TopMenu.changeLanguage();
        Locale.setDefault(language);
    }

    /** The property key of the path where files with XML descriptions of FO parameters are stored */
    public static final String KEY_XML_DEFINITION_PATH = "fo_parameter_editor.xml_definition_path";

    /** The path where files with XML descriptions of FO parameters are stored */
    public static String XML_DEFINITION_PATH;

    /** The property key of the flag specifying if the editor console is erased before every action */
    public static final String KEY_ERASE_CONSOLE = "fo_parameter_editor.erase_console";

    /** The flag specifying if the editor console is erased before every action */
    public static Boolean ERASE_CONSOLE;

    // ------------------- stylesheet options ---------------------

    /**
     * The property key of the flag specifying if the FO namespace definition is added to every new
     * stylesheet file
     */
    public static final String KEY_ADD_FO_NAMESPACE = "fo_parameter_editor.add_fo_namespace";

    /** The flag specifying if the FO namespace definition is added to every new stylesheet file */
    public static Boolean ADD_FO_NAMESPACE;

    /** The property key of the flag specifying if the rearrange stylesheet saving is used */
    public static final String KEY_REARRANGE_SAVE = "fo_parameter_editor.rearrange_save";

    /** The flag specifying if the rearrange stylesheet saving is used */
    public static Boolean REARRANGE_SAVE;

    /** The property key of the flag specifying if the comments in stylesheets are generated */
    public static final String KEY_GENERATE_COMMENTS = "fo_parameter_editor.generate_comments";

    /** The flag specifying if the comments in stylesheets are generated */
    public static Boolean GENERATE_COMMENTS;

    /**
     * The property key of the flag specifying if attribute select is used in the stylesheet
     * parameter element
     */
    public static final String KEY_USE_PARAM_SELECT = "fo_parameter_editor.use_param_select";

    /** The flag specifying if attribute select is used in the stylesheet parameter element */
    public static Boolean USE_PARAM_SELECT;

    /** The property key of the actual editor encoding */
    public static final String KEY_ENCODING = "fo_parameter_editor.encoding";

    /** The actual editor encoding */
    public static String ENCODING;

    /** The property key of the actual stylesheet end of line */
    public static final String KEY_NEWLINE = "fo_parameter_editor.newline";

    /** The actual stylesheet end of line */
    public static NewlineEnum NEWLINE;

    // ----------------- xsl options ------------------------

    /**
     * The property key of the list specifying XSL stylesheet files imported to a new stylesheet
     * file
     */
    public static final String KEY_IMPORT_FILE = "fo_parameter_editor.xsl_import_file";

    /** The list specifying XSL stylesheet files imported to a new stylesheet file */
    public static String IMPORT_FILE;

    /** The property key of stylesheet version */
    public static final String KEY_STYLESHEET_VERSION = "fo_parameter_editor.stylesheet_version";

    /** The stylesheet version */
    public static String STYLESHEET_VERSION;

    // ----------------- batch options ------------------------

    /** The property key of batch file path */
    public static final String KEY_BATCH_FILE = "fo_parameter_editor.batch_file";

    /** The batch file path */
    public static String BATCH_FILE;

    /**
     * The property key of flag specifying if the opened stylesheet is automatically saved before
     * launching batch file
     */
    public static final String KEY_SAVE_BEFORE_RUN = "fo_parameter_editor.save_before_run";

    /**
     * The flag specifying if the opened stylesheet is automatically saved before launching batch
     * file
     */
    public static Boolean SAVE_BEFORE_RUN;

    /**
     * Fills application properties <code>property</code> by default option values. Maps only
     * variables specifying editor options (<code>LANGUAGE</code>,
     * <code>XML_DEFINITION_PATH</code>, <code>ERASE_CONSOLE</code>).
     * 
     * @param defaultSettings
     *            the properties storing options of the application.
     * @return the properties storing options of the application containing default editor options.
     */
    public static Properties getDefaultEditorSettings(Properties defaultSettings) {
        defaultSettings.put(KEY_LANGUAGE, LanguageEnum.getDefaultLocale());
        defaultSettings.put(KEY_XML_DEFINITION_PATH, "docbook-params");
        defaultSettings.put(KEY_ERASE_CONSOLE, "false");
        return defaultSettings;
    }

    /**
     * Fills application properties <code>property</code> by default option values. Maps only
     * variables specifying stylesheet options (<code>ADD_FO_NAMESPACE</code>,
     * <code>REARRANGE_SAVE</code>, <code>GENERATE_COMMENTS</code>,
     * <code>USE_PARAM_SELECT</code>, <code>ENCODING</code>, <code>NEWLINE</code>,
     * <code>STYLESHEET_VERSION</code>, <code>IMPORT_FILE</code>).
     * 
     * @param defaultSettings
     *            the properties storing options of the application.
     * @return the properties storing options of the application containing default stylesheet
     *         options.
     */
    public static Properties getDefaultStylesheetSettings(Properties defaultSettings) {
        defaultSettings.put(KEY_ADD_FO_NAMESPACE, "false");
        defaultSettings.put(KEY_REARRANGE_SAVE, "false");
        defaultSettings.put(KEY_GENERATE_COMMENTS, "true");
        defaultSettings.put(KEY_USE_PARAM_SELECT, "false");
        defaultSettings.put(KEY_ENCODING, EncodingEnum.UTF8.getKey());
        defaultSettings.put(KEY_NEWLINE, NewlineEnum.CRLF.getKey());
        defaultSettings.put(KEY_STYLESHEET_VERSION, "1.0");
        defaultSettings.put(KEY_IMPORT_FILE,
                "https://cdn.docbook.org/release/xsl/current/fo/docbook.xsl;");
        return defaultSettings;
    }

    /**
     * Fills application properties <code>property</code> by default other values. Maps only
     * variables specifying batch options (<code>BATCH_FILE</code>, <code>SAVE_BEFORE_RUN</code>).
     * 
     * @param defaultSettings
     *            the properties storing options of the application.
     * @return the properties storing options of the application containing default batch options.
     */
    public static Properties getDefaultBatchSettings(Properties defaultSettings) {
        defaultSettings.put(KEY_BATCH_FILE, "");
        defaultSettings.put(KEY_SAVE_BEFORE_RUN, "true");
        return defaultSettings;
    }
}
