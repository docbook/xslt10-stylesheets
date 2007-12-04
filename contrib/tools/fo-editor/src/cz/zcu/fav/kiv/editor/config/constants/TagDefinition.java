package cz.zcu.fav.kiv.editor.config.constants;

/**
 * The <code>TagDefinition</code> class contains enumarated lists of elements used in
 * configuration files and XML parameter definition files.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class TagDefinition {
    /** The size of buffer used for reading element contents */
    public static int BUFFER_SIZE = 300;

    /** The size of buffer used for reading contents of elements with descriptions */
    public static int BUFFER_SIZE_DESCRIPTION = 500;

    /**
     * The enumerated list of elements used in the configuration file with layout of parameters and
     * attribute-sets - config.xml.
     */
    public static enum ConfigTags {
        SECTION("section"), SUBSECTION("subsection"), GROUP("group"), PARAMETER("parameter"), ATTRIBUTE_SET("attribute-set"), NULL("");

        private String value;
        
        ConfigTags(String value) {
            this.value = value;
        }
        
        /**
         * Returns predefined constant of element according to the element name.
         * 
         * @param key
         *            the name of element.
         * @return a constant of element with defined name.
         */
        public static ConfigTags getValue(String key) {
            for (ConfigTags conf : values()) {
                if (conf.value.equals(key))
                    return conf;
            }
            return NULL;
        }
    }

    /**
     * The enumerated list of elements used in the configuration file with attributes -
     * attributes.xml.
     */
    public static enum AttributeTags {
        GROUP("group"), ATTRIBUTE("attribute"), NAME("name"), TYPE("type"), VALUES("values"), 
        COMPONENT("component"), DEFAULT("default"), UNIT("unit"), NULL("");
        private String value;
        
        AttributeTags(String value) {
            this.value = value;
        }
        
        /**
         * Returns predefined constant of element according to the element name.
         * 
         * @param key
         *            the name of element.
         * @return a constant of element with defined name.
         */
        public static AttributeTags getValue(String key) {
            for (AttributeTags attr : values()) {
                if (attr.value.equals(key))
                    return attr;
            }
            return NULL;
        }
        
        public String toString() {
            return this.name().toLowerCase();
        }
    }

    /**
     * The enumerated list of elements used in files with XML parameter definitions.
     */
    public static enum ParameterTags {
        REFSECTION("refsection"), REFPURPOSE("refpurpose"), REFMISCINFO("refmiscinfo"), REFMETA("refmeta"), 
        DATATYPE("datatype"), VALUE("value"), ALT("alt"), LIST_TYPE("list-type"), NULL(""), XSL_PARAM("xsl:param"),
        XSL_ATTRIBUTE("xsl:attribute");

        //type
        public static final String OPEN = "open";
        public static final String OTHERCLASS = "otherclass";
        public static final String FO = "fo";
        
        //value
        public static final String CONDITION = "condition";
        public static final String SELECT = "select";
        public static final String TEST = "test";
        public static final String CONTAINS = "contains";
        public static final String NAME = "name";

        private String value;
        ParameterTags(String value) {
            this.value = value;
        }
        /**
         * Returns predefined constant of element according to the element name.
         * 
         * @param key
         *            the name of element.
         * @return a constant of element with defined name.
         */
        public static ParameterTags getEnumValue(String key) {
                for (ParameterTags param : values()) {
                if (param.value.equals(key))
                    return param;
            }
            return NULL;
        }
        
        public String toString() {
            return this.value;
        }
        public String getValue() {
            return value;
        }
    }

    /**
     * The enumerated list of elements used in the configuration file with graphics figures -
     * graphics.xml.
     */
    public static enum FigureTags {
        FIGURE, PARAMETER, NULL;

        /**
         * Returns predefined constant of element according to the element name.
         * 
         * @param key
         *            the name of element.
         * @return a constant of element with defined name.
         */
        public static FigureTags getValue(String key) {
            try {
                return FigureTags.valueOf(key.toUpperCase());
            } catch (IllegalArgumentException ex) {
                return NULL;
            }
        }
    }

    /**
     * The enumerated list of elements used in the configuration file with types - types.xml.
     */
    public static enum TypeTags {
        COLOR("color"), UNIT("unit"), FONT("font"), NULL("");

        private String value;
        
        
        TypeTags(String value) {
             this.value = value; 
        }
        /**
         * Returns predefined constant of element according to the element name.
         * 
         * @param key
         *            the name of element.
         * @return a constant of element with defined name.
         */
        public static TypeTags getValue(String key) {
            for (TypeTags type : values()) {
                if (type.value.equals(key))
                    return type;
            }
            return NULL;
        }
    }

}
