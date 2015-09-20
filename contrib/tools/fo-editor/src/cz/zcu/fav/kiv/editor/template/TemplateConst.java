package cz.zcu.fav.kiv.editor.template;

import java.io.File;

import cz.zcu.fav.kiv.editor.config.constants.FileConst;

/**
 * The <code>TemplateConst</code> class contains enumarated lists of elements used in XML template
 * and XML schema of the template and path and name of the default template.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class TemplateConst {
    /** The size of buffer used for reading element contents */
    public static int BUFFER_SIZE = 300;

    /** The directory where default template is stored */
    public static final String CONF_FILE_TEMPLATE_DIR = "templates" + File.separator;

    /** The file with default template */
    public static final String CONF_FILE_TEMPLATE = CONF_FILE_TEMPLATE_DIR + "template.xml";

    /** The XML schema of the file with default template */
    public static final String CONF_FILE_TEMPLATE_XSD = FileConst.CONF_FILE_XSD_DIR
            + "template.xsd";

    /**
     * The enumerated list of elements used in templates.
     */
    public static enum TemplateTags {
        ATTRIBUTE_SET("attribute-set"), ATTRIBUTE("attribute"), PARAMETER("parameter");

        String value;
        
        TemplateTags(String value) {
            this.value = value;
        }
        
        /**
         * Returns predefined constant of element according to the element name.
         * 
         * @param key
         *            the name of element.
         * @return a constant of element with defined name.
         */
        public static TemplateTags getValue(String key) {
            for (TemplateTags type : values()) {
                if (type.value.equals(key))
                    return type;
            }
            return null;
        }
    }
}
