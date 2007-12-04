package cz.zcu.fav.kiv.editor.controller.logger;

import java.io.PrintWriter;
import java.io.StringWriter;

import org.apache.log4j.Level;
import org.apache.log4j.Logger;

import cz.zcu.fav.kiv.editor.controller.resource.ErrorResourceController;

/**
 * The <code>Log</code> class is used for logging all errors and debug messages in the editor.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class Log {
    /**
     * Logs the error with its error tracing and description obtained by
     * <code>ErrorResourceController</code>.
     * 
     * @param resource
     *            the resource key of the error description.
     * @param ex
     *            the rised error.
     */
    public static void error(String resource, Throwable ex) {
        Logger.getRootLogger().log(Level.ERROR, ErrorResourceController.getMessage(resource) + "\n" + getStackTrace(ex));
    }

    /**
     * Logs the error with its error tracing and description.
     * 
     * @param text
     *            the error description.
     * @param ex
     *            the rised error.
     */
    public static void errorText(String text, Throwable ex) {
        Logger.getRootLogger().log(Level.ERROR, text +"\n"+ getStackTrace(ex));
    }

    /**
     * Logs the error with its error tracing.
     * 
     * @param ex
     *            the rised error.
     */
    public static void error(Throwable ex) {
        Logger.getRootLogger().log(Level.ERROR, getStackTrace(ex));
    }

    /**
     * Logs the information with its description obtained by <code>ErrorResourceController</code>
     * with arguments.
     * 
     * @param resource
     *            the resource key of the error description.
     * @param args
     *            the arguments of the description.
     */
    public static void info(String resource, Object... args) {
        Logger.getRootLogger().info(ErrorResourceController.getMessage(resource, args));
    }

    /**
     * Logs the warning with its error tracing and description obtained by
     * <code>ErrorResourceController</code>.
     * 
     * @param resource
     *            the resource key of the error description.
     * @param ex
     *            the rised error.
     */
    public static void warn(String resource, Throwable ex) {
        Logger.getRootLogger().log(Level.WARN, ErrorResourceController.getMessage(resource) +"\n"+ getStackTrace(ex));
    }

    /**
     * Logs the warning with its error tracing and description obtained by
     * <code>ErrorResourceController</code> with arguments.
     * 
     * @param resource
     *            the resource key of the warning description.
     * @param ex
     *            the rised warning.
     * @param args
     *            the arguments of the description.
     */
    public static void warn(String resource, Throwable ex, Object... args) {
        Logger.getRootLogger().log(Level.WARN, ErrorResourceController.getMessage(resource, args) +"\n"+ getStackTrace(ex));
    }

    /**
     * Logs the warning with its error tracing.
     * 
     * @param ex
     *            the rised warning.
     */
    public static void warn(Throwable ex) {
        Logger.getRootLogger().log(Level.WARN, getStackTrace(ex));
    }

    /**
     * Logs the fatal error with its error tracing.
     * 
     * @param ex
     *            the rised fatal error.
     */
    public static void fatal(Throwable ex) {
        Logger.getRootLogger().log(Level.FATAL, getStackTrace(ex));
    }
    
    public static String getStackTrace(Throwable t) {
        StringWriter sw = new StringWriter();
        PrintWriter pw = new PrintWriter(sw);
        t.printStackTrace(pw);
        pw.flush();
        return sw.toString();
    }
}
