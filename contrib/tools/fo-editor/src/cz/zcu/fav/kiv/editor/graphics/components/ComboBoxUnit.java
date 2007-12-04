package cz.zcu.fav.kiv.editor.graphics.components;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.Observable;
import java.util.Observer;

import javax.swing.JComboBox;

import cz.zcu.fav.kiv.editor.beans.types.Unit;
import cz.zcu.fav.kiv.editor.graphics.MainFrame;

/**
 * The <code>ComboBoxUnit</code> class is the component <em>combo-box</em> used for displaying a
 * list of predefined units of a parameter.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class ComboBoxUnit extends JComboBox implements Observer, ActionListener {

    private static final long serialVersionUID = -5900614666148972102L;

    /** The parameter unit which values the component displays */
    private Unit unit;

    /**
     * Initializes a newly created <code>ComboBoxUnit</code> with the parameter unit.
     * 
     * @param unit
     *            the parameter unit.
     */
    public ComboBoxUnit(Unit unit) {
        super(unit.getValueList().toArray());
        int selected = unit.getValueList().indexOf(unit.getValue());
        if (selected >= 0)
            this.setSelectedIndex(selected);
        this.unit = unit;
        unit.addObserver(this);
        this.addActionListener(this);
    }

    /**
     * Selects the input value in the list.
     * 
     * @param observable
     *            the observable object.
     * @param value
     *            the new parameter value.
     */
    public void update(Observable observable, Object value) {
        int selected = unit.getValueList().indexOf(value.toString());
        if (selected >= 0)
            this.setSelectedIndex(selected);
    }

    /**
     * Action performed when an item in the combo-box list has been selected. Assignes a new value
     * to the parameter <em>unit</em>.
     * 
     * @param event
     *            the item event.
     */
    public void actionPerformed(ActionEvent event) {
        unit.changeValue((String) this.getSelectedItem());
        MainFrame.getInstance().setFileChanged();
    }
}
