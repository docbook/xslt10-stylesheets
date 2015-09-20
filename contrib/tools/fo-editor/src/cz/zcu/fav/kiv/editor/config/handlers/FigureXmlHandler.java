package cz.zcu.fav.kiv.editor.config.handlers;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.xml.sax.Attributes;
import org.xml.sax.Locator;
import org.xml.sax.helpers.DefaultHandler;

import cz.zcu.fav.kiv.editor.beans.graphics.Figure;
import cz.zcu.fav.kiv.editor.beans.parameters.Parameter;
import cz.zcu.fav.kiv.editor.config.constants.FileConst;
import cz.zcu.fav.kiv.editor.config.constants.TagDefinition;
import cz.zcu.fav.kiv.editor.config.constants.TagDefinition.FigureTags;
import cz.zcu.fav.kiv.editor.controller.MessageWriter;
import cz.zcu.fav.kiv.editor.controller.resource.ResourceController;
import cz.zcu.fav.kiv.editor.displays.GraphicsFigure;

/**
 * The <code>FigureXmlHandler</code> class is used for parsing the configuration file with
 * graphics figures - graphics.xml.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class FigureXmlHandler extends DefaultHandler {
    /** The locator specifying actual line number */
    private Locator locator;

    /** The number of the line with figure element */
    private int figureLine;

    /** The list of all figures - key is the figure name */
    private Map<String, Figure> figureList;

    /** The graphics figure */
    private Figure figure;

    private Boolean valid;

    /** The list of parameters that belongs to a graphics figure */
    private List<Parameter> classParameterList;

    /** The list of all parameters - key is the parameter name */
    private Map<String, Parameter> allParameterList;

    /** The flag specifying whether the parser is inside parameter element */
    private boolean insideParameterElement = false;

    /** The string buffer for content of parameter element */
    private StringBuffer parameterBuffer = new StringBuffer(TagDefinition.BUFFER_SIZE);

    /**
     * Initializes a newly created <code>FigureXmlHandler</code> with list of
     * <code>Parameter</code>s.
     * 
     * @param parameterList
     *            the list of all parameters.
     */
    public FigureXmlHandler(Map<String, Parameter> parameterList, Map<String, Figure> figList) {
        figureList = figList;
        this.allParameterList = parameterList;
    }

    @Override
    public void startElement(String namespaceURI, String localName, String qName, Attributes atts) {
        FigureTags enumTag = TagDefinition.FigureTags.getValue(qName);
        switch (enumTag) {
            case FIGURE:                
                figure = figureList.get(atts.getValue(0));
                if (figure != null)
                    figure.setClassName(atts.getValue(1));
                classParameterList = new ArrayList<Parameter>();
                this.figureLine = this.locator.getLineNumber();
                valid = true;
            break;
            case PARAMETER:
                insideParameterElement = true;
                parameterBuffer.setLength(0);
            break;
        }
    }

    @Override
    public void endElement(String namespaceURI, String localName, String qName) {
        FigureTags enumTag = TagDefinition.FigureTags.getValue(qName);
        switch (enumTag) {
        case FIGURE:
            if (figure != null) {
                if (!valid) {
                    // invalid figure
                    figureList.remove(figure.getName());
                    return;
                }
                try {
                    GraphicsFigure graphicsFigure = (GraphicsFigure) Class.forName(
                            figure.getClassName()).newInstance();
                    graphicsFigure.setInputs(classParameterList.toArray(new Parameter[0]));

                    figure.setParameterList(classParameterList.toArray(new Parameter[0]));
                } catch (Exception ex) {
                    MessageWriter.writeWarning(ResourceController.getMessage(
                            "parser.figures.invalid_class", FileConst.CONF_FILE_FIGURES, figure
                                    .getName(), figureLine, figure.getClassName()));
                    figureList.remove(figure.getName());
                }
            }
            break;
        case PARAMETER:
            insideParameterElement = false;
            if (figure != null) {
                if (allParameterList.containsKey(parameterBuffer.toString()))
                    classParameterList.add(allParameterList.get(parameterBuffer.toString()));
                else {
                    MessageWriter.writeWarning(ResourceController.getMessage(
                            "parser.figures.invalid_parameter_value", FileConst.CONF_FILE_FIGURES,
                            figure.getName(), figureLine, parameterBuffer.toString()));
                    valid = false;
                }
            }
            break;
        }
    }

    @Override
    public void characters(char[] ch, int start, int length) {
        if (insideParameterElement) {
            parameterBuffer.append(ch, start, length);
        }
    }

    public void setDocumentLocator(Locator locator) {
        this.locator = locator;
    }

}
