package cz.zcu.fav.kiv.editor.graphics.console;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.GridLayout;

import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextPane;
import javax.swing.text.BadLocationException;
import javax.swing.text.MutableAttributeSet;
import javax.swing.text.SimpleAttributeSet;
import javax.swing.text.StyleConstants;
import javax.swing.text.StyledDocument;

import cz.zcu.fav.kiv.editor.controller.logger.Log;
import cz.zcu.fav.kiv.editor.controller.resource.ResourceController;
import cz.zcu.fav.kiv.editor.graphics.components.editor.EditorBody;

/**
 * The <code>MessageConsole</code>class represents the output console that displays messages,
 * errors and warnings to user.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class MessageConsole extends JPanel {

    private static final long serialVersionUID = 5544740912147120927L;

    /** The size of the console height */
    private static final int FRAME_CONSOLE_HEIGHT = 70;

    /** The char specifying the end of line used in the console */
    private static final String NEWLINE = "\n";

    /** The size of font used in the console */
    private static final int FONT_SIZE = 12;

    /** The single instance of the console */
    private static MessageConsole instance;

    /** The mutable attribute set of the <code>JTextPane</code> */
    private MutableAttributeSet mutAttr;

    /** The styled document of the <code>JTextPane</code> */
    private StyledDocument styledDoc;

    /** The text pane creating the content of the console */
    private JTextPane editor;

    /**
     * Singleton constructor - gets the single instance of the <code>MessageConsole</code> class.
     * 
     * @return the single instance of <code>MessageConsole</code>.
     */
    public static MessageConsole getInstance() {
        if (instance == null)
            instance = new MessageConsole();
        return instance;
    }

    /**
     * Initializes a newly created <code>MessageConsole</code>.
     */
    private MessageConsole() {
        this.setLayout(new GridLayout(1, 1));

        editor = new JTextPane();
        editor.setEditable(false);
        editor.setFont(new Font("DialogInput", Font.PLAIN, FONT_SIZE));
        mutAttr = new SimpleAttributeSet();
        styledDoc = editor.getStyledDocument();
        StyleConstants.setForeground(mutAttr, Color.black);

        JScrollPane scrollBar = new JScrollPane(editor);
        scrollBar.setPreferredSize(new Dimension(EditorBody.PANEL_WIDTH, FRAME_CONSOLE_HEIGHT));

        add(scrollBar, BorderLayout.CENTER);
    }

    /**
     * Appends the input text to the console.
     * 
     * @param message
     *            the text that will be appended to the console.
     */
    private void appendText(String message) {
        try {
            styledDoc.insertString(styledDoc.getLength(), message, mutAttr);
            editor.setCaretPosition(styledDoc.getLength());
        } catch (BadLocationException ex) {
            Log.error(ex);
        }
    }

    /**
     * Erases the content of the whole console.
     */
    private void erase() {
        try {
            styledDoc.remove(0, styledDoc.getLength());
        } catch (BadLocationException ex) {
            Log.error(ex);
        }
    }

    /**
     * Appends to the console a new line.
     * 
     * @param message
     *            the text that will be appended to the console as a new line.
     */
    private void appendLine(String message) {
        appendText(message + NEWLINE);
    }

    /**
     * Appends to the console a new word.
     * 
     * @param message
     *            the text that will be appended to the console as a new word.
     */
    private void appendWord(String message) {
        appendText(message);
    }

    /**
     * Writes a normal information to the console.
     * 
     * @param message
     *            the normal text message.
     */
    public static void logMessage(String message) {
        StyleConstants.setForeground(MessageConsole.getInstance().getMutAttr(), Color.black);
        MessageConsole.getInstance().appendLine(message);
    }
    
    /**
     * Writes a emphasis information to the console.
     * 
     * @param message
     *            the normal text message.
     */
    public static void logMessageEmphasis(String message) {
        StyleConstants.setForeground(MessageConsole.getInstance().getMutAttr(), Color.black);
        StyleConstants.setBold(MessageConsole.getInstance().getMutAttr(), true);
        MessageConsole.getInstance().appendLine(message);
    }

    /**
     * Writes a warning message to the console.
     * 
     * @param message
     *            the message containing warning.
     */
    public static void logWarning(String message) {
        StyleConstants.setForeground(MessageConsole.getInstance().getMutAttr(), new Color(0, 64,
                128));
        StyleConstants.setBold(MessageConsole.getInstance().getMutAttr(), true);
        MessageConsole.getInstance().appendWord(
                ResourceController.getMessage("message_writer.warning"));
        StyleConstants.setBold(MessageConsole.getInstance().getMutAttr(), false);
        StyleConstants.setForeground(MessageConsole.getInstance().getMutAttr(), Color.black);
        MessageConsole.getInstance().appendLine(message);
    }

    /**
     * Writes an error message to the console.
     * 
     * @param message
     *            the message containing error.
     */
    public static void logError(String message) {
        StyleConstants.setForeground(MessageConsole.getInstance().getMutAttr(), new Color(208, 9,
                32));
        StyleConstants.setBold(MessageConsole.getInstance().getMutAttr(), true);
        MessageConsole.getInstance().appendWord(
                ResourceController.getMessage("message_writer.error"));
        MessageConsole.getInstance().appendLine(message);
        StyleConstants.setBold(MessageConsole.getInstance().getMutAttr(), false);
    }

    /**
     * Writes an information message to the console.
     * 
     * @param message
     *            the message containing information.
     */
    public static void logInfo(String message) {
        StyleConstants.setForeground(MessageConsole.getInstance().getMutAttr(), new Color(217, 121,
                36));
        StyleConstants.setBold(MessageConsole.getInstance().getMutAttr(), true);
        MessageConsole.getInstance().appendWord(
                ResourceController.getMessage("message_writer.info"));
        StyleConstants.setBold(MessageConsole.getInstance().getMutAttr(), false);
        StyleConstants.setForeground(MessageConsole.getInstance().getMutAttr(), Color.black);
        MessageConsole.getInstance().appendLine(message);
    }

    /**
     * Writes a title to the console.
     * 
     * @param message
     *            the message containing title.
     */
    public static void logTitle(String message) {
        StyleConstants.setBold(MessageConsole.getInstance().getMutAttr(), true);
        StyleConstants.setForeground(MessageConsole.getInstance().getMutAttr(),
                new Color(128, 0, 0));
        MessageConsole.getInstance().appendLine(" * * * " + message.toUpperCase() + " * * *");
        StyleConstants.setBold(MessageConsole.getInstance().getMutAttr(), false);
    }

    /**
     * Erases the content of the console.
     */
    public static void eraseConsole() {
        MessageConsole.getInstance().erase();
    }

    public MutableAttributeSet getMutAttr() {
        return mutAttr;
    }
}
