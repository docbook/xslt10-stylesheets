package cz.zcu.fav.kiv.editor.graphics.frames;

import java.awt.BorderLayout;
import java.awt.Font;

import javax.swing.BorderFactory;
import javax.swing.Box;
import javax.swing.BoxLayout;
import javax.swing.JLabel;
import javax.swing.JPanel;

import cz.zcu.fav.kiv.editor.controller.options.OptionItems;
import cz.zcu.fav.kiv.editor.controller.resource.ResourceController;
import cz.zcu.fav.kiv.editor.graphics.images.EditorIcon;

/**
 * The <code>AboutForm</code> class is the dialog displaying information about application.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class AboutForm extends InfoDialog {

    private static final long serialVersionUID = -4631230976081227814L;

    /** The size of the title font */
    private static final int TITLE_FONT = 12;

    /** The single instance of the dialog */
    private static AboutForm instance;

    /**
     * Initializes a newly created <code>AboutForm</code> with its title.
     */
    public AboutForm() {
        super("frame.about.title");
    }

    /**
     * Creates and shows the dialog with information about application.
     */
    public static void showDialog() {
        instance = new AboutForm();
        instance.setVisible(true);
    }

    @Override
    protected JPanel createContent() {
        JPanel content = new JPanel();
        JPanel panelImage = new JPanel();
        JLabel logoLabel = new JLabel();

        logoLabel.setIcon(EditorIcon.createLargeEditorIcon());
        panelImage.add(logoLabel);

        JPanel panelText = new JPanel();
        panelText.setLayout(new BoxLayout(panelText, BoxLayout.Y_AXIS));
        panelText.setBorder(BorderFactory.createEmptyBorder(HORIZONTAL_MARGIN, VERTICAL_MARGIN,
                HORIZONTAL_MARGIN, VERTICAL_MARGIN));

        JLabel titleLabel = new JLabel(ResourceController.getMessage("editor.title"));
        titleLabel.setFont(new Font("SansSerif", Font.BOLD, TITLE_FONT));
        titleLabel.setBorder(BorderFactory.createEmptyBorder(0, 0, 10, 30));

        panelText.add(titleLabel);
        panelText.add(Box.createHorizontalGlue());
        panelText.add(new JLabel(ResourceController.getMessage("frame.about.version",
                OptionItems.APPLICATION_VERSION)));
        panelText.add(new JLabel(ResourceController.getMessage("frame.about.author")));

        content.add(panelImage, BorderLayout.WEST);
        content.add(panelText, BorderLayout.EAST);
        return content;
    }
}
