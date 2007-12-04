package cz.zcu.fav.kiv.editor.graphics.options;

import java.awt.Dimension;
import java.awt.Font;

import javax.swing.BorderFactory;
import javax.swing.Box;
import javax.swing.BoxLayout;
import javax.swing.ImageIcon;
import javax.swing.JCheckBox;
import javax.swing.JComboBox;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;
import javax.swing.JTextField;
import javax.swing.SpringLayout;

import cz.zcu.fav.kiv.editor.controller.logger.Log;
import cz.zcu.fav.kiv.editor.controller.options.EncodingEnum;
import cz.zcu.fav.kiv.editor.controller.options.NewlineEnum;
import cz.zcu.fav.kiv.editor.controller.options.OptionItems;
import cz.zcu.fav.kiv.editor.controller.resource.ErrorResourceController;
import cz.zcu.fav.kiv.editor.controller.resource.ResourceController;
import cz.zcu.fav.kiv.editor.graphics.images.EditorIcon;
import cz.zcu.fav.kiv.editor.graphics.utils.SpringUtilities;

/**
 * The <code>StylesheetOptionForm</code>class is the form with editor options. It makes the
 * content of the <code>OptionStylesheetDialog</code> dialog.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class StylesheetOptionForm extends JPanel {

    private static final long serialVersionUID = -1040245299541084094L;

    /** The number of columns in the form */
    private static final int COLUMN_COUNT = 3;

    /** The number of rows in the first panel of the form */
    private static final int ROW_1_COUNT = 3;

    /** The number of rows in the second panel of the form */
    private static final int ROW_2_COUNT = 3;

    /** The number of rows in the third panel of the form */
    private static final int ROW_3_COUNT = 2;

    /** The inner width of the form panel */
    private static final int PANEL_INNER_WIDTH = 490;

    /** The outer width of the form panel */
    private static final int PANEL_OUTER_WIDTH = 500;

    /** The size of component margin */
    private static final int COMPONENT_MARGIN = 3;

    /** The label containing option name */
    private JLabel iconLabel;

    /** The icon image representing option item help */
    private ImageIcon image;

    /** The check-box specifying whether FO namespace is appended to the stylesheet definiton */
    private JCheckBox addFoNamespaceCheck;

    /** The check-box specifying whether the rearrange saving is used */
    private JCheckBox changeSaveCheck;

    /** The check-box specifying whether comments are generated in the stylesheet */
    private JCheckBox generateCommentsCheck;

    /** The check-box specifying whether attribute <em>select</em> is used in parameter elements */
    private JCheckBox useParamSelectCheck;

    /** The combo-box specifying encoding of output files */
    private JComboBox encodingBox;

    /** The combo-box specifying char of ends of lines in output files */
    private JComboBox newlineBox;

    /** The text-field specifying stylesheet version */
    private JTextField stylesheetVersionField;

    /** The text-area specifying imported stylesheet files */
    private JTextArea importFileArea;

    /**
     * Initializes a newly created <code>StylesheetOptionForm</code>.
     */
    public StylesheetOptionForm() {
        image = EditorIcon.createHelpIcon();

        JPanel panelOne = createPanelOne();
        this.add(panelOne);

        JPanel panelTwo = createPanelTwo();
        this.add(panelTwo);

        JPanel panelThree = createPanelThree();
        this.add(panelThree);
        this.setPreferredSize(new Dimension(PANEL_OUTER_WIDTH, panelOne.getPreferredSize().height
                + panelTwo.getPreferredSize().height + panelThree.getPreferredSize().height + 20));
    }

    /**
     * Creates the first form panel with options of new stylesheets.
     * 
     * @return the panel with options of new stylesheets.
     */
    private JPanel createPanelOne() {
        JPanel panel = new JPanel();
        panel.setLayout(new SpringLayout());
        panel.setBorder(BorderFactory.createTitledBorder(ResourceController
                .getMessage("option_save.new_file_template.title")));
        optionImportedFiles(panel);
        optionStylesheetVersion(panel);
        optionAddFoNamespace(panel);
        SpringUtilities.makeCompactGrid(panel, ROW_1_COUNT, COLUMN_COUNT, COMPONENT_MARGIN,
                COMPONENT_MARGIN, COMPONENT_MARGIN, COMPONENT_MARGIN);
        panel.setPreferredSize(new Dimension(PANEL_INNER_WIDTH, panel.getPreferredSize().height));
        return panel;
    }

    /**
     * Creates the second form panel with options of all stylesheets.
     * 
     * @return the panel with options of stylesheets.
     */
    private JPanel createPanelTwo() {
        JPanel panel = new JPanel();
        panel.setLayout(new SpringLayout());
        panel.setBorder(BorderFactory.createTitledBorder(ResourceController
                .getMessage("option_save.stylesheet_format.title")));
        optionChangeSave(panel);
        optionGenerateComments(panel);
        optionUseParamSelect(panel);
        SpringUtilities.makeCompactGrid(panel, ROW_2_COUNT, COLUMN_COUNT, COMPONENT_MARGIN,
                COMPONENT_MARGIN, COMPONENT_MARGIN, COMPONENT_MARGIN);
        panel.setPreferredSize(new Dimension(PANEL_INNER_WIDTH, panel.getPreferredSize().height));
        return panel;
    }

    /**
     * Creates the third form panel with options of output files.
     * 
     * @return the panel with options of output files.
     */
    private JPanel createPanelThree() {
        JPanel panel = new JPanel();
        panel.setLayout(new SpringLayout());
        panel.setBorder(BorderFactory.createTitledBorder(ResourceController
                .getMessage("option_save.output_file.title")));
        optionEncoding(panel);
        optionNewline(panel);
        SpringUtilities.makeCompactGrid(panel, ROW_3_COUNT, COLUMN_COUNT, COMPONENT_MARGIN,
                COMPONENT_MARGIN, COMPONENT_MARGIN, COMPONENT_MARGIN);
        panel.setPreferredSize(new Dimension(PANEL_INNER_WIDTH, panel.getPreferredSize().height));
        return panel;
    }

    /**
     * Adds to the panel the option item specifying whether FO namespace is appended to the
     * stylesheet definiton.
     * 
     * @param panel
     *            the parent panel.
     */
    private void optionAddFoNamespace(JPanel panel) {
        // interrogation mark
        iconLabel = new JLabel();
        iconLabel.setToolTipText(ResourceController
                .getMessage("option_save.add_fo_namespace.description"));
        iconLabel.setIcon(image);
        panel.add(iconLabel);
        // name
        panel.add(new JLabel(ResourceController.getMessage("option_save.add_fo_namespace")));
        // value
        addFoNamespaceCheck = new JCheckBox();
        if (OptionItems.ADD_FO_NAMESPACE)
            addFoNamespaceCheck.setSelected(true);
        panel.add(addFoNamespaceCheck);
    }

    /**
     * Adds to the panel the option item specifying whether the rearrange saving is used.
     * 
     * @param panel
     *            the parent panel.
     */
    private void optionChangeSave(JPanel panel) {
        // interrogation mark
        iconLabel = new JLabel();
        iconLabel.setToolTipText(ResourceController
                .getMessage("option_save.change_save.description"));
        iconLabel.setIcon(image);
        panel.add(iconLabel);
        // name
        panel.add(new JLabel(ResourceController.getMessage("option_save.change_save")));
        // value
        JPanel valuePanel = new JPanel();
        valuePanel.setLayout(new BoxLayout(valuePanel, BoxLayout.LINE_AXIS));
        changeSaveCheck = new JCheckBox();
        if (OptionItems.REARRANGE_SAVE)
            changeSaveCheck.setSelected(true);
        valuePanel.add(changeSaveCheck);
        valuePanel.add(Box.createRigidArea(new Dimension(10, 0)));
        valuePanel
                .add(new JLabel(ResourceController.getMessage("option_save.change_save.warning")));
        panel.add(valuePanel);
    }

    /**
     * Adds to the panel the option item specifying whether comments are generated in the
     * stylesheet.
     * 
     * @param panel
     *            the parent panel.
     */
    private void optionGenerateComments(JPanel panel) {
        // interrogation mark
        iconLabel = new JLabel();
        iconLabel.setToolTipText(ResourceController
                .getMessage("option_save.generate_com.description"));
        iconLabel.setIcon(image);
        panel.add(iconLabel);
        // name
        panel.add(new JLabel(ResourceController.getMessage("option_save.generate_com")));
        // value
        generateCommentsCheck = new JCheckBox();
        if (OptionItems.GENERATE_COMMENTS)
            generateCommentsCheck.setSelected(true);
        panel.add(generateCommentsCheck);
    }

    /**
     * Adds to the panel the option item specifying whether attribute <em>select</em> is used in
     * parameter elements
     * 
     * @param panel
     *            the parent panel.
     */
    private void optionUseParamSelect(JPanel panel) {
        // interrogation mark
        iconLabel = new JLabel();
        iconLabel.setToolTipText(ResourceController
                .getMessage("option_save.use_param_select.description"));
        iconLabel.setIcon(image);
        panel.add(iconLabel);
        // name
        panel.add(new JLabel(ResourceController.getMessage("option_save.use_param_select")));
        // value
        useParamSelectCheck = new JCheckBox();
        if (OptionItems.USE_PARAM_SELECT)
            useParamSelectCheck.setSelected(true);
        panel.add(useParamSelectCheck);
    }

    /**
     * Adds to the panel the option item specifying encoding of output files.
     * 
     * @param panel
     *            the parent panel.
     */
    private void optionEncoding(JPanel panel) {
        // interrogation mark
        iconLabel = new JLabel();
        iconLabel.setToolTipText(ResourceController.getMessage("option_save.encoding.description"));
        iconLabel.setIcon(image);
        panel.add(iconLabel);
        // name
        panel.add(new JLabel(ResourceController.getMessage("option_save.encoding")));
        // value
        encodingBox = new JComboBox(EncodingEnum.values());
        encodingBox.setSelectedItem(EncodingEnum.getEncoding(OptionItems.ENCODING));
        panel.add(encodingBox);
    }

    /**
     * Adds to the panel the option item specifying char of ends of lines in output files.
     * 
     * @param panel
     *            the parent panel.
     */
    private void optionNewline(JPanel panel) {
        // interrogation mark
        iconLabel = new JLabel();
        iconLabel.setToolTipText(ResourceController.getMessage("option_save.newline.description"));
        iconLabel.setIcon(image);
        panel.add(iconLabel);
        // name
        panel.add(new JLabel(ResourceController.getMessage("option_save.newline")));
        // value
        newlineBox = new JComboBox(NewlineEnum.values());
        newlineBox.setSelectedItem(OptionItems.NEWLINE);
        panel.add(newlineBox);
    }

    /**
     * Adds to the panel the option item specifying stylesheet version.
     * 
     * @param panel
     *            the parent panel.
     */
    private void optionStylesheetVersion(JPanel panel) {
        // interrogation mark
        iconLabel = new JLabel();
        iconLabel.setToolTipText(ResourceController
                .getMessage("option_save.stylesheet_version.description"));
        iconLabel.setIcon(image);
        panel.add(iconLabel);
        // name
        panel.add(new JLabel(ResourceController.getMessage("option_save.stylesheet_version")));
        // value
        stylesheetVersionField = new JTextField(OptionItems.STYLESHEET_VERSION);
        panel.add(stylesheetVersionField);
    }

    /**
     * Adds to the panel the option item specifying imported stylesheet files.
     * 
     * @param panel
     *            the parent panel.
     */
    private void optionImportedFiles(JPanel panel) {
        // interrogation mark
        iconLabel = new JLabel();
        iconLabel.setToolTipText(ResourceController
                .getMessage("option_save.import_file.description"));
        iconLabel.setIcon(image);
        panel.add(iconLabel);
        // name
        panel.add(new JLabel(ResourceController.getMessage("option_save.import_file")));
        // textarea
        importFileArea = new JTextArea(3, 5);
        importFileArea.setText(OptionItems.IMPORT_FILE);
        importFileArea.setLineWrap(true);
        importFileArea.setFont(new Font("SansSerif", Font.PLAIN, 12));
        JScrollPane scrollBar = new JScrollPane(importFileArea,
                JScrollPane.VERTICAL_SCROLLBAR_AS_NEEDED, JScrollPane.HORIZONTAL_SCROLLBAR_NEVER);
        panel.add(scrollBar);
    }

    /**
     * Saves the changes of stylesheet options made in the dialog by user.
     */
    public void saveChanges() {
        OptionItems.IMPORT_FILE = importFileArea.getText();
        OptionItems.ADD_FO_NAMESPACE = addFoNamespaceCheck.isSelected();
        OptionItems.REARRANGE_SAVE = changeSaveCheck.isSelected();
        OptionItems.GENERATE_COMMENTS = generateCommentsCheck.isSelected();
        OptionItems.USE_PARAM_SELECT = useParamSelectCheck.isSelected();
        OptionItems.ENCODING = ((EncodingEnum) encodingBox.getSelectedItem()).getKey();
        OptionItems.NEWLINE = (NewlineEnum) newlineBox.getSelectedItem();
        OptionItems.STYLESHEET_VERSION = stylesheetVersionField.getText();
        Log.info("info.option_form.save.save_values");
    }

    /**
     * Sets default values to all stylesheet options in the dialog.
     */
    public void updateValues() {
        importFileArea.setText(OptionItems.IMPORT_FILE);
        addFoNamespaceCheck.setSelected(OptionItems.ADD_FO_NAMESPACE);
        changeSaveCheck.setSelected(OptionItems.REARRANGE_SAVE);
        generateCommentsCheck.setSelected(OptionItems.GENERATE_COMMENTS);
        useParamSelectCheck.setSelected(OptionItems.USE_PARAM_SELECT);
        encodingBox.setSelectedItem(EncodingEnum.getEncoding(OptionItems.ENCODING));
        newlineBox.setSelectedItem(OptionItems.NEWLINE);
        stylesheetVersionField.setText(OptionItems.STYLESHEET_VERSION);
        Log.info(ErrorResourceController.getMessage("info.option_form.save.update_values"));
    }
}
