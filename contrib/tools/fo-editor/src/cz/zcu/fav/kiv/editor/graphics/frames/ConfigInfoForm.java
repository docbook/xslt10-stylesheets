package cz.zcu.fav.kiv.editor.graphics.frames;

import java.awt.Dimension;
import java.awt.Font;
import java.io.File;

import javax.swing.BorderFactory;
import javax.swing.ImageIcon;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextField;
import javax.swing.SpringLayout;

import cz.zcu.fav.kiv.editor.config.constants.FileConst;
import cz.zcu.fav.kiv.editor.controller.options.OptionItems;
import cz.zcu.fav.kiv.editor.controller.resource.ResourceController;
import cz.zcu.fav.kiv.editor.graphics.images.EditorIcon;
import cz.zcu.fav.kiv.editor.graphics.utils.SpringUtilities;
import cz.zcu.fav.kiv.editor.template.TemplateConst;

/**
 * The <code>ConfigInfoForm</code> class is the dialog displaying information about configuratio
 * files.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class ConfigInfoForm extends InfoDialog {

    private static final long serialVersionUID = -4631230976081227814L;

    /** The width of the line */
    private static final int LINE_WIDTH = 80;

    /** The number of rows in the dialog */
    private static final int ROW_COUNT = 4;

    /** The number of columns in the dialog */
    private static final int COLUMN_COUNT = 3;

    /** The size of the font */
    private static final int FONT_SIZE = 11;

    /** The size of the margin */
    private static final int MARGIN = 3;

    /** The size of the right margin */
    private static final int MARGIN_RIGHT = 10;

    /** The inner width of the dialog */
    private static final int DIALOG_INNER_WIDTH = 490;

    /** The outer width of the dialog */
    private static final int DIALOG_OUTER_WIDTH = 500;

    /** The single instance of the dialog */
    private static ConfigInfoForm instance;

    /**
     * Initializes a newly created <code>ConfigInfoForm</code> with its title.
     */
    public ConfigInfoForm() {
        super("frame.config_info.title");
    }

    /**
     * Creates and shows the dialog with information about application.
     */
    public static void showDialog() {
        instance = new ConfigInfoForm();
        instance.setVisible(true);
    }

    @Override
    protected JPanel createContent() {
        JPanel content = new JPanel();

        JPanel dirPanel = new JPanel();
        dirPanel.setBorder(BorderFactory.createTitledBorder(ResourceController
                .getMessage("frame.config_info.directory")));
        String labelText = System.getProperty("user.dir") + File.separator
                + OptionItems.XML_DEFINITION_PATH;
        labelText = wrapLabel(labelText);
        JLabel dirLabel = new JLabel("<html>" + labelText + "</html>");
        dirLabel.setFont(new Font("Sans-Serif", Font.BOLD, FONT_SIZE));
        dirPanel.add(dirLabel);
        dirPanel.setPreferredSize(new Dimension(DIALOG_INNER_WIDTH,
                dirPanel.getPreferredSize().height));

        content.add(dirPanel);
        JPanel filePanel = filePanel();
        content.add(filePanel());
        JPanel templatePanel = templatePanel();
        content.add(templatePanel);

        content.setPreferredSize(new Dimension(DIALOG_OUTER_WIDTH,
                dirPanel.getPreferredSize().height + filePanel.getPreferredSize().height
                        + templatePanel.getPreferredSize().height + 20));

        return content;
    }

    /**
     * Creates the panel contenting the information about stylesheet template.
     * 
     * @return the panel contenting the information about stylesheet template.
     */
    private JPanel templatePanel() {
        JPanel templatePanel = new JPanel();
        templatePanel.setBorder(BorderFactory.createTitledBorder(ResourceController
                .getMessage("frame.config_info.template.title")));

        String labelText = System.getProperty("user.dir") + File.separator
                + TemplateConst.CONF_FILE_TEMPLATE;
        labelText = wrapLabel(labelText);
        JLabel dirLabel = new JLabel("<html>" + labelText + "</html>");
        dirLabel.setFont(new Font("Sans-Serif", Font.BOLD, FONT_SIZE));
        templatePanel.add(dirLabel);

        templatePanel.setPreferredSize(new Dimension(DIALOG_INNER_WIDTH, templatePanel
                .getPreferredSize().height));
        return templatePanel;
    }

    /**
     * Creates the panel contenting the information about configuration files.
     * 
     * @return the panel contenting the information about configuration files.
     */
    private JPanel filePanel() {
        ImageIcon img = EditorIcon.createHelpIcon();

        JPanel configPanel = new JPanel();
        configPanel.setBorder(BorderFactory.createTitledBorder(ResourceController
                .getMessage("frame.config_info.files.title")));
        configPanel.setLayout(new SpringLayout());

        // config.xml
        JLabel iconLabel = new JLabel();
        iconLabel.setIcon(img);
        iconLabel.setToolTipText(ResourceController
                .getMessage("frame.config_info.files.config.description"));
        configPanel.add(iconLabel);
        configPanel.add(new JLabel(FileConst.CONF_FILE_CONFIG.substring(FileConst.CONF_FILE_CONFIG
                .indexOf(File.separator) + 1)));
        JTextField valueField = new JTextField(System.getProperty("user.dir") + File.separator
                + FileConst.CONF_FILE_CONFIG);
        valueField.setEditable(false);
        configPanel.add(valueField);

        // attributes.xml
        iconLabel = new JLabel();
        iconLabel.setIcon(img);
        iconLabel.setToolTipText(ResourceController
                .getMessage("frame.config_info.files.attributes.description"));
        configPanel.add(iconLabel);
        configPanel.add(new JLabel(FileConst.CONF_FILE_ATTRIBUTES
                .substring(FileConst.CONF_FILE_ATTRIBUTES.indexOf(File.separator) + 1)));
        valueField = new JTextField(System.getProperty("user.dir") + File.separator
                + FileConst.CONF_FILE_ATTRIBUTES);
        valueField.setEditable(false);
        configPanel.add(valueField);

        // types.xml
        iconLabel = new JLabel();
        iconLabel.setIcon(img);
        iconLabel.setToolTipText(ResourceController
                .getMessage("frame.config_info.files.types.description"));
        configPanel.add(iconLabel);
        configPanel.add(new JLabel(FileConst.CONF_FILE_TYPE.substring(FileConst.CONF_FILE_TYPE
                .indexOf(File.separator) + 1)));
        valueField = new JTextField(System.getProperty("user.dir") + File.separator
                + FileConst.CONF_FILE_TYPE);
        valueField.setEditable(false);
        configPanel.add(valueField);

        // graphics
        iconLabel = new JLabel();
        iconLabel.setIcon(img);
        iconLabel.setToolTipText(ResourceController
                .getMessage("frame.config_info.files.graphics.description"));
        configPanel.add(iconLabel);
        configPanel.add(new JLabel(FileConst.CONF_FILE_FIGURES
                .substring(FileConst.CONF_FILE_FIGURES.indexOf(File.separator) + 1)));
        valueField = new JTextField(System.getProperty("user.dir") + File.separator
                + FileConst.CONF_FILE_FIGURES);
        valueField.setEditable(false);
        configPanel.add(valueField);

        SpringUtilities.makeCompactGrid(configPanel, ROW_COUNT, COLUMN_COUNT, MARGIN, MARGIN,
                MARGIN_RIGHT, MARGIN);
        configPanel.setPreferredSize(new Dimension(DIALOG_INNER_WIDTH, configPanel
                .getPreferredSize().height));
        return configPanel;
    }

    /**
     * Wraps string line - adds <br>
     * if the line is longer than <code>LINE_WIDTH</code>.
     * 
     * @param text
     *            not wrapped text.
     * @return the wrapped text.
     */
    private String wrapLabel(String text) {
        if (text.length() > LINE_WIDTH)
            text = text.substring(0, LINE_WIDTH) + "<br>"
                    + text.substring(LINE_WIDTH, text.length());
        return text;
    }
}
