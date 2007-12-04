package cz.zcu.fav.kiv.editor.graphics.intro;

import java.awt.Dimension;
import java.awt.EventQueue;

import javax.swing.JComponent;
import javax.swing.JFrame;

import cz.zcu.fav.kiv.editor.controller.logger.Log;
import cz.zcu.fav.kiv.editor.controller.resource.ResourceController;
import cz.zcu.fav.kiv.editor.graphics.images.EditorIcon;
import cz.zcu.fav.kiv.editor.graphics.utils.FrameShower;

/**
 * The <code>IntroFrame</code> class represents the intro frame displaying the loading of configuration files.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class IntroFrame extends JFrame {

    private static final long serialVersionUID = 1293269978761922832L;

    /**
     * Initializes a newly created <code>IntroFrame</code> and launches loading of configuration files.
     * @throws IntroException if an error occurs during loading of configuration files.
     */
    public IntroFrame() throws IntroException {
        super(ResourceController.getMessage("frame.intro.title"));
        this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        setIconImage(EditorIcon.createEditorIcon());

        // Create and set up the content pane.
        JComponent newContentPane = new ProgressBar();
        newContentPane.setOpaque(true); 
        this.setContentPane(newContentPane);

        Dimension dim = getToolkit().getScreenSize();
        Dimension abounds = getPreferredSize();
        this.setLocation((dim.width - abounds.width) / 2, (dim.height - abounds.height) / 2);
        this.setResizable(false);
        
        // Display the window.
        Runnable runner = new FrameShower(this);
        try {
            EventQueue.invokeAndWait(runner);
        } catch (Exception ex) {
            Log.warn(ex);
        }

        ProgressBar.getTimer().start();
        ProgressBar.getTask().go();

        if (ProgressBar.getTask().isCanceled())
            throw new IntroException();
    }

    /**
     * Hides and dispose the intro frame.
     */
    public void hideFrame() {
        this.setVisible(false);
        this.dispose();
    }

}
