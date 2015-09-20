package cz.zcu.fav.kiv.editor.controller;

import javax.swing.UIManager;
import cz.zcu.fav.kiv.editor.beans.ConfigData;
import cz.zcu.fav.kiv.editor.controller.logger.Log;
import cz.zcu.fav.kiv.editor.controller.options.OptionController;
import cz.zcu.fav.kiv.editor.graphics.MainFrame;
import cz.zcu.fav.kiv.editor.graphics.intro.IntroException;
import cz.zcu.fav.kiv.editor.graphics.intro.IntroFrame;
import cz.zcu.fav.kiv.editor.graphics.intro.ProgressBar;
import cz.zcu.fav.kiv.editor.utils.ErrorDialog;

/**
 * The <code>MainController</code> class is the main control class of the application. Controls
 * loading of configurations files and creating of the application GUI.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class MainController {

    /**
     * Main class that controls loading of configurations files and creating of the application GUI.
     * 
     * @param args
     *            main application arguments.
     * @throws Exception
     *             if an fatal error occurs in the application.
     */
    public static void main(String args[]) throws Exception {

        try {
            UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());

            OptionController.readOptions();

            IntroFrame introFrame = new IntroFrame();
            ConfigData data = ProgressBar.getData();
            introFrame.hideFrame();

            MainFrame.createFrame(data).go();
        } catch (IntroException introEx) {
        } catch (Exception ex) {
            Log.fatal(ex);
            ErrorDialog.showDialog(ex);
            System.exit(1);
        }

    }
}
