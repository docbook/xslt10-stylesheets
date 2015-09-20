package cz.zcu.fav.kiv.editor.beans;

import org.w3c.dom.Document;

import cz.zcu.fav.kiv.editor.graphics.MainFrame;
import cz.zcu.fav.kiv.editor.stylesheet.XslParser;

/**
 * The <code>OpenFile</code> class represents an open XSL stylesheet file.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class OpenFile {
    /** The supported file extension */
    private static final String extension = ".xsl";

    /** The DOM structure of open stylesheet file */
    private Document wholeFile;

    /** The path to the open file */
    private String openFilePath;

    /** The flag indicating changes in the open file */
    private boolean fileChanged;

    /**
     * Initializes a newly created empty <code>OpenFile</code>. Assignes the
     * <code>wholeFile</code> to the new empty DOM XSL stylesheet structure. Sets the newly
     * created file as not changed (<code>fileChanged</code>).
     */
    public OpenFile() {
        this.wholeFile = XslParser.createXsltFile();
        this.fileChanged = false;
    }

    public Document getWholeFile() {
        return wholeFile;
    }

    /**
     * Sets the new DOM structure <code>wholeFile</code> of newly opened file. Sets the opened
     * file as not changed.
     * 
     * @param wholeFile
     *            DOM structure of the opened file.
     */
    public void setWholeFile(Document wholeFile) {
        this.wholeFile = wholeFile;
        setFileChanged(false);
    }

    public String getOpenFilePath() {
        return openFilePath;
    }

    /**
     * Sets the new <code>openFilePath</code> of the opened file. If the file hasn't the extension
     * XSL, then the extension is added.
     * 
     * @param openFilePath
     *            a new path to the opened file.
     */
    public void setOpenFilePath(String openFilePath) {
        if (openFilePath != null) {
            if (!openFilePath.trim().endsWith(extension))
                openFilePath = openFilePath + extension;
        }
        this.openFilePath = openFilePath;
    }

    public boolean isFileChanged() {
        return fileChanged;
    }

    /**
     * Sets if the opened file is changed or not. According to changes sets the status information
     * about the file.
     * 
     * @param fileChanged
     *            true, if the file has changed.
     */
    public void setFileChanged(boolean fileChanged) {
        this.fileChanged = fileChanged;
        MainFrame.getInstance().changeTitle();
    }
}
