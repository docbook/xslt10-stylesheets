package cz.zcu.fav.kiv.editor.graphics.components.attributes;

import java.awt.Dimension;
import java.awt.FlowLayout;

import javax.swing.JPanel;
import javax.swing.JScrollPane;

import cz.zcu.fav.kiv.editor.beans.properties.Attribute;
import cz.zcu.fav.kiv.editor.beans.properties.UnitAttr;
import cz.zcu.fav.kiv.editor.graphics.components.CheckBox;
import cz.zcu.fav.kiv.editor.graphics.components.ColorChooser;
import cz.zcu.fav.kiv.editor.graphics.components.ComboBox;
import cz.zcu.fav.kiv.editor.graphics.components.ComboBoxEdit;
import cz.zcu.fav.kiv.editor.graphics.components.ComboBoxUnit;
import cz.zcu.fav.kiv.editor.graphics.components.FileChooser;
import cz.zcu.fav.kiv.editor.graphics.components.SpinnerFloat;
import cz.zcu.fav.kiv.editor.graphics.components.SpinnerInt;
import cz.zcu.fav.kiv.editor.graphics.components.TextArea;
import cz.zcu.fav.kiv.editor.graphics.components.TextField;

/**
 * The <code>AttributeTypeForm</code> class is the panel containing the components used for
 * editing <code>Attribute</code> value.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class AttributeTypeForm extends JPanel {

    private static final long serialVersionUID = -2218273286123231184L;
    
    private static final int WIDTH = 200;

    /**
     * Initializes a newly created <code>AttributeTypeForm</code> with the attribute.
     * 
     * @param attribute
     *            the attribute.
     */
    public AttributeTypeForm(Attribute attribute) {
        this.setLayout(new FlowLayout(FlowLayout.LEFT));

        attribute.getType().setAttr(attribute);
        switch (attribute.getType().getName()) {
        case BOOLEAN:
            this.add(new CheckBox(attribute.getType()));
            break;
        case STRING:
        case URI:
            this.add(new TextField(attribute.getType()));
            break;
        case LIST:
            this.add(new ComboBox(attribute.getType()));
            break;
        case LIST_OPEN:
        case FONT:
            this.add(new ComboBoxEdit(attribute.getType()));
            break;            
        case FILENAME:
            this.add(new FileChooser(attribute.getType()));
            break;
        case COLOR:
            this.add(new ColorChooser(attribute.getType()));
            break;
        case LENGTH:
            this.add(SpinnerFloat.createSpinnerFloat(attribute.getType()));
            ((UnitAttr) attribute.getType().getUnit()).setAttribute(attribute);
            this.add(new ComboBoxUnit(attribute.getType().getUnit()));
            break;
        case NUMBER:
        case INTEGER:
            this.add(SpinnerInt.createSpinnerInt(attribute.getType()));
            break;
        case RTF:
        case TABLE:
            TextArea area = new TextArea(attribute.getType());
            this.add(area);
            JScrollPane scrollPane = new JScrollPane(area, JScrollPane.VERTICAL_SCROLLBAR_ALWAYS,
                    JScrollPane.HORIZONTAL_SCROLLBAR_ALWAYS);
            this.add(scrollPane);
            break;                        
        case FLOAT:
            this.add(SpinnerFloat.createSpinnerFloat(attribute.getType()));
            break;
        }

        this.setMaximumSize(new Dimension(this.getPreferredSize().width + WIDTH,
                this.getPreferredSize().height));
        this.setPreferredSize(new Dimension(this.getPreferredSize().width + WIDTH,
                this.getPreferredSize().height));
    }
}
