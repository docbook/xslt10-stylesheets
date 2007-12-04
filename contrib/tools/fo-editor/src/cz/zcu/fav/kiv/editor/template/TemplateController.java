package cz.zcu.fav.kiv.editor.template;

import cz.zcu.fav.kiv.editor.beans.ConfigData;
import cz.zcu.fav.kiv.editor.controller.MessageWriter;
import cz.zcu.fav.kiv.editor.controller.errors.ConfigException;
import cz.zcu.fav.kiv.editor.controller.errors.FileNotFoundException;
import cz.zcu.fav.kiv.editor.controller.logger.Log;
import cz.zcu.fav.kiv.editor.controller.resource.ResourceController;

/**
 * The <code>TemplateController</code> class contains method for reading templates.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class TemplateController {

    /** The instance of <code>TemplateController</code> */
    private static TemplateController instance;

    /**
     * Static methods return instance of <code>TemplateController</code>. If the
     * <code>instance</code> is null, initializes a new one.
     * 
     * @return the instance of <code>TemplateController</code>.
     */
    public static TemplateController getInstance() {
        if (instance != null)
            return instance;
        return new TemplateController();
    }

    /** The parser of XML templates */
    private TemplateParser parser;

    /**
     * Initializes a newly created <code>TemplateController</code>. Simultaneously initializes
     * new <code>TemplateParser</code>.
     */
    private TemplateController() {
        parser = new TemplateParser();
    }

    /**
     * Reads a template defined by its path <code>templateFile</code>.
     * 
     * @param configData
     *            the data containing editor data structure.
     * @param templateFile
     *            the path to the file with template.
     * @throws ConfigException
     *             if the template or its XML schema isn't well-formed.
     * @throws FileNotFoundException
     *             if the template or its XML schema doesn't exist.
     */
    public void readTemplate(ConfigData configData, String templateFile) throws ConfigException,
            FileNotFoundException {
        MessageWriter.writeInfo(ResourceController.getMessage(
                "new_file_template.load_template.title", TemplateConst.CONF_FILE_TEMPLATE));
        parser.readTemplate(configData, templateFile);
        Log.info("info.template_control.load_template", TemplateConst.CONF_FILE_TEMPLATE);
    }
}
