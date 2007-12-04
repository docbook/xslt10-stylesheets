package cz.zcu.fav.kiv.editor.controller;

import cz.zcu.fav.kiv.editor.beans.ConfigData;
import cz.zcu.fav.kiv.editor.config.ConfigController;
import cz.zcu.fav.kiv.editor.config.ParamController;
import cz.zcu.fav.kiv.editor.config.constants.FileConst;
import cz.zcu.fav.kiv.editor.controller.logger.Log;
import cz.zcu.fav.kiv.editor.controller.resource.ResourceController;

/**
 * The <code>ProgressControl</code> class controls the progress of configuration files loading.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class ProgressControl {
    /** The numerical representation of the loading progress */
    private int current = 0;

    /** The flag indicating if the loading progress has already finished */
    private boolean done = false;

    /** The flag indicating if the loading progress is canceled */
    private boolean canceled = false;

    /** The message containing information about the loading progress */
    private static String statMessage;

    /** The message containing error rised during the loading progress */
    private String errorMessage;

    /** The char representing a new line */
    private final static String NEWLINE = "\n";

    /** The controll class containing methods for loading configuration files */
    private ConfigController config;

    /**
     * Returns editor data structure loaded from configuration files.
     * 
     * @return the editor data structure loaded from configuration files.
     */
    public ConfigData getData() {
        return config.getData();
    }

    /**
     * Initializes a newly created empty <code>ProgressControl</code>.
     */
    public ProgressControl() {
    }

    /**
     * Launches the thread which loads configuration files.
     */
    public void go() {
        ConfigThread con = new ConfigThread();
        con.setPriority(1);
        con.start();
        try {
            con.join();
        } catch (InterruptedException ex) {
            Log.warn(ex);
        }
    }

    /**
     * Called from <code>ProgressBar</code> to find out how much has been done.
     * 
     * @return the number indicating the loading progress.
     */
    public int getCurrent() {
        return current;
    }

    /**
     * Called from <code>ProgressBar</code> to find out if the task has completed.
     * 
     * @return true if the task is done.
     */
    public boolean isDone() {
        return done;
    }

    /**
     * Called from <code>ProgressBar</code> to find out if the task is canceled.
     * 
     * @return true if the task is camceled.
     */
    public boolean isCanceled() {
        return canceled;
    }

    /**
     * Returns the most recent status message.
     * 
     * @return the most recent status message.
     */
    public String getMessage() {
        return statMessage;
    }

    /**
     * The <code>ConfigThread</code> class is a thread used for controling the progress of
     * configuration files loading.
     * 
     * @author Marta Vaclavikova
     * @version 1.0, 05/2007
     */
    class ConfigThread extends Thread {
        public void run() {
            try {
                statMessage = "";
                config = new ConfigController();

                config.readTypes();
                current = 10;
                statMessage += ResourceController.getMessage("frame.intro.progress.read_file", FileConst.CONF_FILE_TYPE) + NEWLINE;
                Thread.yield();
                
                config.readAttributes();
                current = 20;
                statMessage += ResourceController.getMessage("frame.intro.progress.read_file", FileConst.CONF_FILE_ATTRIBUTES) + NEWLINE;
                Thread.yield();
                
                config.readConfig();
                current = 30;
                statMessage += ResourceController.getMessage("frame.intro.progress.read_file", FileConst.CONF_FILE_CONFIG) + NEWLINE;
                Thread.yield();

                ParamController configXml = new ParamController(config.getData(), config.getCommonTypes());         
                configXml.readParameters();
                current = 75;
                 
                config.readFigures(configXml.getParsedParameterList());
                current = 80;
                statMessage += ResourceController.getMessage("frame.intro.progress.read_file", FileConst.CONF_FILE_FIGURES) + NEWLINE;
                Thread.yield();
                
                configXml.readProperties();
                current = 100;                
                configXml.removeInvalidParam(config.getFigureList());
                
                statMessage += ResourceController.getMessage("frame.intro.progress.read_ok") + NEWLINE;
                done = true;
            } catch (Throwable ex) {
                canceled = true;
                errorMessage = ex.getMessage() + NEWLINE + NEWLINE;
                errorMessage += ResourceController.getMessage("frame.intro.progress.correct_error");
                Log.errorText(ex.getMessage(), ex);
                return;
            }
        }
    }

    /**
     * Returns the error message.
     * 
     * @return the error message.
     */
    public String getErrorMessage() {
        return errorMessage;
    }

    public static void addStatMessage(String statMessage) {
        ProgressControl.statMessage += statMessage + NEWLINE;
    }
}
