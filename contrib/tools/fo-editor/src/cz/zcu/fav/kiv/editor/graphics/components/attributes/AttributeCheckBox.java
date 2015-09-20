package cz.zcu.fav.kiv.editor.graphics.components.attributes;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.Observable;
import java.util.Observer;

import javax.swing.JCheckBox;

import cz.zcu.fav.kiv.editor.beans.properties.Attribute;
import cz.zcu.fav.kiv.editor.graphics.MainFrame;

/**
 * The <code>AttributeCheckBox</code> class is the component <em>check-box</em>, that displays
 * whether the corresponding <code>Attribute</code> of the <code>Property</code> is selected or
 * not.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class AttributeCheckBox extends JCheckBox implements Observer, ActionListener {

    private static final long serialVersionUID = -6845824213536903733L;

    /** The attribute which estate the component displays */
    private Attribute attribute;

    /**
     * Initializes a newly created <code>AttributeCheckBox</code> with the <code>Attribute</code>.
     * 
     * @param attribute
     *            the attribute of the <code>Property</code>.
     */
    public AttributeCheckBox(Attribute attribute) {
        super();

        this.attribute = attribute;
        setSelected(attribute.isChosen());

        attribute.addObserver(this);
        this.addActionListener(this);
    }

    /**
     * Selects or deselects the check-box according to the input value.
     * 
     * @param observable
     *            the observable object.
     * @param value
     *            the new <em>check-box</em> value.
     */
    public void update(Observable observable, Object value) {
        this.setSelected((Boolean) value);
    }

    /**
     * Action performed when the check-box is selected or deselected. Assignes a new estate to the
     * <code>Attribute</code>.
     * 
     * @param event
     *            the action event.
     */
    public void actionPerformed(ActionEvent event) {
        attribute.changeChosen(this.isSelected());
        MainFrame.getInstance().setFileChanged();
    }

}
