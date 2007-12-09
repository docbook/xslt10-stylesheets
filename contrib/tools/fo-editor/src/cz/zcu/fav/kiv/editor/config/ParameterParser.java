package cz.zcu.fav.kiv.editor.config;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;

import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import org.xml.sax.SAXException;
import org.xml.sax.XMLReader;

import cz.zcu.fav.kiv.editor.beans.parameters.Parameter;
import cz.zcu.fav.kiv.editor.beans.types.CommonTypes;
import cz.zcu.fav.kiv.editor.config.constants.FileConst;
import cz.zcu.fav.kiv.editor.config.handlers.ParameterXmlHandler;
import cz.zcu.fav.kiv.editor.controller.MessageWriter;
import cz.zcu.fav.kiv.editor.controller.ProgressControl;
import cz.zcu.fav.kiv.editor.controller.errors.XslParserException;
import cz.zcu.fav.kiv.editor.controller.logger.Log;
import cz.zcu.fav.kiv.editor.controller.options.OptionItems;
import cz.zcu.fav.kiv.editor.controller.resource.ResourceController;

/**
 * The <code>ParameterParser</code> class contains methods for parsing files with XML definitions
 * of parameters.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class ParameterParser {
        
    /** The max number of dependency nesting - to avoid cycle dependency **/
    private static final int LIMIT_LOOP = 5;
    
    /** The XML parser used for reading XML files */
    private XMLReader parser;
    
    /** The list of parsed parameters */
    private Map<String, Parameter> parsedParameterList;
    
    /** The list of unparsed parameters */
    private Map<String, Parameter> unparsedParameterList;
    
    /** The list of invalid parameters */
    private List<String> invalidParameterList;
    
    /** The list of common types */
    private static CommonTypes commonTypes;
    
    /** The parser used for parsing parameter value dependencies */
    private ParameterDependencyParser paramDependencyParser;

    /**
     * Initializes a newly created <code>ParameterParser</code>. Sets up the SAX parser used for
     * parsing.
     */
    public ParameterParser(CommonTypes types) {
        try {
            SAXParserFactory spf = SAXParserFactory.newInstance();
            spf.setValidating(false);

            SAXParser saxParser = spf.newSAXParser();
            parser = saxParser.getXMLReader();
            parser.setErrorHandler(new XslParserException());
            
            commonTypes = types;
            
            unparsedParameterList = new HashMap<String, Parameter>();
            parsedParameterList = new HashMap<String, Parameter>();
            invalidParameterList = new ArrayList<String>();
        } catch (Exception ex) {
            Log.error(ex);
        }
    }

    /**
     * In sequence parses for every parameter its XML definition file.
     * 
     * @param parameterList
     *            the list of parameter names loaded from the main configuration file.
     */
    public void readParameterDefinition(Map<String, Parameter> parameterList) {
        Iterator<Map.Entry<String, Parameter>> iter = parameterList.entrySet().iterator();
        while (iter.hasNext()) {
            Map.Entry<String, Parameter> param = iter.next();
            parseParameter(param.getValue());
        }   
    }

    /**
     * For input parameter parses its XML definition file.
     * 
     * @param element
     *            the parameter which XML file is parsed.
     */
    private void parseParameter(Parameter element) {
        try {
            ParameterXmlHandler handler = new ParameterXmlHandler(element, commonTypes);
            parser.setContentHandler(handler);
            parser.parse(OptionItems.XML_DEFINITION_PATH + File.separator + element.getName()
                    + ".xml");
            if (!handler.isValid()) {
                invalidParameterList.add(element.getName());
            } else {
                if (handler.isParsed())
                    parsedParameterList.put(element.getName(), element);
                else
                    unparsedParameterList.put(element.getName(), element);
            }
            ProgressControl.addStatMessage(ResourceController.getMessage("frame.intro.progress.read_file", OptionItems.XML_DEFINITION_PATH + File.separator + element.getName()+".xml"));                   
        } catch (IOException ex) {
            MessageWriter.writeWarning(ResourceController.getMessage(
                    "parser.xml_definition_file.missing_file", element.getName(),
                    OptionItems.XML_DEFINITION_PATH));
            invalidParameterList.add(element.getName());
        } catch (SAXException ex) {
            Log.warn("error.param_parser.parser_error", ex);
            invalidParameterList.add(element.getName());
        }
    }

    /**
     * Process values of parameters from <code>unparsedParameterList</code>.
     */
    public void processParameterDependency() {
        paramDependencyParser = new ParameterDependencyParser(this);
        Map<String, Parameter> innerUnparsedParameterList = null;
        StringBuilder message = new StringBuilder();
        int limitLoop = 0;
        while(!unparsedParameterList.isEmpty()) {
            innerUnparsedParameterList = unparsedParameterList;
            unparsedParameterList = new HashMap<String, Parameter>();
            Iterator it = innerUnparsedParameterList.entrySet().iterator();
            while (it.hasNext()) {
                Map.Entry param = (Map.Entry)it.next();
                if (limitLoop == LIMIT_LOOP) {
                    message.append(param.getKey() + ",");
                } else {
                    //parse
                    parseParameterValue((Parameter)param.getValue(), innerUnparsedParameterList);
                }
            }
            //to avoid cycle dependency
            if (limitLoop == LIMIT_LOOP) {                
                MessageWriter.writeWarning(ResourceController.getMessage(
                        "parser.parameters.dependency_cycle", FileConst.CONF_FILE_CONFIG, message));
                break;                
            }
            limitLoop++;
        }
    }     

    public Map<String, Parameter> getParsedParameterList() {
        return parsedParameterList;
    }
    
    /**
     * Parses parameter value that contains references to others parameters.
     * @param param the parsed parameter.
     * @param innerUnparsedParameterList the list of unparsed parameters.
     */
    private void parseParameterValue(Parameter param, Map<String, Parameter> innerUnparsedParameterList) {
        Matcher matcher = ParamController.patternParam.matcher(param.getType().getValue());
        boolean canBeParsed = true;
        while(matcher.find()) {
            String paramName = matcher.group().substring(1);           
            if (invalidParameterList.contains(paramName)) {
                //parameter is invalid -> the depending parameter is invalid
                invalidParameterList.add(param.getName());  
                MessageWriter.writeWarning(ResourceController.getMessage(
                        "parser.parameters.invalid_value", FileConst.CONF_FILE_CONFIG, param
                                .getName(), param.getLineNumber()));
                return;
            }
            if (!parsedParameterList.containsKey(paramName)) {
                //param is not yet parsed
                if (!innerUnparsedParameterList.containsKey(paramName))
                    parseParameter(new Parameter(paramName));
                canBeParsed = false;
            }
        }
        if (!canBeParsed) {
            unparsedParameterList.put(param.getName(), param);
        } else {
            //parse parameter value
            if (paramDependencyParser.parseParameterDependency(param))
                parsedParameterList.put(param.getName(), param);
            else
                invalidParameterList.add(param.getName()); 
        }
    }
}
