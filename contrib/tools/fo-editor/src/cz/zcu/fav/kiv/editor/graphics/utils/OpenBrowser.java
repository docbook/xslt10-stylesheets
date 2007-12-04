package cz.zcu.fav.kiv.editor.graphics.utils;

import java.lang.reflect.Method;

import javax.swing.JOptionPane;

import cz.zcu.fav.kiv.editor.controller.logger.Log;
import cz.zcu.fav.kiv.editor.controller.resource.ResourceController;

/**
 * The <code>OpenBrowser</code> class is used for launching the main web browser of the operating
 * system.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class OpenBrowser {

    /**
     * Launches the main web browser of any operating system (Mac, Windows or Unix).
     * 
     * @param url
     *            the url of the page that will be opened in the web browser.
     */
    public static void openURL(String url) {
        String osName = System.getProperty("os.name");
        try {
            if (osName.startsWith("Mac OS")) {
                Class fileMgr = Class.forName("com.apple.eio.FileManager");
                Method openURL = fileMgr.getDeclaredMethod("openURL", new Class[] { String.class });
                openURL.invoke(null, new Object[] { url });
            } else if (osName.startsWith("Windows")) {
                Runtime.getRuntime().exec("rundll32 url.dll,FileProtocolHandler " + url);
            } else { // assume Unix or Linux
                String[] browsers = { "firefox", "opera", "konqueror", "epiphany", "mozilla",
                        "netscape" };
                String browser = null;
                for (int count = 0; count < browsers.length && browser == null; count++)
                    if (Runtime.getRuntime().exec(new String[] { "which", browsers[count] })
                            .waitFor() == 0)
                        browser = browsers[count];
                if (browser == null)
                    throw new Exception("Could not find web browser");
                else
                    Runtime.getRuntime().exec(new String[] { browser, url });
            }
        } catch (Exception ex) {
            Log.error(ex);
            JOptionPane.showMessageDialog(null, ResourceController.getMessage("error.open_browser")
                    + ":\n" + ex.getLocalizedMessage(), ResourceController
                    .getMessage("error.open_browser.title"), JOptionPane.WARNING_MESSAGE);
        }
    }

}
