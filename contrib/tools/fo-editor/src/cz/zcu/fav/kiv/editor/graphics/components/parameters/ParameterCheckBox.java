package cz.zcu.fav.kiv.editor.graphics.components.parameters;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.Observable;
import java.util.Observer;

import javax.swing.JCheckBox;

import cz.zcu.fav.kiv.editor.beans.common.ParentParameter;
import cz.zcu.fav.kiv.editor.graphics.MainFrame;

/**
 * The <code>ParameterCheckBox</code> class is the component <em>check-box</em>, that displays
 * whether the corresponding <code>Parameter</code> is selected or not.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class ParameterCheckBox extends JCheckBox implements Observer, ActionListener {

    private static final long serialVersionUID = -6845824213536903733L;

    /** The parameter which estate the component displays */
    private ParentParameter parameter;

    /**
     * Initializes a newly created <code>ParameterCheckBox</code> with the <code>Parameter</code>.
     * 
     * @param parameter
     *            the parameter.
     */
    public ParameterCheckBox(ParentParameter parameter) {
        super();

        this.parameter = parameter;
        setSelected(parameter.isChosen());

        parameter.addObserver(this);
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
        if (value != null)
            this.setSelected((Boolean) value);
    }

    /**
     * Action performed when the check-box is selected or deselected. Assignes a new estate to the
     * <code>Parameter</code>.
     * 
     * @param event
     *            the action event.
     */
    public void actionPerformed(ActionEvent event) {
        parameter.setChosen(this.isSelected());
        MainFrame.getInstance().setFileChanged();
    }

}
