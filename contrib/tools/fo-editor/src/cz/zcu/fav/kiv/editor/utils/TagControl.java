package cz.zcu.fav.kiv.editor.utils;

import cz.zcu.fav.kiv.editor.beans.types.Type;
import cz.zcu.fav.kiv.editor.beans.types.Unit;
import cz.zcu.fav.kiv.editor.controller.errors.ParserException;

/**
 * The <code>TagControl</code> class controls the components and values of parameters and
 * attributes.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class TagControl {

    /**
     * Controls if the input value corresponds to the <code>Type</code> component.
     * 
     * @param type
     *            the type with the component.
     * @param value
     *            the new value for controlling.
     */
    public static void controlSetTypeValue(Type type, String value) throws ParserException {
        switch (type.getName()) {
        case LIST:
            controlList(type, value);
            break;
        case INTEGER:
            controlInteger(type, value);
            break;
        case NUMBER:
            controlInteger(type, value); 
            break;
        case FLOAT:
            controlFloat(type, value);
            break;
        case COLOR:
            controlColor(type, value);
            break;
        case BOOLEAN:
            controlBoolean(type, value);
            break;
        case LENGTH:
            controlLength(type, value);
            break;
        default:
            type.setValue(value);
        }
    }


    /**
     * Controls if the list of predefined units in <code>Unit</code> contains the input unit name.
     * 
     * @param unit
     *            the unit with the list of predefined units.
     * @param unitName
     *            the name of input unit.
     * @return true if the <code>Unit</code> contains the input unit name.
     */
    private static void controlTypeUnit(Unit unit, String unitName) throws ParserException {
        if (unit.getValueList().contains(unitName))
            unit.setValue(unitName);
        else 
            throw new ParserException();
    }

    /**
     * Controls if the input value is a valid value for component combo-box.
     * 
     * @param type
     *            the type with component combo-box.
     * @param value
     *            the input value for controlling.
     * @return true if the input value is valid for the component combo-box.
     */
    private static void controlList(Type type, String value) throws ParserException{
        if ((type.getValueList() != null)
            &&(type.getValueList().containsKey(value)))
            type.setValue(value);
        else 
            throw new ParserException();
    }

    /**
     * Controls if the input value is a valid value for component spinner-int.
     * 
     * @param value
     *            the input value for controlling.
     * @return true if the input value is valid for the component spinner-int.
     */
    private static void controlInteger(Type type, String value) throws ParserException {
        try {
            Integer.parseInt(value);
            type.setValue(value);
        } catch (Exception pe) {
            throw new ParserException();
        }
    }

    /**
     * Controls if the input value is a valid value for component spinner-float.
     * 
     * @param value
     *            the input value for controlling.
     * @return true if the input value is valid for the component spinner-float.
     */
    private static void controlFloat(Type type, String value) throws ParserException {
        try {
            Double.parseDouble(value);
            type.setValue(value);
        } catch (NumberFormatException pe) {
            throw new ParserException();
        }
    }

    /**
     * Controls if the input value is a valid value for component color-chooser.
     * 
     * @param type
     *            the type with component color-chooser.
     * @param value
     *            the input value for controlling.
     * @return true if the input value is valid for the component color-chooser.
     */
    private static void controlColor(Type type, String value) throws ParserException {
        if ((type.getValueList() != null)
                &&(type.getValueList().get(value) == null)
                &&(TagParser.parseColor(value) == null))
            throw new ParserException();
        else
            type.setValue(value);
    }

    /**
     * Controls if the input value is a valid value for component check-box.
     * 
     * @param value
     *            the input value for controlling.
     * @return true if the input value is valid for the component check-box.
     */
    private static void controlBoolean(Type type, String value) throws ParserException {
        if (value.equals("0") || value.equals("1"))
            type.setValue(value);
        else
            throw new ParserException();
    }

    private static void controlLength(Type type,String value) throws ParserException {
        String number = TagParser.parserNumber(value);
        String unit = TagParser.parserUnit(value);
        controlTypeUnit(type.getUnit(), unit);
        type.setValue(number);
    }
}
