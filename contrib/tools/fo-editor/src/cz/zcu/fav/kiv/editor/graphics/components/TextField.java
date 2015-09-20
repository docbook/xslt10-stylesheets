package cz.zcu.fav.kiv.editor.graphics.components;

import java.awt.event.FocusEvent;
import java.awt.event.FocusListener;
import java.util.Observable;
import java.util.Observer;

import javax.swing.JTextField;

import cz.zcu.fav.kiv.editor.beans.types.Type;
import cz.zcu.fav.kiv.editor.graphics.MainFrame;

/**
 * The <code>TextField</code> class is the component <em>text-field</em> used for displaying
 * shorter single-line texts.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class TextField extends JTextField implements Observer, FocusListener {

    private static final long serialVersionUID = 4818192876380891610L;

    /** The size of the <em>text-field</em> */
    private static final int TEXTFIELD_SIZE = 25;

    /** The parameter type which values the component displays */
    private Type type;

    /**
     * Initializes a newly created <code>TextField</code> with the parameter type.
     * 
     * @param type
     *            the parameter type.
     */
    public TextField(Type type) {
        super(TEXTFIELD_SIZE);
        this.setText(type.getValue());
        this.addFocusListener(this);
        this.type = type;
        type.addObserver(this);
    }

    /**
     * Action performed when the <em>text-field</em> losts focus. Assignes a new value to the
     * parameter <em>type</em>.
     * 
     * @param event
     *            the focus event.
     */
    public void focusLost(FocusEvent event) {
        type.changeValue(this.getText());
        MainFrame.getInstance().setFileChanged();
    }

    /**
     * Action performed when the <em>text-field</em> gains focus - does nothing.
     */
    public void focusGained(FocusEvent event) {
    }

    /**
     * Sets the content of the <em>text-field</em> according to the input text.
     * 
     * @param observable
     *            the observable object.
     * @param value
     *            the new parameter value.
     */
    public void update(Observable observable, Object value) {
        this.setText(value.toString());
    }
}
