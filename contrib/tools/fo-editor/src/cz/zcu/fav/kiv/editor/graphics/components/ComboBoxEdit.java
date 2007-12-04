package cz.zcu.fav.kiv.editor.graphics.components;

import java.awt.event.ItemEvent;
import java.awt.event.ItemListener;
import java.util.Observable;
import java.util.Observer;

import javax.swing.JComboBox;

import cz.zcu.fav.kiv.editor.beans.types.Type;
import cz.zcu.fav.kiv.editor.graphics.MainFrame;

/**
 * The <code>ComboBoxEdit</code> class is the component <em>combo-box</em> used for displaying a
 * list of predefined values of a parameter. It enables to insert a new value to the list.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class ComboBoxEdit extends JComboBox implements Observer, ItemListener {

    private static final long serialVersionUID = -5008301149696067333L;

    /** The parameter type which values the component displays */
    private Type type;

    /**
     * Initializes a newly created <code>ComboBoxEdit</code> with the parameter type.
     * 
     * @param type
     *            the parameter type.
     */
    public ComboBoxEdit(Type type) {
        super(type.getValueList().values().toArray());

        this.type = type;
        // selected value
        setSelectedIndex(type.getValue());

        type.addObserver(this);
        this.setEditable(true);
        this.addItemListener(this);
    }

    /**
     * Selects the input parameter value in the list if the list contains it. If the input value is
     * not in the list then inserts it to the list.
     * 
     * @param observable
     *            the observable object.
     * @param value
     *            the new parameter value.
     */
    public void update(Observable observable, Object value) {
        setSelectedIndex(value);
    }

    /**
     * Action performed when an item in the combo-box list has been selected or a new one has been
     * inserted. Assignes a new value to the parameter <em>type</em>.
     * 
     * @param event
     *            the item event.
     */
    public void itemStateChanged(ItemEvent event) {
        if ((event.getStateChange() & ItemEvent.ITEM_STATE_CHANGED) != 0) {
            String newValue = type.getDefaultValue().getKeyFromValue(this.getSelectedItem().toString());
            if (newValue != null)
                type.changeValue(newValue);
            else
                type.changeValue(this.getSelectedItem().toString());
            MainFrame.getInstance().setFileChanged();
        }
    }

    /**
     * Selects the input value in the list if the list contains it. If the input value is not in the
     * list then inserts it to the list.
     * 
     * @param obj
     *            the input parameter value.
     */
    private void setSelectedIndex(Object obj) {
        for (int i = 0; i < this.getItemCount(); i++) {
            if (this.getItemAt(i).equals(type.getValueList().get(obj))) {
                this.setSelectedIndex(i);
                return;
            }
        }
        this.addItem(obj);
        this.setSelectedIndex(this.getItemCount() - 1);
    }
}
