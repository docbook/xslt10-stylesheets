package cz.zcu.fav.kiv.editor.controller.errors;

import org.xml.sax.ErrorHandler;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;

import cz.zcu.fav.kiv.editor.controller.resource.ResourceController;

/**
 * The <code>XslParserException</code> class is used for reporting errors rised during parsing
 * input XML and XSL files.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class XslParserException implements ErrorHandler {
    /**
     * Creates text containing a message with the error.
     * 
     * @param exception
     *            the rised error.
     * @return a message with the error.
     */
    private String errorText(SAXParseException exception) {
        return ResourceController.getMessage("error.xslt_parser", exception.getLineNumber(), exception.getColumnNumber(), exception.getMessage());
    }

    /**
     * Handles the warning messages rised during file parsing.
     * 
     * @param exception
     *            the rised warning.
     * @throws SAXException
     *             with the content of the rised warning.
     */
    public void warning(SAXParseException exception) throws SAXException {
        throw new SAXException(ResourceController.getMessage("error.xslt_parser.warning") + errorText(exception));
    }

    /**
     * Handles the error messages rised during file parsing.
     * 
     * @param exception
     *            the rised error.
     * @throws SAXException
     *             with the content of the rised error.
     */
    public void error(SAXParseException exception) throws SAXException {
        throw new SAXException(errorText(exception));
    }

    /**
     * Handles the fatal error messages rised during file parsing.
     * 
     * @param exception
     *            the rised fatal error.
     * @throws SAXException
     *             with the content of the rised fatal error.
     */
    public void fatalError(SAXParseException exception) throws SAXException {
        throw new SAXException(ResourceController.getMessage("error.xslt_parser.fatal") + errorText(exception));
    }
}
