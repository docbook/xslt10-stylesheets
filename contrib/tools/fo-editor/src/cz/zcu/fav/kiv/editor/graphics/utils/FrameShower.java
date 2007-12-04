package cz.zcu.fav.kiv.editor.graphics.utils;

import javax.swing.JFrame;

/**
 * The <code>FrameShower</code> class is used for displaying the frame in the thread safe mode.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class FrameShower implements Runnable {
    /** The frame */
    private final JFrame frame;

    /**
     * Initializes a newly created <code>FrameShower</code> with the specified frame.
     * 
     * @param frame
     *            the frame.
     */
    public FrameShower(JFrame frame) {
        this.frame = frame;
    }

    /**
     * Launches the <code>frame</code> in the thread safe mode.
     */
    public void run() {
        frame.pack();
        frame.setVisible(true);
    }
}
