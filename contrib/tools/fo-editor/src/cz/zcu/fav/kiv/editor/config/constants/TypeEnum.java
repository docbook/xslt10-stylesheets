package cz.zcu.fav.kiv.editor.config.constants;


/**
 * The <code>ComponentEnum</code> class is the enumerated list of GUI components supported by the
 * application. Components are used for displaying parameter <code>Type</code>s.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public enum TypeEnum {
    BOOLEAN("boolean"), STRING("string"), INTEGER("integer"), TABLE("table"), FLOAT("float"), LIST("list"), 
    LIST_OPEN("list-open"), LENGTH("length"), URI("uri"), NUMBER("number"), COLOR("color"), 
    FILENAME("filename"), RTF("rtf"), FONT("font"), ATTRIBUTE_SET("attribute set");

    String value;
    
    TypeEnum(String value) {
        this.value = value;
    }
    
    /**
     * Returns <code>ComponentEnum</code> object for the corresponding name. If the input
     * component is not supported then the <code>DUMMY</code> component is returned.
     * 
     * @param name
     *            the name of the component.
     * @return the component for the input name.
     */
    public static TypeEnum getValue(String name){
        for (TypeEnum type : values()) {
            if (type.value.equals(name))
                return type;
        }
        return null;       
    }

    /**
     * Specifies if the input component is among predefined components <code>ComponentEnum</code>.
     * 
     * @param name
     *            the name of the component.
     * @return true if the component is among predefined components.
     */
    public static boolean contains(String name) {
        for (TypeEnum type : values()) {
            if (type.value.equals(name))
                return true;
        }
        return false;
    }
    
    public String toString() {
        return this.value;
    }
}
