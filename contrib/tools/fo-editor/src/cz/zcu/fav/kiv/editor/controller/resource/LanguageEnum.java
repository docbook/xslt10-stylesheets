package cz.zcu.fav.kiv.editor.controller.resource;

import java.util.Locale;

/**
 * The <code>EncodingEnum</code> class is the enumerated list of languages used in the
 * application.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public enum LanguageEnum {
    EN(Locale.ENGLISH), CS(new Locale("cs"));

    /** The locale specifying the language */
    private Locale locale;

    /**
     * Initializes a newly created <code>LanguageEnum</code> with defined locale language.
     * 
     * @param locale
     *            the locale of the language.
     */
    private LanguageEnum(Locale locale) {
        this.locale = locale;
    }

    /**
     * Returns title of the language loaded from resources <code>ResourceController</code>.
     * 
     * @return the language title loaded from <code>ResourceController</code>.
     */
    public String toString() {
        return ResourceController.getMessage("language." + locale.toString());
    }

    /**
     * Returns <code>LanguageEnum</code> language for corresponding locale.
     * 
     * @param loc
     *            the locale of the language.
     * @return the language for the input locale.
     */
    public static LanguageEnum getLanguage(Locale loc) {
        if (CS.locale.equals(loc))
            return CS;
        return EN;
    }

    /**
     * Parses input string containing language and returns corresponding <code>locale</code>
     * language.
     * 
     * @param language
     *            the input text constant containing language.
     * @return the locale corresponding to the input text constant.
     */
    public static Locale parseLocale(String language) {
        if ((language != null) && (language.equals(CS.getLocale().getLanguage())))
            return CS.getLocale();
        return EN.getLocale();
    }

    public Locale getLocale() {
        return locale;
    }

    /**
     * Gets the current value of the default locale for this instance of the Java Virtual Machine.
     * Returns only supported value - CS or EN.
     * 
     * @return the locale of this instance of JVM.
     */
    public static Locale getDefaultLocale() {
        if (Locale.getDefault().getLanguage().equals(LanguageEnum.CS.getLocale().getLanguage()))
            return LanguageEnum.CS.getLocale();
        return LanguageEnum.EN.getLocale();
    }
}
