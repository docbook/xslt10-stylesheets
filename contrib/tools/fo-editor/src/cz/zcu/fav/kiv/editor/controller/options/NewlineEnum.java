package cz.zcu.fav.kiv.editor.controller.options;

import cz.zcu.fav.kiv.editor.controller.resource.ResourceController;

/**
 * The <code>NewlineEnum</code> class is the enumerated list of chars defining ends of line in the
 * output XSL stylesheet.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public enum NewlineEnum {
    CRLF("cr+lf", "encoding.crlf"), LF("lf", "encoding.lf"), CR("cr", "encoding.cr");
    /** The resource message specifying every end of line */
    private String message;

    /** The key specifying every end of line */
    private String key;

    /**
     * Initializes a newly created <code>NewlineEnum</code> with defined key and resource message.
     * 
     * @param key
     *            the key of the encoding.
     * @param mes
     *            the resource message of encoding.
     */
    private NewlineEnum(String key, String mes) {
        this.message = mes;
        this.key = key;
    }

    public String getMessage() {
        return message;
    }

    public String toString() {
        return ResourceController.getMessage(message);
    }

    /**
     * Returns <code>NewlineEnum</code> object for the corresponding key.
     * 
     * @param newLineKey
     *            the key of the end of line.
     * @return the end of line for the input key.
     */
    public static NewlineEnum getNewline(String newLineKey) {
        for (int i = 0; i < NewlineEnum.values().length; i++)
            if (NewlineEnum.values()[i].key.equals(newLineKey))
                return NewlineEnum.values()[i];
        return null;
    }

    /**
     * Specifies if the input end of line is among predefined ends of line <code>NewlineEnum</code>.
     * 
     * @param encodKey
     *            the key of the end of line.
     * @return true if the input end of line is present in the predefined ends of line
     *         <code>NewlineEnum</code>.
     */
    public static boolean containsNewline(String encodKey) {
        for (int i = 0; i < NewlineEnum.values().length; i++)
            if (NewlineEnum.values()[i].key.equals(encodKey))
                return true;
        return false;
    }

    public String getKey() {
        return key;
    }

}
