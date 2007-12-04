package cz.zcu.fav.kiv.editor.graphics.components.parameters;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.event.FocusEvent;
import java.awt.event.FocusListener;
import javax.swing.JDialog;
import javax.swing.JEditorPane;
import javax.swing.JLabel;
import javax.swing.JScrollPane;

import cz.zcu.fav.kiv.editor.graphics.MainFrame;

/**
 * The <code>DescriptionForm</code> class is the dialog displaying parameter description.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class DescriptionForm extends JDialog implements FocusListener {

    private static final long serialVersionUID = -4632340976081227454L;

    /** The width of the dialog */
    private static final int WIDTH = 300;

    /** The height width of the dialog */
    private static final int HEIGHT = 150;

    /** The color of the background dialog */
    private static final Color BACKGROUND_COLOR = new Color(255, 255, 225);

    /** The single instance of the dialog */
    private static DescriptionForm instance;

    /** The inner width of the dialog */
    private JEditorPane contentArea;

    /**
     * Creates and shows the dialog with parameter description.
     * 
     * @param content
     *            the description of parameter.
     * @param label
     *            the label with parameter name.
     */
    public static void showDialog(String content, JLabel label) {
        instance = getInstance();
        instance.setContentArea(content);
        instance.setLocationRelativeTo(label);
        instance.setVisible(true);
    }

    /**
     * Gets the single instance of the dialog with parameter description.
     * 
     * @return the single instance of the dialog with parameter description.
     */
    private static DescriptionForm getInstance() {
        if (instance == null)
            instance = new DescriptionForm();
        return instance;
    }

    /**
     * Initializes a newly created <code>DescriptionForm</code>.
     */
    private DescriptionForm() {
        super(MainFrame.getInstance());

        this.setLayout(new BorderLayout());

        contentArea = new JEditorPane();
        contentArea.setEditable(false);
        contentArea.setContentType("text/html");

        contentArea.setBackground(BACKGROUND_COLOR);

        JScrollPane scrollBar = new JScrollPane(contentArea);
        scrollBar.setPreferredSize(new Dimension(WIDTH, HEIGHT));
        this.add(scrollBar, BorderLayout.PAGE_START);

        contentArea.addFocusListener(this);
        this.setUndecorated(true);
        pack();
    }

    /**
     * Action performed when the dialog gains focus - does nothing.
     */
    public void focusGained(FocusEvent event) {
    }

    /**
     * Action performed when the dialog losts focus - hides the dialog.
     */
    public void focusLost(FocusEvent event) {
        this.setVisible(false);
    }

    /**
     * Sets a new parameter description to the content of the dialog.
     * 
     * @param content
     *            the description of a parameter.
     */
    public void setContentArea(String content) {
        this.contentArea.setText(content);
    }
}
