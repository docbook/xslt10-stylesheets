package cz.zcu.fav.kiv.editor.graphics.components.parameters;

import java.awt.Dimension;
import java.awt.FlowLayout;

import javax.swing.JPanel;
import javax.swing.JScrollPane;

import cz.zcu.fav.kiv.editor.beans.parameters.TypeParam;
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
 * The <code>ParameterTypeForm</code> class is the panel containing the component used for editing
 * <code>Parameter</code> value.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class ParameterTypeForm extends JPanel {

    private static final long serialVersionUID = 6613158285413029141L;

    /**
     * Initializes a newly created <code>ParameterTypeForm</code> with the parameter type.
     * 
     * @param type
     *            the parameter type.
     */
    public ParameterTypeForm(TypeParam type) {
        this.setLayout(new FlowLayout(FlowLayout.LEADING));
        switch (type.getName()) {
        case BOOLEAN:
            this.add(new CheckBox(type));
            break;
        case STRING:
        case URI:
            this.add(new TextField(type));
            break;
        case LIST:
            this.add(new ComboBox(type));
            break;
        case LIST_OPEN:
        case FONT:
            this.add(new ComboBoxEdit(type));
            break;            
        case FILENAME:
            this.add(new FileChooser(type));
            break;
        case COLOR:
            this.add(new ColorChooser(type));
            break;
        case LENGTH:
            this.add(SpinnerFloat.createSpinnerFloat(type));
            this.add(new ComboBoxUnit(type.getUnit()));
            break;
        case NUMBER:
        case INTEGER:
            this.add(SpinnerInt.createSpinnerInt(type));
            break;
        case RTF:
        case TABLE:
            TextArea area = new TextArea(type);
            this.add(area);
            JScrollPane scrollPane = new JScrollPane(area, JScrollPane.VERTICAL_SCROLLBAR_ALWAYS,
                    JScrollPane.HORIZONTAL_SCROLLBAR_ALWAYS);
            this.add(scrollPane);
            break;                        
        case FLOAT:
            this.add(SpinnerFloat.createSpinnerFloat(type));
            break;
        }

        this.setMaximumSize(new Dimension(this.getPreferredSize().width,
                this.getPreferredSize().height));
        this.setPreferredSize(new Dimension(this.getPreferredSize().width,
                this.getPreferredSize().height));
    }
}
