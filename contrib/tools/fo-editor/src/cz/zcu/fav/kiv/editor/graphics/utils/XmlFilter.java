package cz.zcu.fav.kiv.editor.graphics.utils;

import java.io.File;

import javax.swing.filechooser.FileFilter;

/**
 * The <code>XmlFilter</code> class is used for showing only XML files in the directory listing of
 * a <code>JFileChooser</code>.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class XmlFilter extends FileFilter {
    /** The xml extension */
    public final static String xml = "xml";

    @Override
    public boolean accept(File f) {
        if (f.isDirectory())
            return true;

        String extension = getExtension(f);
        if ((extension != null) && (extension.equals(xml)))
            return true;

        return false;
    }

    @Override
    public String getDescription() {
        return "XML files (*.xml)";
    }

    /**
     * Parses the file extension of the input file (part of the file name situated behind '.').
     * 
     * @param file
     *            the name of the file.
     * @return the extension of the file.
     */
    private String getExtension(File file) {
        String ext = null;
        int i = file.getName().lastIndexOf('.');

        if (i > 0 && i < file.getName().length() - 1) {
            ext = file.getName().substring(i + 1).toLowerCase();
        }
        return ext;
    }
}
