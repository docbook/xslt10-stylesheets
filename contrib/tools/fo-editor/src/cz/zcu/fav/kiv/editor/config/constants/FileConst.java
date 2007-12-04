package cz.zcu.fav.kiv.editor.config.constants;

import java.io.File;

/**
 * The <code>FileConst</code> class contains paths and names of configuration files and their XSL
 * schemas.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class FileConst {

    /** The directory where configuration files are stored */
    public static final String CONF_FILE_XML_DIR = "configuration" + File.separator;

    /** The directory where XML schemas of configuration files are stored */
    public static final String CONF_FILE_XSD_DIR = '\u002f' + "schemas" + '\u002f';

    /** The configuration file describing layout of parameters and attribute-sets */
    public static final String CONF_FILE_CONFIG = CONF_FILE_XML_DIR + "config.xml";

    /** The XML schema of the configuration file describing layout of parameters and attribute-sets */
    public static final String CONF_FILE_CONFIG_XSD = CONF_FILE_XSD_DIR + "config.xsd";

    /** The configuration file describing attributes */
    public static final String CONF_FILE_ATTRIBUTES = CONF_FILE_XML_DIR + "attributes.xml";

    /** The XML schema of the configuration file describing attributes */
    public static final String CONF_FILE_ATTRIBUTES_XSD = CONF_FILE_XSD_DIR + "attributes.xsd";

    /** The configuration file describing types */
    public static final String CONF_FILE_TYPE = CONF_FILE_XML_DIR + "types.xml";

    /** The XML schema of the configuration file describing types */
    public static final String CONF_FILE_TYPE_XSD = CONF_FILE_XSD_DIR + "types.xsd";

    /** The configuration file describing graphics figures */
    public static final String CONF_FILE_FIGURES = CONF_FILE_XML_DIR + "graphics.xml";

    /** The XML schema of the configuration file describing graphics figures */
    public static final String CONF_FILE_FIGURES_XSD = CONF_FILE_XSD_DIR + "graphics.xsd";

    /** The XSL file used for converting text in DocBook to HTML format */
    public static final String CONF_FILE_CONVERT = CONF_FILE_XSD_DIR + "convert.xsl";
}
