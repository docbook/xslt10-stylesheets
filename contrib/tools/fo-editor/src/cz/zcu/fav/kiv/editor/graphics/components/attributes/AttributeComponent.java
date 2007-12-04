package cz.zcu.fav.kiv.editor.graphics.components.attributes;

import java.awt.BorderLayout;
import java.util.List;

import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.SpringLayout;

import cz.zcu.fav.kiv.editor.beans.properties.Attribute;
import cz.zcu.fav.kiv.editor.graphics.utils.SpringUtilities;

/**
 * The <code>AttributeComponent</code> class is the panel containing the <em>Attribute</em>s
 * belonging to one <code>AttributeGroup</code>.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class AttributeComponent extends JPanel {

    private static final long serialVersionUID = -1735079147977227649L;

    /** The number of one component items in the panel */
    private static final int ITEMS = 3;

    /** The size of component margin */
    private static final int MARGIN = 3;

    /**
     * Initializes a newly created <code>AttributeComponent</code> with the list of attributes.
     * 
     * @param attributeList
     *            the list of attributes.
     */
    public AttributeComponent(List<Attribute> attributeList) {
        this.setLayout(new BorderLayout());

        // parameters panel
        JPanel paramPane = new JPanel();
        paramPane.setLayout(new SpringLayout());

        for (Attribute attr : attributeList) {
            // checkbox
            paramPane.add(new AttributeCheckBox(attr));

            // attribute name
            paramPane.add(new JLabel(attr.getName()));

            // attribute types
            paramPane.add(new AttributeTypeForm(attr));
        }

        SpringUtilities.makeCompactGrid(paramPane, attributeList.size(), ITEMS, MARGIN, MARGIN,
                MARGIN, MARGIN);

        this.add(paramPane, BorderLayout.LINE_START);
    }

}
