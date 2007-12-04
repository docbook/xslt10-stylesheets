package cz.zcu.fav.kiv.editor.controller;

import java.io.File;

import cz.zcu.fav.kiv.editor.beans.ConfigData;
import cz.zcu.fav.kiv.editor.beans.OpenFile;
import cz.zcu.fav.kiv.editor.controller.errors.OpenFileException;
import cz.zcu.fav.kiv.editor.controller.errors.SaveFileException;
import cz.zcu.fav.kiv.editor.controller.logger.Log;
import cz.zcu.fav.kiv.editor.controller.options.OptionController;
import cz.zcu.fav.kiv.editor.controller.options.OptionItems;
import cz.zcu.fav.kiv.editor.controller.resource.ResourceController;
import cz.zcu.fav.kiv.editor.stylesheet.XslParser;
import cz.zcu.fav.kiv.editor.template.TemplateConst;
import cz.zcu.fav.kiv.editor.template.TemplateController;
import cz.zcu.fav.kiv.editor.utils.RunBatch;

/**
 * The <code>MenuController</code> class contains method that are called for every item from the
 * application GUI.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class MenuController {

    /**
     * Creates a new empty stylesheet file, sets default values to the GUI editor element.
     * 
     * @param configData
     *            the data containing editor data structure.
     * @param openFile
     *            the structure containing information about actually opened file.
     */
    public static void newFileEmptyItem(ConfigData configData, OpenFile openFile) {
        MessageWriter.writeTitle(ResourceController.getMessage("new_file.title"));
        configData.clearValues();        
        openFile.setOpenFilePath(null);
        openFile.setWholeFile(XslParser.createXsltFile());
        MessageWriter.writeInfo(ResourceController.getMessage("new_file.empty.info"));
    }

    /**
     * Creates a new stylesheet file and sets values to the GUI editor element according to the
     * default template.
     * 
     * @param configData
     *            the data containing editor data structure.
     * @param openFile
     *            the structure containing information about actually opened file.
     */
    public static void newFileDefaultItem(ConfigData configData, OpenFile openFile) {
        MessageWriter.writeTitle(ResourceController.getMessage("new_file.title"));
        configData.clearValues();
        // load default template
        try {
            TemplateController.getInstance().readTemplate(configData,
                    TemplateConst.CONF_FILE_TEMPLATE);
            MessageWriter.writeInfo(ResourceController.getMessage("new_file.default.info"));
        } catch (Throwable ex) {
            MessageWriter.writeError(ex.getMessage());
        }
        openFile.setOpenFilePath(null);
        openFile.setWholeFile(XslParser.createXsltFile());
    }

    /**
     * Creates a new stylesheet file and sets values to the GUI editor element according to the user
     * template.
     * 
     * @param configData
     *            the data containing editor data structure.
     * @param openFile
     *            the structure containing information about actually opened file.
     * @param templateFile
     *            the file containing user template.
     */
    public static void newFileStylesheetItem(ConfigData configData, OpenFile openFile,
            String templateFile) {
        MessageWriter.writeTitle(ResourceController.getMessage("new_file.title"));
        configData.clearValues();
        // load user template
        try {
            TemplateController.getInstance().readTemplate(configData, templateFile);
            MessageWriter.writeInfo(ResourceController.getMessage("new_file.stylesheet.info",
                    templateFile));
        } catch (Throwable ex) {
            MessageWriter.writeError(ex.getMessage());
        }
        openFile.setOpenFilePath(null);
        openFile.setWholeFile(XslParser.createXsltFile());
    }

    /**
     * Opens specified XSL stylesheet file.
     * 
     * @param configData
     *            the data containing editor data structure.
     * @param file
     *            the XSL stylesheet file for opening.
     * @param openFile
     *            the structure containing information about actually opened file.
     */
    public static void openFileItem(ConfigData configData, String file, OpenFile openFile) {
        try {
            MessageWriter.writeTitle(ResourceController.getMessage("open_file.title"));

            configData.clearValues();
            openFile.setOpenFilePath(file);
            openFile.setWholeFile(XslParser.readXsltFile(file, configData));            

            MessageWriter.writeInfo(ResourceController.getMessage("open_file.success_info", file));
        } catch (OpenFileException ex) {
            MessageWriter.writeError(ex.getMessage());
        }
    }

    /**
     * Saves actually opened XSL stylesheet in the file with specified name.
     * 
     * @param configData
     *            the data containing editor data structure.
     * @param saveFile
     *            the name of the file where the XSL stylesheet will be saved.
     * @param openFile
     *            the structure containing information about actually opened file.
     */
    public static void saveAsFileItem(ConfigData configData, String saveFile, OpenFile openFile) {
        openFile.setOpenFilePath(saveFile);
        saveFileItem(configData, openFile);
    }

    /**
     * Saves changes of the actually opened XSL stylesheet file.
     * 
     * @param configData
     *            the data containing editor data structure.
     * @param openFile
     *            the structure containing information about actually opened file.
     */
    public static void saveFileItem(ConfigData configData, OpenFile openFile) {
        try {
            MessageWriter.writeTitle(ResourceController.getMessage("save_file.title"));
            // remove comments
            if (OptionItems.REARRANGE_SAVE)
                XslParser.removeComments(openFile.getWholeFile());

            XslParser.saveXsltFile(openFile.getOpenFilePath(), openFile.getWholeFile(), configData);
            openFile.setFileChanged(false);
            MessageWriter.writeInfo(ResourceController.getMessage("save_file.success_info",
                    openFile.getOpenFilePath()));
        } catch (SaveFileException ex) {
            MessageWriter.writeError(ResourceController.getMessage("error.save_file", openFile
                    .getWholeFile())
                    + ex.getMessage());
        }
    }

    /**
     * Stores editor options in the application cofiguration file.
     */
    public static void exitItem() {
        OptionController.storeOptionItems();
    }

    /**
     * Launches a selected batch file.
     * 
     * @param openFile
     *            the structure containing information about actually opened file.
     */
    public static void runBatchFile(OpenFile openFile) {
        MessageWriter.writeTitle(ResourceController.getMessage("run_batch_file.title"));
        if (openFile.getOpenFilePath() == null) {
            MessageWriter.writeError(ResourceController.getMessage("run_batch_file.not_saved"));
            return;
        }
        // exists batch file?
        if (!(new File(OptionItems.BATCH_FILE)).exists()) {
            MessageWriter.writeError(ResourceController
                    .getMessage("run_batch_file.file_not_exists"));
            return;
        }
        try {
            MessageWriter.writeInfo(ResourceController.getMessage("run_batch_file.running",
                    OptionItems.BATCH_FILE));
            RunBatch.replaceXslName(OptionItems.BATCH_FILE, openFile.getOpenFilePath());
            RunBatch.execBatch();
        } catch (Throwable ex) {
            Log.error(ex);
            MessageWriter.writeError(ResourceController.getMessage("run_batch_file.error_running",
                    OptionItems.BATCH_FILE));
        }
    }
}
