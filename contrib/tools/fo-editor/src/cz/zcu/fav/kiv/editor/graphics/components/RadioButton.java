package cz.zcu.fav.kiv.editor.graphics.components;

import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.Iterator;
import java.util.Map;
import java.util.Observable;
import java.util.Observer;

import javax.swing.ButtonGroup;
import javax.swing.JPanel;
import javax.swing.JRadioButton;

import cz.zcu.fav.kiv.editor.beans.types.Type;
import cz.zcu.fav.kiv.editor.controller.MessageWriter;
import cz.zcu.fav.kiv.editor.controller.resource.ResourceController;
import cz.zcu.fav.kiv.editor.graphics.MainFrame;

/**
 * The <code>RadioButton</code> class is the component containing a group of <em>radio-button</em>s
 * used for choosing one of predefined values.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class RadioButton extends JPanel implements Observer, ActionListener {

    private static final long serialVersionUID = 7530690462466562523L;

    /** The parameter type which values the component displays */
    private Type type;

    /** The list of <em>radio-button</em>s */
    private JRadioButton[] radioList;

    /**
     * Initializes a newly created <code>RadioButton</code> with the parameter type.
     * 
     * @param type
     *            the parameter type.
     */
    public RadioButton(Type type) {
        this.setLayout(new GridLayout(0, 3));
        this.type = type;
        ButtonGroup group = new ButtonGroup();
        radioList = new JRadioButton[type.getValueList().size()];

        int i = 0;
        for (Iterator it = type.getValueList().entrySet().iterator(); it.hasNext();) {
            Map.Entry e = (Map.Entry) it.next();
            radioList[i] = new JRadioButton(e.getKey().toString());
            radioList[i].setName(e.getValue().toString());
            radioList[i].addActionListener(this);
            if (e.getValue().equals(type.getValue()))
                radioList[i].setSelected(true);
            group.add(radioList[i]);
            this.add(radioList[i]);
            i++;
        }
        type.addObserver(this);
    }

    /**
     * Selects one radio-button representing the input value. If the input value is not among the
     * values of radio-buttons, then the previous selection of a radio-button is kept.
     * 
     * @param observable
     *            the observable object.
     * @param value
     *            the new parameter value.
     */
    public void update(Observable observable, Object value) {
        boolean selected = false;
        for (int i = 0; i < radioList.length; i++) {
            if (radioList[i].getName().equals(value.toString())) {
                radioList[i].setSelected(true);
                selected = true;
                break;
            }
        }
        if (!selected) {
            for (int i = 0; i < radioList.length; i++) {
                if (radioList[i].isSelected())
                    type.changeValue(radioList[i].getName());
            }
            MessageWriter.writeWarning(ResourceController.getMessage(
                    "error.component.update_value", type.getOwnerName(), value));
        }
    }

    /**
     * Action performed when one of radio-buttons is selected. Assignes a new value to the parameter
     * <em>type</em>.
     * 
     * @param event
     *            the item event.
     */
    public void actionPerformed(ActionEvent event) {
        type.changeValue(((JRadioButton) event.getSource()).getName());
        MainFrame.getInstance().setFileChanged();
    }
}
