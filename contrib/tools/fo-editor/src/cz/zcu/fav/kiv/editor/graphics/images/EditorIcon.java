package cz.zcu.fav.kiv.editor.graphics.images;

import java.awt.Image;

import javax.swing.ImageIcon;

import cz.zcu.fav.kiv.editor.controller.logger.Log;

/**
 * The <code>EditorIcon</code>class is used for loading images used in the editor.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class EditorIcon {
    /** The path to the directory where images are stored */
    private static final String ICON_PATH = '\u002f'
            + EditorIcon.class.getPackage().getName().replace('.', '\u002f') + '\u002f'
            + "resources" + '\u002f';

    /** The name of the image file representing main editor icon */
    private static final String EDITOR_ICON_PATH = ICON_PATH + "icon.png";

    /** The name of the image file representing tab */
    private static final String TAB_ICON_PATH = ICON_PATH + "tab.png";

    /** The name of the image file representing help */
    private static final String HELP_ICON_PATH = ICON_PATH + "help.png";

    /** The name of the image file representing browser */
    private static final String BROWSER_ICON_PATH = ICON_PATH + "browser.png";

    /** The name of the image file representing colors chooser */
    private static final String COLOR_ICON_PATH = ICON_PATH + "colors.png";

    /**
     * Loads the main editor icon.
     * 
     * @return the main editor icon.
     */
    public static Image createEditorIcon() {
        final ImageIcon imageIcon = createIcon(EDITOR_ICON_PATH);
        return imageIcon != null ? imageIcon.getImage() : null;
    }

    /**
     * Loads the icon from the input file.
     * 
     * @param image
     *            the name of the file where the icon is stored.
     * @return the icon loaded from the input file.
     */
    private static ImageIcon createIcon(String image) {
        try {
            return new ImageIcon(EditorIcon.class.getResource(image));
        } catch (Exception ex) {
            Log.error("error.editor_icon", ex);
        }
        return null;
    }

    /**
     * Loads the large editor icon.
     * 
     * @return the large editor icon.
     */
    public static ImageIcon createLargeEditorIcon() {
        return createIcon(EDITOR_ICON_PATH);
    }

    /**
     * Loads the tab icon.
     * 
     * @return the tab icon.
     */
    public static ImageIcon createTabIcon() {
        return createIcon(TAB_ICON_PATH);
    }

    /**
     * Loads the help icon.
     * 
     * @return the help icon.
     */
    public static ImageIcon createHelpIcon() {
        return createIcon(HELP_ICON_PATH);
    }

    /**
     * Loads the browser icon.
     * 
     * @return the browser icon.
     */
    public static ImageIcon createBrowserIcon() {
        return createIcon(BROWSER_ICON_PATH);
    }

    /**
     * Loads the colors chooser icon.
     * 
     * @return the colors chooser icon.
     */
    public static ImageIcon createColorIcon() {
        return createIcon(COLOR_ICON_PATH);
    }
}
