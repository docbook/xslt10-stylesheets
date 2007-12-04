package cz.zcu.fav.kiv.editor.utils;

import java.awt.Color;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import cz.zcu.fav.kiv.editor.controller.errors.ParserException;

/**
 * The <code>TagParser</code> class parses values of parameters, properties and attributes loaded
 * from input files (configuration and XSL stylesheet).
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class TagParser {

    /**
     * Parses the number from the string containing number with unit e.g. parses 12.4 from 12.4em.
     * 
     * @param text
     *            the input text containing number and unit.
     * @throws ParserException
     *             if the input text doesn't contain a number.
     * @return a number parsed from the input text.
     */
    public static String parserNumber(String text) throws ParserException {
        text = text.trim().replaceAll("'", "");
        Pattern pattern = Pattern.compile("\\+?\\-?\\d+\\.?\\d*");
        Matcher matcher = pattern.matcher(text);
        if (matcher.find())
            return matcher.group();
        else
            throw new ParserException(text);
    }

    /**
     * Parses the unit from the string containing number with unit e.g. parses em from 12.4em.
     * 
     * @param text
     *            the input text containing number and unit.
     * @return a unit parsed from the input text.
     */
    public static String parserUnit(String text) {
        Pattern pattern = Pattern.compile("[a-z]+");
        Matcher matcher = pattern.matcher(text);
        if (matcher.find())
            return matcher.group();
        else
            return "";
    }

    /**
     * Transformes a string containing color in hexadecimal format (#rrggbb) to <code>Color</code>.
     * 
     * @param color
     *            the input color <code>Color</code>.
     * @return transformed input color to a string containg the color in hexadecimal format
     *         (#rrggbb).
     */
    public static String createColor(Color color) {
        String red = Integer.toHexString(color.getRed()).toUpperCase();
        String green = Integer.toHexString(color.getGreen()).toUpperCase();
        String blue = Integer.toHexString(color.getBlue()).toUpperCase();

        if (red.length() == 1)
            red = "0" + red;
        if (green.length() == 1)
            green = "0" + green;
        if (blue.length() == 1)
            blue = "0" + blue;

        return "#" + red + green + blue;
    }

    /**
     * Parses the string containing color in hexadecimal format (#rrggbb) and converts it to the
     * <em>Color</em>.
     * 
     * @param hexCol
     *            the string containing a color in in hexadecimal format (#rrggbb).
     * @return a color parsed from the input string. If the input color is invalid, then
     *         <em>null</em> is returned.
     */
    public static Color parseColor(String hexCol) {
        if (hexCol.length() != 7)
            return null;
        try {
            return new Color(Integer.parseInt(hexCol.substring(1, 3), 16), Integer.parseInt(hexCol
                    .substring(3, 5), 16), Integer.parseInt(hexCol.substring(5, 7), 16));
        } catch (Throwable e) {
            return null;
        }
    }

    /**
     * Parses boolean value from the input string containig 1/0 or true/false.
     * 
     * @param boolValue
     *            the string containing 1/0 or true/false.
     * @return a parsed boolean value - true or false.
     */
    public static Boolean parseBoolean(String boolValue) {
        try {
            return (Integer.valueOf(boolValue) == 0) ? false : true;
        } catch (NumberFormatException ex) {
            if (boolValue.equals("true") || boolValue.equals("false"))
                return Boolean.valueOf(boolValue);
        }
        return null;
    }

    /**
     * Converts the boolean value to the string value "1" or "0".
     * 
     * @param boolValue
     *            the input boolean value.
     * @return a string "1" if the input was true, "0" if the input was false.
     */
    public static String convertBoolean(boolean boolValue) {
        return boolValue ? "1" : "0";
    }
}
