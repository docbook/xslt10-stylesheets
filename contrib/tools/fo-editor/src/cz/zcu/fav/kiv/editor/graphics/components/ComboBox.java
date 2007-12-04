package cz.zcu.fav.kiv.editor.graphics.components;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.Observable;
import java.util.Observer;

import javax.swing.JComboBox;

import cz.zcu.fav.kiv.editor.beans.types.Type;
import cz.zcu.fav.kiv.editor.controller.MessageWriter;
import cz.zcu.fav.kiv.editor.controller.resource.ResourceController;
import cz.zcu.fav.kiv.editor.graphics.MainFrame;

/**
 * The <code>ComboBox</code> class is the component <em>combo-box</em> used for displaying a
 * list of predefined values of a parameter.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class ComboBox extends JComboBox implements Observer, ActionListener {

    private static final long serialVersionUID = -151909741397111994L;

    /** The parameter type which values the component displays */
    private Type type;

    /**
     * Initializes a newly created <code>ComboBox</code> with the parameter type.
     * 
     * @param type
     *            the parameter type.
     */
    public ComboBox(Type type) {
        super(type.getValueList().values().toArray());

        this.setSelectedItem(type.getValueList().get(type.getValue()));

        this.type = type;
        type.addObserver(this);
        this.addActionListener(this);
    }

    /**
     * Selects the input value in the list if the list contains it. If the input value is not in the
     * list then the previously selected item is left as selected.
     * 
     * @param observable
     *            the observable object.
     * @param value
     *            the new parameter value.
     */
    public void update(Observable observable, Object value) {
        String newValue = type.getValueList().get(value.toString());
        if (newValue != null)
            this.setSelectedItem(newValue);
        else {
            type.changeValue((String) type.getValueList().get(this.getSelectedItem()));
            MessageWriter.writeWarning(ResourceController.getMessage(
                    "error.component.update_value", type.getOwnerName(), value));
        }
    }

    /**
     * Action performed when an item of the combo-box list has been selected. Assignes a new value
     * to the parameter <em>type</em>.
     * 
     * @param event
     *            the action event.
     */
    public void actionPerformed(ActionEvent event) {
        type.changeValue((String) type.getKeyFromValue(this.getSelectedItem().toString()));
        MainFrame.getInstance().setFileChanged();
    }

}
