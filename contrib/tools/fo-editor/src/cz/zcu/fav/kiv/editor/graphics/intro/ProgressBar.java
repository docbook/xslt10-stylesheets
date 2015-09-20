package cz.zcu.fav.kiv.editor.graphics.intro;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.BorderFactory;
import javax.swing.JPanel;
import javax.swing.JProgressBar;
import javax.swing.JScrollPane;
import javax.swing.JTextPane;
import javax.swing.Timer;
import javax.swing.text.MutableAttributeSet;
import javax.swing.text.SimpleAttributeSet;
import javax.swing.text.StyleConstants;
import javax.swing.text.StyledDocument;

import cz.zcu.fav.kiv.editor.beans.ConfigData;
import cz.zcu.fav.kiv.editor.controller.ProgressControl;
import cz.zcu.fav.kiv.editor.controller.logger.Log;
import cz.zcu.fav.kiv.editor.controller.resource.ResourceController;

/**
 * The <code>ProgressBar</code> class is the progress bar used for displaying the progress of
 * configuration files loading.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class ProgressBar extends JPanel {

    private static final long serialVersionUID = 1982246205327449245L;

    /** The width of the progress bar */
    private static final int WIDTH = 400;

    /** The height of the progress bar */
    private static final int HEIGHT = 150;

    /** The size of margin of the progress bar */
    private static final int MARGIN = 10;

    /** The interval of timer launching */
    private final static int TIME_INTERVAL = 50;

    /** The progress bar */
    private static JProgressBar progressBar;

    /** The timer controlling the displaying of progress */
    private static Timer timer;

    /** The text pane displaying information about progress */
    private JTextPane editor;

    /** The mutable attribute set of the <code>JTextPane</code> */
    private MutableAttributeSet mutAttr;

    /** The styled document of the <code>JTextPane</code> */
    private StyledDocument styledDoc;

    /** The class controlling the loading the configuration files */
    private static ProgressControl task;

    /**
     * Initializes a newly created <code>ProgressBar</code>. Starts the task that loads the
     * configuration files and simultaneously starts the timer.
     */
    public ProgressBar() {
        super(new BorderLayout(MARGIN, MARGIN));

        task = new ProgressControl();
        progressBar = new JProgressBar();
        progressBar.setValue(0);
        progressBar.setStringPainted(true);
        
        JProgressBar progressBarIndetermin = new JProgressBar();
        progressBarIndetermin.setIndeterminate(true);
        progressBarIndetermin.setStringPainted(true);
        progressBarIndetermin.setString(ResourceController.getMessage("frame.intro.progress.loading_file"));
      
        editor = new JTextPane();
        mutAttr = new SimpleAttributeSet();
        styledDoc = editor.getStyledDocument();
        StyleConstants.setForeground(mutAttr, Color.black);

        add(progressBar, BorderLayout.PAGE_START);
        add(progressBarIndetermin, BorderLayout.PAGE_END);
        
        JScrollPane scrollBar = new JScrollPane(editor);
        scrollBar.setPreferredSize(new Dimension(WIDTH, HEIGHT));
        add(scrollBar, BorderLayout.CENTER);
        this.setBorder(BorderFactory.createEmptyBorder(MARGIN, MARGIN, MARGIN, MARGIN));

        // Create a timer.
        timer = new Timer(TIME_INTERVAL, new ActionListener() {
            public void actionPerformed(ActionEvent evt) {
                progressBar.setValue(task.getCurrent());
                try {
                    if ((task.getMessage() != null) && (!task.isCanceled())) {
                        if (styledDoc.getLength() < task.getMessage().length()) {
                            styledDoc.remove(0, styledDoc.getLength());
                            styledDoc.insertString(0, task.getMessage(), mutAttr);
                        }
                    }
                    if (task.isDone()) {
                        timer.stop();
                        progressBar.setValue(progressBar.getMaximum());
                        styledDoc.insertString(0, task.getMessage(), mutAttr);
                    }
                    if (task.isCanceled()) {
                        timer.stop();
                        styledDoc.remove(0, styledDoc.getLength());
                        styledDoc.insertString(0, task.getMessage(), mutAttr);
                        StyleConstants.setForeground(mutAttr, Color.red);
                        styledDoc.insertString(styledDoc.getLength(), task.getErrorMessage(),
                                mutAttr);
                        progressBar.setIndeterminate(false);
                    }
                } catch (Exception ex) {
                    Log.error(ex);
                }
            }
        });
    }

    public static ConfigData getData() {
        return task.getData();
    }

    public static Timer getTimer() {
        return timer;
    }

    public static ProgressControl getTask() {
        return task;
    }
}
