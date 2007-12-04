package cz.zcu.fav.kiv.editor.config;

import java.io.File;
import java.util.Map;

import cz.zcu.fav.kiv.editor.beans.ConfigData;
import cz.zcu.fav.kiv.editor.beans.graphics.Figure;
import cz.zcu.fav.kiv.editor.beans.parameters.Parameter;
import cz.zcu.fav.kiv.editor.beans.properties.AttributeGroup;
import cz.zcu.fav.kiv.editor.beans.types.CommonTypes;
import cz.zcu.fav.kiv.editor.config.constants.FileConst;
import cz.zcu.fav.kiv.editor.controller.MessageWriter;
import cz.zcu.fav.kiv.editor.controller.errors.ConfigException;
import cz.zcu.fav.kiv.editor.controller.errors.FileNotFoundException;
import cz.zcu.fav.kiv.editor.controller.logger.Log;
import cz.zcu.fav.kiv.editor.controller.options.OptionItems;
import cz.zcu.fav.kiv.editor.controller.resource.ResourceController;

/**
 * The <code>ConfigController</code> class contains methods for reading configuration files.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class ConfigController {
    /** The data loaded from configuration files */
    private static ConfigData data;
    
    private static CommonTypes commonTypes;

    /** The parser of configuration files */
    private ConfigParser parser;

    /** The list of attribute groups */
    private AttributeGroup[] attributeGroupList;
    
    /** The list of graphics figures - keys are figure names */
    private Map<String, Figure> figureList;

    /**
     * Initializes a newly created <code>ConfigController</code>. Simultaneously initializes new
     * <code>ConfigParser</code> and <code>ConfigData</code>.
     */
    public ConfigController() {
        data = new ConfigData();
        MessageWriter.writeTitle(ResourceController.getMessage("parser.config_file.title"));
        File directory = new File(OptionItems.XML_DEFINITION_PATH);
        if (!directory.exists())
            MessageWriter.writeError(ResourceController
                    .getMessage("parser.xml_definition_file.invalid_directory"));

        parser = new ConfigParser();
     }

    /**
     * Reads the configuration file with graphics figures - graphics.xml.
     * 
     * @throws FileNotFoundException
     *             if the configuration file or its XML schema doesn't exist.
     * @throws ConfigException
     *             if the configuration file or its XML schema isn't well-formed.
     */
    public void readFigures(Map<String, Parameter> parsedParameterList) throws FileNotFoundException, ConfigException {
        if (!figureList.isEmpty())
            parser.readFigures(parsedParameterList, figureList);
        Log.info("info.progress_control.load_file", FileConst.CONF_FILE_FIGURES);
    }

    /**
     * Reads the configuration file with attributes - attributes.xml.
     * 
     * @throws ConfigException
     *             if the configuration file or its XML schema isn't well-formed.
     * @throws FileNotFoundException
     *             if the configuration file or its XML schema doesn't exist.
     */
    public void readAttributes() throws ConfigException, FileNotFoundException {
        this.attributeGroupList = parser.readAttributes(commonTypes);
        Log.info("info.progress_control.load_file", FileConst.CONF_FILE_ATTRIBUTES);
    }

    /**
     * Reads the configuration file with layout of parameters and attribute-sets - config.xml.
     * 
     * @throws ConfigException
     *             if the configuration file or its XML schema isn't well-formed.
     * @throws FileNotFoundException
     *             if the configuration file or its XML schema doesn't exist.
     */
    public void readConfig() throws ConfigException, FileNotFoundException {
        figureList = parser.readConfig(data, attributeGroupList);
        Log.info("info.progress_control.load_file", FileConst.CONF_FILE_CONFIG);
    }

    /**
     * Reads the configuration file with types - types.xml.
     * 
     * @throws ConfigException
     *             if the configuration file or its XML schema isn't well-formed.
     * @throws FileNotFoundException
     *             if the configuration file or its XML schema doesn't exist.
     */
    public void readTypes() throws ConfigException, FileNotFoundException {
        commonTypes = parser.readTypes();
        Log.info("info.progress_control.load_file", FileConst.CONF_FILE_TYPE);
    }

    public ConfigData getData() {
        return data;
    }

    public CommonTypes getCommonTypes() {
        return commonTypes;
    }

    public Map<String, Figure> getFigureList() {
        return figureList;
    }
}
