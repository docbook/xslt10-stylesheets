package cz.zcu.fav.kiv.editor.graphics.components;

import java.awt.event.ItemEvent;
import java.awt.event.ItemListener;
import java.util.Observable;
import java.util.Observer;

import javax.swing.JCheckBox;

import cz.zcu.fav.kiv.editor.beans.types.Type;
import cz.zcu.fav.kiv.editor.controller.MessageWriter;
import cz.zcu.fav.kiv.editor.controller.resource.ResourceController;
import cz.zcu.fav.kiv.editor.graphics.MainFrame;
import cz.zcu.fav.kiv.editor.utils.TagParser;

/**
 * The <code>CheckBox</code> class is the component <em>check-box</em> used for displaying
 * parameter with boolean values - false (no) and true (yes).
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class CheckBox extends JCheckBox implements Observer, ItemListener {

    private static final long serialVersionUID = -6605204557074361719L;

    /** The parameter type which values the component displays */
    private Type type;

    /**
     * Initializes a newly created <code>CheckBox</code> with the parameter type.
     * 
     * @param type
     *            the parameter type.
     */
    public CheckBox(Type type) {
        setSelected(type.getValue());

        this.type = type;
        type.addObserver(this);
        this.addItemListener(this);
    }

    /**
     * Selects or deselects the check-box according to the input value. If the input value is not
     * valid boolean value, the check-box keeps its previous value.
     * 
     * @param observable
     *            the observable object.
     * @param value
     *            the new parameter value.
     */
    public void update(Observable observable, Object value) {
        if (!setSelected(value.toString())) {
            type.changeValue(TagParser.convertBoolean(this.isSelected()));
            MessageWriter.writeWarning(ResourceController.getMessage(
                    "error.component.update_value", type.getOwnerName(), value));
        }
    }

    /**
     * Action performed when the check-box is selected or deselected. Assignes a new estate to the
     * parameter <em>type</em>.
     * 
     * @param event
     *            the item event.
     */
    public void itemStateChanged(ItemEvent event) {
        type.changeValue(TagParser.convertBoolean(this.isSelected()));
        MainFrame.getInstance().setFileChanged();
    }

    /**
     * Selects or deselects the check-box according to the input value.
     * 
     * @param newValue
     *            the new boolean input value.
     * @return true if the input value is valid boolean value.
     */
    private boolean setSelected(String newValue) {
        Boolean value = TagParser.parseBoolean(newValue);
        if (value != null) {
            this.setSelected(value);
            return true;
        } else
            return false;
    }
}
