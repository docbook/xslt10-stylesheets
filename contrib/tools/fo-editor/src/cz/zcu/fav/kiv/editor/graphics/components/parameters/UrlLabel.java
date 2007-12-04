package cz.zcu.fav.kiv.editor.graphics.components.parameters;

import java.awt.Cursor;

import javax.swing.JLabel;

import cz.zcu.fav.kiv.editor.controller.resource.ResourceController;
import cz.zcu.fav.kiv.editor.graphics.images.EditorIcon;

/**
 * The <code>UrlLabel</code> class is the icon button opening the web browser with the parameter
 * description.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class UrlLabel extends JLabel {

    private static final long serialVersionUID = 2760298589328490225L;

    /**
     * Initializes a newly created <code>UrlLabel</code> with the parameter name.
     * 
     * @param elementName
     *            the name of the parameter.
     */
    public UrlLabel(String elementName) {
        this.setToolTipText(ResourceController.getMessage("editor.browser.description",
                ResourceController.getMessage("url.parameter_description", elementName)));
        this.setIcon(EditorIcon.createBrowserIcon());
        this.addMouseListener(new BrowserListener(elementName));
        this.setCursor(new Cursor(Cursor.HAND_CURSOR));
    }

}
