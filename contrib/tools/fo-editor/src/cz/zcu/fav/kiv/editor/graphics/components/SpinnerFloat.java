package cz.zcu.fav.kiv.editor.graphics.components;

import java.text.DecimalFormat;
import java.util.Observable;
import java.util.Observer;

import javax.swing.JSpinner;
import javax.swing.SpinnerNumberModel;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;

import cz.zcu.fav.kiv.editor.beans.types.Type;
import cz.zcu.fav.kiv.editor.controller.MessageWriter;
import cz.zcu.fav.kiv.editor.controller.resource.ResourceController;
import cz.zcu.fav.kiv.editor.graphics.MainFrame;

/**
 * The <code>SpinnerFloat</code> class is the component <em>spinner</em> used for displaying and
 * changing decimal numbers.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class SpinnerFloat extends JSpinner implements Observer, ChangeListener {

    private static final long serialVersionUID = 3179056596219532766L;

    /** The step of the <em>spinner</em> */
    private static final double STEP = 0.1;

    /** The number of columns in the <em>spinner</em> */
    private static final int SPINNER_SIZE = 4;

    /** The number format used for converting a decimal value to the string */
    private static final DecimalFormat formatDouble = new DecimalFormat("0.##");

    /** The parameter type which values the component displays */
    private Type type;

    /**
     * Creates the spinner used for displaying and changing decimal numbers.
     * 
     * @param type
     *            the parameter type.
     * @return the newly created spinner used form decimal numbers.
     */
    public static SpinnerFloat createSpinnerFloat(Type type) {
        SpinnerNumberModel spinnerModel = new SpinnerNumberModel();
        spinnerModel.setValue(convertDouble(type.getValue()));
        spinnerModel.setStepSize(STEP);
        return new SpinnerFloat(spinnerModel, type);
    }

    /**
     * Initializes a newly created <code>SpinnerFloat</code> with the parameter type and spinner
     * model.
     * 
     * @param spinnerModel
     *            the spinner model.
     * @param type
     *            the parameter type.
     */
    private SpinnerFloat(SpinnerNumberModel spinnerModel, Type type) {
        super(spinnerModel);
        this.type = type;
        type.addObserver(this);
        this.addChangeListener(this);
        ((JSpinner.DefaultEditor) this.getEditor()).getTextField().setColumns(SPINNER_SIZE);
    }

    /**
     * Updates the spinner number value according to the input value. If the input value is not a
     * valid decimal number, then the previous spinner value is kept.
     * 
     * @param observable
     *            the observable object.
     * @param value
     *            the new parameter value.
     */
    public void update(Observable observable, Object value) {
        try {
            ((SpinnerNumberModel) this.getModel()).setValue(convertDouble(value.toString()));
        } catch (NumberFormatException ex) {
            type.changeValue(formatDouble.format(convertDouble(this.getModel().getValue()
                    .toString())));
            MessageWriter.writeWarning(ResourceController.getMessage(
                    "error.component.update_value", type.getOwnerName(), value));
        }
    }

    /**
     * Action performed when the spinner value is changed. Assignes a new value to the parameter
     * <em>type</em>.
     * 
     * @param event
     *            the item event.
     */
    public void stateChanged(ChangeEvent event) {
        type.changeValue(formatDouble.format(convertDouble(this.getModel().getValue().toString())));
        MainFrame.getInstance().setFileChanged();
    }

    /**
     * Converts the input text containing a decimal number to a double number.
     * 
     * @param number
     *            the input text containing a decimal number.
     * @return converted double number.
     */
    private static Double convertDouble(String number) {
        return Double.parseDouble(number.replace(",", "."));
    }
}
