package cz.zcu.fav.kiv.editor.graphics;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;
import java.io.File;

import javax.swing.JCheckBoxMenuItem;
import javax.swing.JFileChooser;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import javax.swing.KeyStroke;

import cz.zcu.fav.kiv.editor.controller.MenuController;
import cz.zcu.fav.kiv.editor.controller.options.OptionItems;
import cz.zcu.fav.kiv.editor.controller.resource.ResourceController;
import cz.zcu.fav.kiv.editor.graphics.frames.AboutForm;
import cz.zcu.fav.kiv.editor.graphics.frames.ConfigInfoForm;
import cz.zcu.fav.kiv.editor.graphics.frames.HelpFrame;
import cz.zcu.fav.kiv.editor.graphics.options.OptionEditorDialog;
import cz.zcu.fav.kiv.editor.graphics.options.OptionStylesheetDialog;
import cz.zcu.fav.kiv.editor.graphics.utils.OverwriteFileDialog;
import cz.zcu.fav.kiv.editor.graphics.utils.SaveFileDialog;
import cz.zcu.fav.kiv.editor.graphics.utils.XmlFilter;
import cz.zcu.fav.kiv.editor.graphics.utils.XslFilter;
import cz.zcu.fav.kiv.editor.template.TemplateConst;

/**
 * The <code>TopMenu</code> class represents the main menu of the application.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class TopMenu extends JMenuBar {

    private static final long serialVersionUID = 6053686624644714331L;

    /** The reference to the main frame <code>MainFrame</code> */
    private MainFrame frame;

    /* ---------------------- file menu ---------------------------- */

    /** The file menu */
    private static JMenu fileMenu = new JMenu();

    /** The item 'exit' from the file menu */
    private static JMenuItem exitFileMenuItem = new JMenuItem();

    /** The submenu item of the item 'new' from the file menu */
    private static JMenu submenuNewFile = new JMenu();

    /** The item 'new empty stylesheet' of the file submenu 'new' */
    private static JMenuItem newFileMenuEmptyItem = new JMenuItem();

    /** The item 'new default stylesheet' of the file submenu 'new' */
    private static JMenuItem newFileMenuDefaultItem = new JMenuItem();

    /** The item 'new user stylesheet' of the file submenu 'new' */
    private static JMenuItem newFileMenuStylesheetItem = new JMenuItem();

    /** The item 'open' of the file menu */
    private static JMenuItem openFileMenuItem = new JMenuItem();

    /** The item 'close' of the file menu */
    private static JMenuItem closeFileMenuItem = new JMenuItem();

    /** The item 'save' of the file menu */
    private static JMenuItem saveFileMenuItem = new JMenuItem();

    /** The item 'save as' of the file menu */
    private static JMenuItem saveAsFileMenuItem = new JMenuItem();

    /* ---------------------- run menu ---------------------------- */
    /** The run menu */
    private static JMenu runMenu = new JMenu();

    /** The item 'run batch' from the run menu */
    private static JMenuItem runBatchMenuItem = new JMenuItem();

    /** The item 'select batch' from the run menu */
    private static JMenuItem selectBatchMenuItem = new JMenuItem();

    /** The item 'save batch before' from the run menu */
    private static JCheckBoxMenuItem batchSaveBeforeMenuItem = new JCheckBoxMenuItem();

    /* ---------------------- option menu ---------------------------- */
    /** The option menu */
    private static JMenu optionMenu = new JMenu();

    /** The item 'stylesheet option' from the option menu */
    private static JMenuItem optionStylesheetMenuItem = new JMenuItem();

    /** The item 'editor option' from the option menu */
    private static JMenuItem optionEditorMenuItem = new JMenuItem();

    /* ---------------------- help menu ---------------------------- */
    /** The help menu */
    private static JMenu helpMenu = new JMenu();

    /** The item 'help contents' from the help menu */
    private static JMenuItem helpWindowMenuItem = new JMenuItem();

    /** The item 'about' from the help menu */
    private static JMenuItem aboutHelpMenuItem = new JMenuItem();

    /** The item 'config info' from the help menu */
    private static JMenuItem configInfoMenuItem = new JMenuItem();

    /** The file chooser */
    private JFileChooser fileChooser = new JFileChooser();

    /** The batch file chooser */
    private JFileChooser batchFileChooser = new JFileChooser();
    
    /**
     * Initializes a newly created <code>TopMenu</code> of the main frame <code>MainFrame</code>.
     * Creates all items of the menu.
     * 
     * @param frame
     *            the main application frame.
     */
    public TopMenu(MainFrame frame) {
        this.frame = frame;

        /* ---------------------- file ---------------------------- */
        setMenuItem(fileMenu, "menu.file");

        // new
        submenuNewFile.setToolTipText(ResourceController.getMessage("menu_item.new.tooltip"));
        setMenuItem(submenuNewFile, "menu_item.new");
        fileMenu.add(submenuNewFile);

        // new file - empty stylesheet
        setMenuItem(newFileMenuEmptyItem, "menu_item.new_empty");
        newFileMenuEmptyItem.setToolTipText(ResourceController
                .getMessage("menu_item.new_empty.tooltip"));
        newFileMenuEmptyItem.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent evt) {
                newFileEmptyMenuItemActionPerformed();
            }
        });
        submenuNewFile.add(newFileMenuEmptyItem);

        // new file - default stylesheet
        setMenuItem(newFileMenuDefaultItem, "menu_item.new_default");
        newFileMenuDefaultItem.setToolTipText(ResourceController
                .getMessage("menu_item.new_default.tooltip"));
        newFileMenuDefaultItem.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent evt) {
                newFileDefaultMenuItemActionPerformed();
            }
        });
        submenuNewFile.add(newFileMenuDefaultItem);

        // new file - user stylesheet
        setMenuItem(newFileMenuStylesheetItem, "menu_item.new_stylesheet");
        newFileMenuStylesheetItem.setToolTipText(ResourceController
                .getMessage("menu_item.new_stylesheet.tooltip"));
        newFileMenuStylesheetItem.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent evt) {
                newFileStylesheetMenuItemActionPerformed();
            }
        });
        submenuNewFile.add(newFileMenuStylesheetItem);

        // open
        setMenuItem(openFileMenuItem, "menu_item.open");
        openFileMenuItem.setToolTipText(ResourceController.getMessage("menu_item.open.tooltip"));
        openFileMenuItem.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent evt) {
                openFileMenuItemActionPerformed();
            }
        });
        fileMenu.add(openFileMenuItem);

        fileMenu.addSeparator();

        // close
        setMenuItem(closeFileMenuItem, "menu_item.close");
        closeFileMenuItem.setToolTipText(ResourceController.getMessage("menu_item.close.tooltip"));
        closeFileMenuItem.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent evt) {
                newFileEmptyMenuItemActionPerformed();
            }
        });
        fileMenu.add(closeFileMenuItem);

        fileMenu.addSeparator();

        // save
        setMenuItem(saveFileMenuItem, "menu_item.save");
        saveFileMenuItem.setToolTipText(ResourceController.getMessage("menu_item.save.tooltip"));
        saveFileMenuItem.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent evt) {
                saveFileMenuItemActionPerformed();
            }
        });
        saveFileMenuItem.setAccelerator(KeyStroke
                .getKeyStroke(KeyEvent.VK_S, ActionEvent.CTRL_MASK));
        fileMenu.add(saveFileMenuItem);

        // save as
        setMenuItem(saveAsFileMenuItem, "menu_item.save_as");
        saveAsFileMenuItem.setToolTipText(ResourceController
                .getMessage("menu_item.save_as.tooltip"));
        saveAsFileMenuItem.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent evt) {
                saveAsFileMenuItemActionPerformed();
            }
        });
        fileMenu.add(saveAsFileMenuItem);

        fileMenu.addSeparator();

        // exit
        setMenuItem(exitFileMenuItem, "menu_item.exit");
        exitFileMenuItem.setToolTipText(ResourceController.getMessage("menu_item.exit.tooltip"));
        exitFileMenuItem.addActionListener(new ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                exitFileMenuItemActionPerformed();
            }
        });
        fileMenu.add(exitFileMenuItem);

        this.add(fileMenu);

        /* ---------------------- run ---------------------------- */
        setMenuItem(runMenu, "menu_item.run");

        setMenuItem(runBatchMenuItem, "menu_item.run_batch");
        runBatchMenuItem.setToolTipText(ResourceController
                .getMessage("menu_item.run_batch.tooltip"));
        runBatchMenuItem.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent evt) {
                runBatchMenuItemActionPerformed();
            }
        });
        runBatchMenuItem.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_F9, 0));
        runMenu.add(runBatchMenuItem);

        setMenuItem(selectBatchMenuItem, "menu_item.run_edit_batch");
        selectBatchMenuItem.setToolTipText(ResourceController
                .getMessage("menu_item.run_edit_batch.tooltip"));
        selectBatchMenuItem.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent evt) {
                selectBatchMenuItemActionPerformed();
            }
        });
        runMenu.add(selectBatchMenuItem);

        setMenuItem(batchSaveBeforeMenuItem, "menu_item.run_batch_save");
        batchSaveBeforeMenuItem.setToolTipText(ResourceController
                .getMessage("menu_item.run_batch_save.tooltip"));
        batchSaveBeforeMenuItem.setSelected(OptionItems.SAVE_BEFORE_RUN);
        batchSaveBeforeMenuItem.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent evt) {
                batchSaveBeforeMenuItemActionPerformed();
            }
        });
        runMenu.add(batchSaveBeforeMenuItem);

        this.add(runMenu);

        /* ---------------------- options ---------------------------- */
        setMenuItem(optionMenu, "menu_item.option");

        setMenuItem(optionStylesheetMenuItem, "menu_item.option_save");
        optionStylesheetMenuItem.setToolTipText(ResourceController
                .getMessage("menu_item.option_save.tooltip"));
        optionStylesheetMenuItem.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent evt) {
                optionStylesheetMenuItemActionPerformed();
            }
        });
        optionMenu.add(optionStylesheetMenuItem);

        setMenuItem(optionEditorMenuItem, "menu_item.option_editor");
        optionEditorMenuItem.setToolTipText(ResourceController
                .getMessage("menu_item.option_editor.tooltip"));
        optionEditorMenuItem.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent evt) {
                optionEditorMenuItemActionPerformed();
            }
        });
        optionMenu.add(optionEditorMenuItem);

        this.add(optionMenu);

        /* ---------------------- help ---------------------------- */
        setMenuItem(helpMenu, "menu_item.help");

        setMenuItem(helpWindowMenuItem, "menu_item.help_window");
        helpWindowMenuItem.setToolTipText(ResourceController
                .getMessage("menu_item.help_window.tooltip"));
        helpWindowMenuItem.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                helpWindowMenuItemActionPerformed();
            }
        });
        helpMenu.add(helpWindowMenuItem);

        setMenuItem(configInfoMenuItem, "menu_item.config");
        configInfoMenuItem
                .setToolTipText(ResourceController.getMessage("menu_item.config.tooltip"));
        configInfoMenuItem.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                configInfoMenuItemActionPerformed();
            }
        });
        helpMenu.add(configInfoMenuItem);

        setMenuItem(aboutHelpMenuItem, "menu_item.about");
        aboutHelpMenuItem.setToolTipText(ResourceController.getMessage("menu_item.about.tooltip"));
        aboutHelpMenuItem.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                aboutHelpMenuItemActionPerformed();
            }
        });
        helpMenu.add(aboutHelpMenuItem);

        this.add(helpMenu);
    }

    /**
     * Stores application options and terminates the application.
     */
    private void exitFileMenuItemActionPerformed() {
        MenuController.exitItem();
        frame.shutDown();
    }

    /**
     * Shows the dialog with information about the application.
     */
    private void aboutHelpMenuItemActionPerformed() {
        AboutForm.showDialog();
    }

    /**
     * Shows the dialog asking if the actually opened stylesheet should be saved. If the user choses
     * to save the stylesheet then the method <code>saveFileMenuItemActionPerformed()</code> is
     * called and the stylesheet is saved.
     * 
     * @return if the actual stylesheet was saved.
     */
    private boolean saveOpenedStylesheet() {
        if (frame.getOpenFile().getOpenFilePath() == null && frame.getOpenFile().isFileChanged()) {
            SaveFileDialog questionDial = SaveFileDialog.showDialog(frame);
            if (questionDial.getAnswer() == null)
                return false;
            if (questionDial.getAnswer())
                return saveFileMenuItemActionPerformed();
        }
        return true;
    }

    /**
     * Saves the actully opened stylesheet (if it is required). Then creates a new empty stylesheet.
     */
    private void newFileEmptyMenuItemActionPerformed() {
        javax.swing.SwingUtilities.invokeLater(new Runnable() {
            public void run() {
                if (saveOpenedStylesheet())
                    MenuController.newFileEmptyItem(frame.getConfigData(), frame.getOpenFile());
            }
        });
    }

    /**
     * Saves the actully opened stylesheet (if it is required). Then creates a new stylesheet
     * according to the default stylesheet template.
     */
    private void newFileDefaultMenuItemActionPerformed() {
        javax.swing.SwingUtilities.invokeLater(new Runnable() {
            public void run() {
                if (saveOpenedStylesheet())
                    MenuController.newFileDefaultItem(frame.getConfigData(), frame.getOpenFile());
            }
        });
    }

    /**
     * Saves the actully opened stylesheet (if it is required). Then shows the open file dialog and
     * user is asked to choose a user stylesheet template. Afterwards creates a new stylesheet
     * according to the chosen user template.
     */
    private void newFileStylesheetMenuItemActionPerformed() {
        if (saveOpenedStylesheet()) {
            fileChooser.setFileFilter(new XmlFilter());
            fileChooser.setSelectedFile(null);
            fileChooser.setCurrentDirectory(new File(System.getProperty("user.dir")
                    + File.separator + TemplateConst.CONF_FILE_TEMPLATE_DIR));
            int returnVal = fileChooser.showOpenDialog(frame);
            if (returnVal == JFileChooser.APPROVE_OPTION) {
                javax.swing.SwingUtilities.invokeLater(new Runnable() {
                    public void run() {
                        MenuController.newFileStylesheetItem(frame.getConfigData(), frame
                                .getOpenFile(), fileChooser.getSelectedFile().getPath().toString());
                    }
                });
            }
        }
    }

    /**
     * Saves the actully opened stylesheet (if it is required). Afterwards shows the open file
     * dialog and user is asked to choose the stylesheet file to open. Then opens the choosen
     * stylesheet file.
     */
    private void openFileMenuItemActionPerformed() {
        if (saveOpenedStylesheet()) {
            fileChooser.setFileFilter(new XslFilter());
            fileChooser.setSelectedFile(null);
            int returnVal = fileChooser.showOpenDialog(frame);
            if (returnVal == JFileChooser.APPROVE_OPTION) {
                javax.swing.SwingUtilities.invokeLater(new Runnable() {
                    public void run() {
                        MenuController.openFileItem(frame.getConfigData(), fileChooser
                                .getSelectedFile().getPath().toString(), frame.getOpenFile());
                    }
                });
            }
        }
    }

    /**
     * Saves the actually opened stylesheet file. If the stylesheet has not defined its name then
     * the method <code>saveAsFileMenuItemActionPerformed()</code> is called.
     * 
     * @return true if the stylesheet was saved.
     */
    private boolean saveFileMenuItemActionPerformed() {
        if (this.frame.getOpenFile().getOpenFilePath() == null)
            return saveAsFileMenuItemActionPerformed();
        else
            MenuController.saveFileItem(frame.getConfigData(), frame.getOpenFile());
        return true;
    }

    /**
     * Saves the actually opened stylesheet file under the chosen name. Firstly shows the save file
     * dialog and user is asked to choose a new file name or an existing file. If user chooses the
     * existing file, then he must approve that he really wants to rewrite the existing file.
     * Finally the stylesheet is saved under the chosen name.
     * 
     * @return true if the stylesheet was saved.
     */
    private boolean saveAsFileMenuItemActionPerformed() {
        fileChooser.setFileFilter(new XslFilter());
        fileChooser.setSelectedFile(null);
        int returnVal = fileChooser.showSaveDialog(frame);
        if (returnVal == JFileChooser.APPROVE_OPTION) {
            if (fileChooser.getSelectedFile().exists()) {
                OverwriteFileDialog questionDial = OverwriteFileDialog.showDialog(frame);
                if (!questionDial.getAnswer())
                    return false;
            }
            MenuController.saveAsFileItem(frame.getConfigData(), fileChooser.getSelectedFile()
                    .getPath().toString(), frame.getOpenFile());
            return true;

        }
        return false;
    }

    /**
     * Shows the dialog with stylesheet options.
     */
    private void optionStylesheetMenuItemActionPerformed() {
        javax.swing.SwingUtilities.invokeLater(new Runnable() {
            public void run() {
                OptionStylesheetDialog.showDialog();
            }
        });
    }

    /**
     * Shows the dialog with editor options.
     */
    private void optionEditorMenuItemActionPerformed() {
        javax.swing.SwingUtilities.invokeLater(new Runnable() {
            public void run() {
                OptionEditorDialog.showDialog();
            }
        });
    }

    /**
     * Shows the dialog with information about configuration files.
     */
    private void configInfoMenuItemActionPerformed() {
        javax.swing.SwingUtilities.invokeLater(new Runnable() {
            public void run() {
                ConfigInfoForm.showDialog();
            }
        });
    }

    /**
     * Launches the batch file for the actually opened XSL stylesheet.
     */
    private void runBatchMenuItemActionPerformed() {
        if (OptionItems.SAVE_BEFORE_RUN) {
            if (!saveFileMenuItemActionPerformed())
                return;
        } else {
            if (!saveOpenedStylesheet())
                return;
        }
        MenuController.runBatchFile(frame.getOpenFile());
    }

    /**
     * Shows the open file dialog and user is asked to choose a batch file. Then the chosen path to
     * the batch file is stored.
     */
    private void selectBatchMenuItemActionPerformed() {
        batchFileChooser.setFileFilter(null);
        batchFileChooser.setSelectedFile(null);
        if (OptionItems.BATCH_FILE.compareTo("") != 0)
            batchFileChooser.setSelectedFile(new File(OptionItems.BATCH_FILE));
        int returnVal = batchFileChooser.showOpenDialog(frame);
        if (returnVal == JFileChooser.APPROVE_OPTION) {
            OptionItems.BATCH_FILE = batchFileChooser.getSelectedFile().getAbsolutePath();
        }
    }

    /**
     * Changes if the actually opened XSL stylesheet should be automatically saved before launching
     * of the batch file. If the item is selected, then the XSL stylesheet is automatically saved.
     */
    private void batchSaveBeforeMenuItemActionPerformed() {
        OptionItems.SAVE_BEFORE_RUN = batchSaveBeforeMenuItem.isSelected();
    }

    /**
     * Shows the dialog with help content.
     * 
     */
    private void helpWindowMenuItemActionPerformed() {
        HelpFrame.getInstance().createHelp();
    }

    /**
     * Changes the text titles of all menu items according to the actual application language.
     */
    public static void changeLanguage() {
        javax.swing.SwingUtilities.invokeLater(new Runnable() {
            public void run() {
                setMenuItem(fileMenu, "menu.file");

                //new
                setMenuItem(submenuNewFile, "menu_item.new");
                submenuNewFile.setToolTipText(ResourceController.getMessage("menu_item.new.tooltip"));
                
                setMenuItem(newFileMenuEmptyItem, "menu_item.new_empty");
                newFileMenuEmptyItem.setToolTipText(ResourceController
                        .getMessage("menu_item.new_empty.tooltip"));
                
                setMenuItem(newFileMenuDefaultItem, "menu_item.new_default");
                newFileMenuDefaultItem.setToolTipText(ResourceController
                        .getMessage("menu_item.new_default.tooltip"));

                setMenuItem(newFileMenuStylesheetItem, "menu_item.new_stylesheet");
                newFileMenuStylesheetItem.setToolTipText(ResourceController
                        .getMessage("menu_item.new_stylesheet.tooltip"));
                
                //open
                setMenuItem(openFileMenuItem, "menu_item.open");
                openFileMenuItem.setToolTipText(ResourceController
                        .getMessage("menu_item.open.tooltip"));
                //close
                setMenuItem(closeFileMenuItem, "menu_item.close");
                closeFileMenuItem.setToolTipText(ResourceController
                        .getMessage("menu_item.close.tooltip"));
                
                //save
                setMenuItem(saveAsFileMenuItem, "menu_item.save_as");
                saveAsFileMenuItem.setToolTipText(ResourceController
                        .getMessage("menu_item.save_as.tooltip"));

                setMenuItem(saveFileMenuItem, "menu_item.save");
                saveFileMenuItem.setToolTipText(ResourceController
                        .getMessage("menu_item.save.tooltip"));

                //exit
                setMenuItem(exitFileMenuItem, "menu_item.exit");
                exitFileMenuItem.setToolTipText(ResourceController
                        .getMessage("menu_item.exit.tooltip"));

                //run
                setMenuItem(runMenu, "menu_item.run");

                setMenuItem(runBatchMenuItem, "menu_item.run_batch");
                runBatchMenuItem.setToolTipText(ResourceController
                        .getMessage("menu_item.run_batch.tooltip"));

                setMenuItem(selectBatchMenuItem, "menu_item.run_edit_batch");
                selectBatchMenuItem.setToolTipText(ResourceController
                        .getMessage("menu_item.run_edit_batch.tooltip"));

                setMenuItem(batchSaveBeforeMenuItem, "menu_item.run_batch_save");
                batchSaveBeforeMenuItem.setToolTipText(ResourceController
                        .getMessage("menu_item.run_batch_save.tooltip"));

                //options
                setMenuItem(optionMenu, "menu_item.option");

                setMenuItem(optionStylesheetMenuItem, "menu_item.option_save");
                optionStylesheetMenuItem.setToolTipText(ResourceController
                        .getMessage("menu_item.option_save.tooltip"));

                setMenuItem(optionEditorMenuItem, "menu_item.option_editor");
                optionEditorMenuItem.setToolTipText(ResourceController
                        .getMessage("menu_item.option_editor.tooltip"));

                //help
                setMenuItem(helpMenu, "menu_item.help");

                setMenuItem(helpWindowMenuItem, "menu_item.help_window");
                helpWindowMenuItem.setToolTipText(ResourceController
                        .getMessage("menu_item.help_window.tooltip"));

                setMenuItem(configInfoMenuItem, "menu_item.config");
                configInfoMenuItem.setToolTipText(ResourceController
                        .getMessage("menu_item.config.tooltip"));
                setMenuItem(aboutHelpMenuItem, "menu_item.about");
                aboutHelpMenuItem.setToolTipText(ResourceController
                        .getMessage("menu_item.about.tooltip"));
            }
        });
    }

    /**
     * Sets the name of the menu item. Assignes the item title from the resource bundle
     * <code>ResourceController</code> according to the resource key.
     * 
     * @param item
     *            the item of the menu.
     * @param key
     *            the resource key specifying the item title.
     */
    private static void setMenuItem(JMenuItem item, String key) {
        String message = ResourceController.getMessage(key);
        int pos = message.indexOf("&");
        if ((pos >= 0) && ((pos + 1) < message.length())) {
            item.setMnemonic(message.charAt(pos + 1));
            message = message.replaceAll("&", "");
        }
        item.setText(message);
    }
}
