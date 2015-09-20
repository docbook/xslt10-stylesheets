package cz.zcu.fav.kiv.editor.graphics.components;

import java.awt.event.FocusEvent;
import java.awt.event.FocusListener;
import java.util.Observable;
import java.util.Observer;

import javax.swing.JTextArea;

import cz.zcu.fav.kiv.editor.beans.types.Type;
import cz.zcu.fav.kiv.editor.graphics.MainFrame;

/**
 * The <code>TextArea</code> class is the component <em>text-area</em> used for displaying
 * longer texts.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class TextArea extends JTextArea implements Observer, FocusListener {

    private static final long serialVersionUID = -2338840101614677876L;

    /** The width of the <em>text-area</em> */
    private static final int TEXTAREA_WIDTH = 25;

    /** The height of the <em>text-area</em> */
    private static final int TEXTAREA_HEIGHT = 15;

    /** The parameter type which values the component displays */
    private Type type;

    /**
     * Initializes a newly created <code>TextArea</code> with the parameter type.
     * 
     * @param type
     *            the parameter type.
     */
    public TextArea(Type type) {
        super(TEXTAREA_HEIGHT, TEXTAREA_WIDTH);
        this.setText(type.getValue());
        this.addFocusListener(this);
        this.type = type;
        type.addObserver(this);
    }

    /**
     * Action performed when the <em>text-area</em> losts focus. Assignes a new value to the
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
     * Action performed when the <em>text-area</em> gains focus - does nothing.
     */
    public void focusGained(FocusEvent event) {
    }

    /**
     * Sets the content of the <em>text-area</em> according to the input text.
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
