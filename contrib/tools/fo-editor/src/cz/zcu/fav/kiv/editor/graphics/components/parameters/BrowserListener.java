package cz.zcu.fav.kiv.editor.graphics.components.parameters;

import java.awt.datatransfer.Clipboard;
import java.awt.datatransfer.ClipboardOwner;
import java.awt.datatransfer.StringSelection;
import java.awt.datatransfer.Transferable;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import javax.swing.JMenuItem;
import javax.swing.JPopupMenu;

import cz.zcu.fav.kiv.editor.controller.resource.ResourceController;
import cz.zcu.fav.kiv.editor.graphics.MainFrame;
import cz.zcu.fav.kiv.editor.graphics.utils.OpenBrowser;

/**
 * The <code>BrowserListener</code> class represents the action performed when the mouse is
 * pressed above the <code>UrlLabel</code>.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class BrowserListener extends MouseAdapter implements ClipboardOwner {

    /** The popup menu displaying when the right mouse button is pressed */
    private JPopupMenu popup;

    /**
     * The name of the parameter - is the same as the URL path of the web page with parameter
     * description
     */
    private String name;

    /**
     * Creates the popup menu displaying when the right mouse button is pressed above
     * <code>UrlLabel</code>.
     * 
     * @return the popup menu of the <em>UrlLabel</em>.
     */
    private JPopupMenu createPopupMenu() {
        JPopupMenu popup = new JPopupMenu();
        // item opening the web browser
        JMenuItem menuItem = new JMenuItem(ResourceController
                .getMessage("editor.browser.menu.open_browser"));
        menuItem.addActionListener(new OpenBrowserListener());
        popup.add(menuItem);
        // item copying the URL path to the clippboard
        menuItem = new JMenuItem(ResourceController.getMessage("editor.browser.menu.copy_location"));
        menuItem.addActionListener(new CopyToClipboardListener());
        popup.add(menuItem);
        return popup;
    }

    /**
     * Initializes a newly created <code>BrowserListener</code> with the parameter name.
     * 
     * @param name
     *            the name of the parameter.
     */
    public BrowserListener(String name) {
        this.name = name;
        popup = createPopupMenu();
    }

    /**
     * Action performed when the mouse button is pressed. Shows the popup menu if the right mouse
     * button has been pressed.
     */
    public void mouseReleased(MouseEvent event) {
        maybeShowPopup(event);
    }

    /**
     * Shows the popup menu if the right mouse button has been pressed.
     * 
     * @param event
     *            the mouse event.
     */
    private void maybeShowPopup(MouseEvent event) {
        if (event.isPopupTrigger())
            popup.show(event.getComponent(), event.getX(), event.getY());
        else
            OpenBrowser.openURL(ResourceController.getMessage("url.parameter_description", name));
    }

    /**
     * The inner class <code>BrowserListener</code> represents the action performed when the left
     * mouse button above the <code>UrlLabel</code> is pressed. It opens the web browser with the
     * web page containg the parameter description.
     * 
     * @author Marta Vaclavikova
     * @version 1.0, 05/2007
     */
    class OpenBrowserListener implements ActionListener {
        /**
         * The action performed when the left mouse button above the <code>UrlLabel</code> is
         * pressed. It opens the web browser with the web page containg the parameter description.
         */
        public void actionPerformed(ActionEvent event) {
            OpenBrowser.openURL(ResourceController.getMessage("url.parameter_description", name));
        }
    }

    /**
     * The inner class <code>CopyToClipboardListener</code> represents the action performed when
     * the popup menu item <em>Copy to clipboard</em> is chosen. It copies the URL of the page
     * with the parameter description to the clipboard.
     * 
     * @author Marta Vaclavikova
     * @version 1.0, 05/2007
     */
    class CopyToClipboardListener implements ActionListener {

        /**
         * The action performed when the popup menu item <em>Copy to clipboard</em> is chosen. It
         * copies the URL of the page with the parameter description to the clipboard.
         */
        public void actionPerformed(ActionEvent event) {
            Clipboard clipboard = MainFrame.getInstance().getToolkit().getSystemClipboard();
            clipboard.setContents(new StringSelection(name), BrowserListener.this);
        }
    }

    public void lostOwnership(Clipboard arg0, Transferable arg1) {
    }
}
