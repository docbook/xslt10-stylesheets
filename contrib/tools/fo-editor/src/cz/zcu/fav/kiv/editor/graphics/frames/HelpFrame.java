package cz.zcu.fav.kiv.editor.graphics.frames;

import java.net.URL;

import javax.help.HelpBroker;
import javax.help.HelpSet;

import cz.zcu.fav.kiv.editor.controller.logger.Log;
import cz.zcu.fav.kiv.editor.controller.options.OptionItems;

/**
 * The <code>HelpFrame</code> class is the frame displaying application help.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class HelpFrame {
    private static final String HELPSET = "jhelpset.hs";

    /** The help set */
    private HelpSet helpSet;

    /** The help broker */
    private HelpBroker helpBroker;

    /** The single instance of the frame */
    private static HelpFrame instance;

    /**
     * Returns the single instance of the help frame.
     * 
     * @return single instance of the help frame.
     */
    public static HelpFrame getInstance() {
        if (instance == null)
            instance = new HelpFrame();
        return instance;
    }

    /**
     * Initializes a newly created <code>HelpFrame</code>.
     */
    public HelpFrame() {
    }

    /**
     * Creates the new help content according to the actual application language locale.
     */
    public void createHelp() {
        if ((helpSet != null) && (!helpSet.getLocale().equals(OptionItems.LANGUAGE)))
            helpSet = null;
        if (helpSet == null) {
            createHelpSet();
            helpBroker = helpSet.createHelpBroker();
        }
        helpBroker.setDisplayed(true);
    }

    /**
     * Initializes the help set according to the file jhelpset.hs.
     */
    private void createHelpSet() {
        ClassLoader loader = this.getClass().getClassLoader();
        try {
            URL url = HelpSet.findHelpSet(loader, HELPSET);
            helpSet = new HelpSet(null, url);
        } catch (Exception ex) {
            Log.error(ex);
        }
    }

}
