package cz.zcu.fav.kiv.editor.graphics.components;

import static java.lang.Integer.parseInt;

import java.util.Observable;
import java.util.Observer;

import javax.swing.JSpinner;
import javax.swing.SpinnerModel;
import javax.swing.SpinnerNumberModel;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;

import cz.zcu.fav.kiv.editor.beans.types.Type;
import cz.zcu.fav.kiv.editor.controller.MessageWriter;
import cz.zcu.fav.kiv.editor.controller.resource.ResourceController;
import cz.zcu.fav.kiv.editor.graphics.MainFrame;

/**
 * The <code>SpinnerInt</code> class is the component <em>spinner</em> used for displaying and
 * changing integer numbers.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class SpinnerInt extends JSpinner implements Observer, ChangeListener {

    private static final long serialVersionUID = 6920036545501669043L;

    /** The number of columns in the <em>spinner</em> */
    private static final int SPINNER_SIZE = 4;

    /** The step of the <em>spinner</em> */
    private final static int STEP = 1;

    /** The parameter type which values the component displays */
    private Type type;

    /**
     * Creates the spinner used for displaying and changing integer numbers.
     * 
     * @param type
     *            the parameter type.
     * @return the newly created spinner used form integer numbers.
     */
    public static SpinnerInt createSpinnerInt(Type type) {
        SpinnerNumberModel spinnerModel = new SpinnerNumberModel();
        spinnerModel.setValue(parseInt(type.getValue()));
        spinnerModel.setStepSize(STEP);
        return new SpinnerInt(spinnerModel, type);
    }

    /**
     * Initializes a newly created <code>SpinnerInt</code> with the parameter type and spinner
     * model.
     * 
     * @param spinnerModel
     *            the spinner model.
     * @param type
     *            the parameter type.
     */
    private SpinnerInt(SpinnerModel spinnerModel, Type type) {
        super(spinnerModel);
        this.type = type;
        type.addObserver(this);
        this.addChangeListener(this);
        ((JSpinner.DefaultEditor) this.getEditor()).getTextField().setColumns(SPINNER_SIZE);
    }

    /**
     * Updates the spinner number value according to the input value. If the input value is not a
     * valid integer number, then the previous spinner value is kept.
     * 
     * @param observable
     *            the observable object.
     * @param value
     *            the new parameter value.
     */
    public void update(Observable observable, Object value) {
        try {
            ((SpinnerNumberModel) this.getModel()).setValue(Integer.valueOf(value.toString()));
        } catch (NumberFormatException ex) {
            type.changeValue(this.getModel().getValue().toString());
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
        type.changeValue(this.getModel().getValue().toString());
        MainFrame.getInstance().setFileChanged();
    }
}
