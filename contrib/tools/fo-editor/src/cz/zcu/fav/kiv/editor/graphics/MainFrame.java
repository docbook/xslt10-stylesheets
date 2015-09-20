package cz.zcu.fav.kiv.editor.graphics;

import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.EventQueue;
import java.awt.Image;

import javax.swing.JComponent;
import javax.swing.JFrame;
import javax.swing.ToolTipManager;

import cz.zcu.fav.kiv.editor.beans.ConfigData;
import cz.zcu.fav.kiv.editor.beans.OpenFile;
import cz.zcu.fav.kiv.editor.controller.MenuController;
import cz.zcu.fav.kiv.editor.controller.resource.ResourceController;
import cz.zcu.fav.kiv.editor.graphics.components.editor.EditorBody;
import cz.zcu.fav.kiv.editor.graphics.images.EditorIcon;
import cz.zcu.fav.kiv.editor.graphics.utils.FrameShower;

/**
 * The <code>MainFrame</code> class represents the main frame of the application.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public final class MainFrame extends JFrame {

    private static final long serialVersionUID = 2955560489556252043L;

    /** The instance of the <code>MainFrame</code> class */
    private static MainFrame instance;

    /** The main menu of the application */
    private static TopMenu menuBar;

    /** The data containing editor data structure */
    private ConfigData configData;

    /** The structure containing information about actually opened file */
    private OpenFile openFile;

    /**
     * Initializes a newly created <code>MainFrame</code>.
     */
    private MainFrame() {
    }

    /**
     * Initializes a newly created <code>MainFrame</code> with specified data.
     * 
     * @param data
     *            the data containing editor data structure.
     */
    private MainFrame(ConfigData data) {
        this.configData = data;
        this.openFile = new OpenFile();
    }

    /**
     * Singleton constructor - gets the single instance of the <code>MainFrame</code> class.
     * 
     * @return the single instance of <code>MainFrame</code>.
     */
    public static MainFrame getInstance() {
        if (instance == null) {
            instance = new MainFrame();
            return instance;
        }
        return instance;

    }

    /**
     * Creates the main application frame <code>MainFrame</code> with specified data.
     * 
     * @param data
     *            the data containing editor data structure.
     * @return newly created main application frame.
     */
    public static MainFrame createFrame(ConfigData data) {
        instance = new MainFrame(data);
        return instance;
    }

    /**
     * This method is called from within the constructor to initialize the form.
     */
    private void initComponents() {

        setTitle(ResourceController.getMessage("editor.title"));

        addWindowListener(new java.awt.event.WindowAdapter() {
            public void windowClosing(java.awt.event.WindowEvent evt) {
                exitForm(evt);
            }

            public void windowOpened(java.awt.event.WindowEvent evt) {
                formWindowOpened(evt);
            }
        });

        menuBar = new TopMenu(this);
        setJMenuBar(menuBar);

        JComponent newContentPane = new EditorBody(configData.getSectionList());
        newContentPane.setOpaque(true);
        this.getContentPane().add(newContentPane, BorderLayout.CENTER);

        ToolTipManager.sharedInstance().setInitialDelay(0);

        Dimension dim = getToolkit().getScreenSize();
        Dimension abounds = getPreferredSize();
        setLocation((dim.width - abounds.width) / 2, (dim.height - abounds.height) / 2);

        // Threadsafe startup of main frame
        Runnable runner = new FrameShower(this);
        EventQueue.invokeLater(runner);
    }

    /**
     * Reaction on frame window opening.
     * 
     * @param evt
     *            the opened window.
     */
    private void formWindowOpened(java.awt.event.WindowEvent evt) {
        Image frameImage = EditorIcon.createEditorIcon();
        if (frameImage != null) {
            setIconImage(frameImage);
        }
    }

    /**
     * Reaction on frame window closing.
     * 
     * @param evt
     *            the actually closing window.
     */
    private void exitForm(java.awt.event.WindowEvent evt) {
        MenuController.exitItem();
        shutDown();
    }

    /**
     * Shuts down the main application frame - terminates the whole application.
     * 
     */
    public void shutDown() {
        System.exit(0);
    }

    /**
     * Initializes the form and launched it.
     * 
     * @throws Exception
     *             if an error during initialization occurs.
     */
    public void go() throws Exception {
        initComponents();
    }

    public ConfigData getConfigData() {
        return configData;
    }

    public OpenFile getOpenFile() {
        return openFile;
    }

    /**
     * Changes the title of the main frame. Sets the name of the actually opened file to the title.
     * If the actually opened file has been modified then the title is changed.
     * 
     */
    public void changeTitle() {
        String title = ResourceController.getMessage("editor.title") + " - ";
        if (openFile.isFileChanged())
            title += "*";
        if (openFile.getOpenFilePath() != null)
            title += openFile.getOpenFilePath();
        setTitle(title);
    }

    /**
     * Specifies that the actually opened file <code>OpenFile</code> has been modified.
     */
    public void setFileChanged() {
        if (!openFile.isFileChanged())
            this.getOpenFile().setFileChanged(true);
    }

}
