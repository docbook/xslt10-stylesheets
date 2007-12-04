package cz.zcu.fav.kiv.editor.controller;

import cz.zcu.fav.kiv.editor.controller.options.OptionItems;
import cz.zcu.fav.kiv.editor.graphics.console.MessageConsole;

/**
 * The <code>MessageWriter</code> class provides methods for writting down information and errors
 * to the editor console.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class MessageWriter {
    /**
     * Writes a normal information to the editor console.
     * 
     * @param message
     *            the normal text message.
     */
    public static void write(String message) {
        MessageConsole.logMessage(message);
    }

    /**
     * Writes an emphasis information to the editor console.
     * 
     * @param message
     *            the normal text message.
     */
    public static void writeEmphasis(String message) {
        MessageConsole.logMessageEmphasis(message);
    }
    
    /**
     * Writes a title to the editor console.
     * 
     * @param message
     *            the message containing title.
     */
    public static void writeTitle(String message) {
        if (OptionItems.ERASE_CONSOLE)
            MessageWriter.eraseConsole();
        MessageConsole.logTitle(message);
    }

    /**
     * Writes a warning message to the editor console.
     * 
     * @param message
     *            the message containing warning.
     */
    public static void writeWarning(String message) {
        MessageConsole.logWarning(message);
    }

    /**
     * Writes an error message to the editor console.
     * 
     * @param message
     *            the message containing error.
     */
    public static void writeError(String message) {
        MessageConsole.logError(message);
    }

    /**
     * Writes an information message to the editor console.
     * 
     * @param message
     *            the message containing information.
     */
    public static void writeInfo(String message) {
        MessageConsole.logInfo(message);
    }

    /**
     * Erases the editor console.
     */
    public static void eraseConsole() {
        MessageConsole.eraseConsole();
    }
}
