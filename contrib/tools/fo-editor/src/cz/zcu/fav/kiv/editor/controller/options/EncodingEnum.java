package cz.zcu.fav.kiv.editor.controller.options;

/**
 * The <code>EncodingEnum</code> class is the enumerated list of document encodings.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public enum EncodingEnum {
    UTF8("UTF-8"), UTF16BE("UTF-16BE"), UTF16LE("UTF-16LE"), ASCII("US-ASCII"), WIN1250(
            "WINDOWS-1250"), ISO88591("ISO-8859-1"), ISO88592("ISO-8859-2");
    /** The key specifying every type of encoding */
    private String key;

    /**
     * Initializes a newly created <code>EncodingEnum</code> with defined key.
     * 
     * @param key
     *            the key of the encoding.
     */
    private EncodingEnum(String key) {
        this.key = key;
    }

    public String getKey() {
        return key;
    }

    public String toString() {
        return key;
    }

    /**
     * Returns <code>EncodingEnum</code> object for corresponding key.
     * 
     * @param encodKey
     *            the key of the encoding.
     * @return the encoding for the input key.
     */
    public static EncodingEnum getEncoding(String encodKey) {
        for (int i = 0; i < EncodingEnum.values().length; i++)
            if (EncodingEnum.values()[i].key.equals(encodKey))
                return EncodingEnum.values()[i];
        return null;
    }

    /**
     * Specifies if the input encoding is among predefined encodings <code>EncodingEnum</code>.
     * 
     * @param encodKey
     *            the key of the encoding.
     * @return true if the input encoding is present in the predefined encodings
     *         <code>EncodingEnum</code>.
     */
    public static boolean containsEncoding(String encodKey) {
        for (int i = 0; i < EncodingEnum.values().length; i++)
            if (EncodingEnum.values()[i].key.equals(encodKey))
                return true;
        return false;
    }
}
