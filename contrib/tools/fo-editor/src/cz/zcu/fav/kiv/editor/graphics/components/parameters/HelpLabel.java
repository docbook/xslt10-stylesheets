package cz.zcu.fav.kiv.editor.graphics.components.parameters;

import java.awt.Cursor;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.swing.JLabel;

import cz.zcu.fav.kiv.editor.beans.common.ParentParameter;
import cz.zcu.fav.kiv.editor.graphics.images.EditorIcon;

/**
 * The <code>HelpLabel</code> class is the icon button displaying the tooltip with parameter purpose and
 * the dialog with parameter description.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class HelpLabel extends JLabel {

    private static final long serialVersionUID = -2256167369619643267L;

    /** The parameter description */
    private String description = null;

    /**
     * Initializes a newly created <code>HelpLabel</code> with the parameter.
     * 
     * @param element
     *            the parameter.
     */
    public HelpLabel(ParentParameter element) {
        if (element.getDescription() != null)
            description = insertStylesheet(element.getDescription(), element.getName());

        this.setToolTipText(element.getPurpose());
        this.setIcon(EditorIcon.createHelpIcon());
        this.addMouseListener(new ShowHelpListener());
        this.setCursor(new Cursor(Cursor.HAND_CURSOR));
    }

    /**
     * Inserts the parameter title to the HTML description of the parameter.
     * 
     * @param text
     *            the description of the parameter.
     * @param title
     *            the title of the parameter.
     * @return the description of the parameter with the title.
     */
    private String insertTitle(String text, String title) {
        Pattern pattern = Pattern.compile("<body>");
        Matcher matcher = pattern.matcher(text);
        if (matcher.find()) {
            return text.substring(0, matcher.end()) + "<h4>" + title + "</h4>"
                    + text.substring(matcher.end());
        }
        return text;
    }

    /**
     * Inserts the CSS stylesheet to the HTML description of the parameter.
     * 
     * @param text
     *            the description of the parameter.
     * @param title
     *            the title of the parameter.
     * @return the description of the parameter with the CSS stylesheet.
     */
    private String insertStylesheet(String text, String title) {
        text = text.replaceAll("<head>.*</head>", "");
        Pattern pattern = Pattern.compile("<html>");
        Matcher matcher = pattern.matcher(text);
        if (matcher.find()) {
            text = matcher.group()
                    + "<head><style>p {margin:0} body {font-size:10px;} h4 {margin:0; text-align:center} ul {margin-left:5px}</style></head>"
                    + text.substring(matcher.end());
        }
        return insertTitle(text, title);
    }

    /**
     * The inner class <em>ShowHelpListener</em> represents action performed when the mouse is
     * pressed above the help icon. Then the dialog with parameter description is displayed.
     * 
     * @author Marta Vaclavikova
     * @version 1.0, 05/2007
     */
    class ShowHelpListener extends MouseAdapter {
        /**
         * Action performed when the mouse is pressed above the help icon, it displays the dialog
         * with parameter description.
         */
        public void mousePressed(MouseEvent event) {
            if (description != null)
                DescriptionForm.showDialog(description, (JLabel) event.getSource());
        }
    }
}
