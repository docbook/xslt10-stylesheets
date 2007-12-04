package cz.zcu.fav.kiv.editor.graphics.components.editor;

import java.util.List;

import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.SpringLayout;

import cz.zcu.fav.kiv.editor.beans.common.ParentParameter;
import cz.zcu.fav.kiv.editor.beans.parameters.Parameter;
import cz.zcu.fav.kiv.editor.beans.properties.Property;
import cz.zcu.fav.kiv.editor.graphics.components.attributes.AttributeButton;
import cz.zcu.fav.kiv.editor.graphics.components.parameters.HelpLabel;
import cz.zcu.fav.kiv.editor.graphics.components.parameters.ParameterCheckBox;
import cz.zcu.fav.kiv.editor.graphics.components.parameters.ParameterTypeForm;
import cz.zcu.fav.kiv.editor.graphics.components.parameters.UrlLabel;
import cz.zcu.fav.kiv.editor.graphics.utils.SpringUtilities;

/**
 * The <code>GroupItemsPanel</code> class is the panel containing the <em>ParentParameter</em>s
 * belonging to one <em>Group</em>.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class GroupItemsPanel extends JPanel {

    private static final long serialVersionUID = 6783434567893822418L;

    /** The number of one component items in the panel */
    private static final int ITEMS = 5;

    /** The size of component margin */
    private static final int MARGIN = 4;

    /**
     * Initializes a newly created <code>GroupItemsPanel</code> with the list of parameters.
     * 
     * @param elementList
     *            the list of parameters.
     */
    public GroupItemsPanel(List<ParentParameter> elementList) {
        int componentCount = 0;

        // parameters panel
        this.setLayout(new SpringLayout());

        for (ParentParameter element : elementList) {
            // checkbox
            this.add(new ParameterCheckBox(element));

            // interrogation mark
            this.add(new HelpLabel(element));

            // url link
            this.add(new UrlLabel(element.getName()));

            // parameter name
            this.add( new JLabel(element.getName()));

            // parameter type
            if (element instanceof Parameter) 
                this.add(new ParameterTypeForm(((Parameter) element).getType()));
            
            // property button
            if (element instanceof Property)
                this.add(new AttributeButton((Property) element));

            componentCount++;
        }

        SpringUtilities.makeCompactGrid(this, componentCount, ITEMS, MARGIN, MARGIN, MARGIN,
                MARGIN);
    }

}
