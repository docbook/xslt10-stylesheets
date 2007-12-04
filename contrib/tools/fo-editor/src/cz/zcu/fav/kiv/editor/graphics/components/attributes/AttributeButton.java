package cz.zcu.fav.kiv.editor.graphics.components.attributes;

import java.awt.Dimension;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.Box;
import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JPanel;

import cz.zcu.fav.kiv.editor.beans.properties.Property;

/**
 * The <code>AttributeButton</code> class represents the <em>button</em> displaying the dialog
 * with attributes <code>AttributeDialog</code>.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class AttributeButton extends JPanel implements ActionListener {

    private static final long serialVersionUID = 6410143984336194601L;

    /** The size of horizontal empty gap */
    private static final int EMPTY_GAP_HORIZONTAL = 10;

    /** The size of vertical empty gap */
    private static final int EMPTY_GAP_VERTICAL = 0;

    /** The property which dialog dialog displays */
    private Property property;

    /**
     * Initializes a newly created <code>AttributeButton</code> with the property.
     * 
     * @param property
     *            the property with <code>Attribute</code>s.
     */
    public AttributeButton(Property property) {
        this.setLayout(new BoxLayout(this, BoxLayout.X_AXIS));

        this.add(Box.createRigidArea(new Dimension(EMPTY_GAP_HORIZONTAL, EMPTY_GAP_VERTICAL)));

        JButton button = new JButton(property.getName());
        button.addActionListener(this);
        this.add(button);

        this.property = property;
    }

    /**
     * Action performed when the button is pressed. It displays the dialog with attributes
     * <code>AttributeDialog</code>.
     */
    public void actionPerformed(ActionEvent event) {
        javax.swing.SwingUtilities.invokeLater(new Runnable() {
            public void run() {
                AttributeDialog.showDialog(property);
            }
        });
    }
}
