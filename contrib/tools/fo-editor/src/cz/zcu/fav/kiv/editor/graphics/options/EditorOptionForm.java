package cz.zcu.fav.kiv.editor.graphics.options;

import java.awt.Dimension;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;

import javax.swing.BorderFactory;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JCheckBox;
import javax.swing.JComboBox;
import javax.swing.JFileChooser;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextField;
import javax.swing.SpringLayout;

import cz.zcu.fav.kiv.editor.controller.logger.Log;
import cz.zcu.fav.kiv.editor.controller.options.OptionItems;
import cz.zcu.fav.kiv.editor.controller.resource.LanguageEnum;
import cz.zcu.fav.kiv.editor.controller.resource.ResourceController;
import cz.zcu.fav.kiv.editor.graphics.MainFrame;
import cz.zcu.fav.kiv.editor.graphics.images.EditorIcon;
import cz.zcu.fav.kiv.editor.graphics.utils.SpringUtilities;

/**
 * The <code>EditorOptionForm</code>class is the form with stylesheet options. It makes the content
 * of the <code>OptionEditorDialog</code> dialog.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class EditorOptionForm extends JPanel {

    private static final long serialVersionUID = -1040245299541084094L;

    /** The number of rows in the form */
    private static final int ROW_COUNT = 3;

    /** The number of columns in the form */
    private static final int COLUMN_COUNT = 3;

    /** The width of the field with file path */
    private static final int FILE_FIELD_WIDTH = 200;

    /** The size of component margin */
    private static final int COMPONENT_MARGIN = 3;

    /** The label containing option name */
    private JLabel iconLabel;

    /** The icon image representing option item help */
    private ImageIcon image;

    /**
     * The text-field specifying path of the directory with files containing XML definitions of
     * parameters
     */
    private JTextField xmlDefPathField;

    /** The combo-box specifying language of the editor */
    private JComboBox languageBox;

    /** The check-box specifying whether the editor console is erased before every action */
    private JCheckBox eraseConsoleCheck;

    /**
     * Initializes a newly created <code>EditorOptionForm</code>.
     */
    public EditorOptionForm() {
        this.setLayout(new SpringLayout());

        this.setBorder(BorderFactory.createEtchedBorder());

        image = EditorIcon.createHelpIcon();

        optionLanguage();
        optionXmlDefPath();
        optionEraseConsole();

        SpringUtilities.makeCompactGrid(this, ROW_COUNT, COLUMN_COUNT, COMPONENT_MARGIN,
                COMPONENT_MARGIN, COMPONENT_MARGIN, COMPONENT_MARGIN);
    }

    /**
     * Adds to the form the option item specifying language of the editor.
     */
    private void optionLanguage() {
        // interrogation mark
        iconLabel = new JLabel();
        iconLabel.setToolTipText(ResourceController
                .getMessage("option_editor.language.description"));
        iconLabel.setIcon(image);
        this.add(iconLabel);
        // name
        this.add(new JLabel(ResourceController.getMessage("option_editor.language")));
        // value
        languageBox = new JComboBox(LanguageEnum.values());
        languageBox.setSelectedItem(LanguageEnum.getLanguage(OptionItems.LANGUAGE));
        this.add(languageBox);
    }

    /**
     * Adds to the form the option item specifying the path directory with files containing XML
     * definitions of parameters.
     */
    private void optionXmlDefPath() {
        // interrogation mark
        iconLabel = new JLabel();
        iconLabel.setToolTipText(ResourceController
                .getMessage("option_editor.xml_definition_path.description"));
        iconLabel.setIcon(image);
        this.add(iconLabel);
        // name
        this.add(new JLabel(ResourceController.getMessage("option_editor.xml_definition_path")));
        // value
        this.add(createFileChooser());
    }

    /**
     * Creates the panel with a text-field and button that shows a file chooser dialog. The chosen
     * file path is saved to the text-field.
     * 
     * @return the panel used for choosing file paths.
     */
    private JPanel createFileChooser() {
        JPanel valuePanel = new JPanel();
        xmlDefPathField = new JTextField(OptionItems.XML_DEFINITION_PATH);
        xmlDefPathField.setPreferredSize(new Dimension(FILE_FIELD_WIDTH, xmlDefPathField
                .getPreferredSize().height));
        valuePanel.add(xmlDefPathField);
        JButton chooseButton = new JButton(ResourceController
                .getMessage("option_editor.xml_definition_path.button"));
        chooseButton.addActionListener(new ChoosePath());
        valuePanel.add(chooseButton);
        return valuePanel;
    }

    /**
     * Adds to the form the option item specifying whether the editor console is erased before every
     * action.
     */
    private void optionEraseConsole() {
        // interrogation mark
        iconLabel = new JLabel();
        iconLabel.setToolTipText(ResourceController
                .getMessage("option_editor.erase_console.description"));
        iconLabel.setIcon(image);
        this.add(iconLabel);
        // name
        this.add(new JLabel(ResourceController.getMessage("option_editor.erase_console")));
        // value
        eraseConsoleCheck = new JCheckBox();
        if (OptionItems.ERASE_CONSOLE)
            eraseConsoleCheck.setSelected(true);
        this.add(eraseConsoleCheck);
    }

    /**
     * Saves the changes of editor options made in the dialog by user.
     */
    public void saveChanges() {
        OptionItems.XML_DEFINITION_PATH = xmlDefPathField.getText();
        if (!((LanguageEnum) languageBox.getSelectedItem()).getLocale()
                .equals(OptionItems.LANGUAGE))
            OptionItems.changeLanguage(((LanguageEnum) languageBox.getSelectedItem()).getLocale());
        OptionItems.ERASE_CONSOLE = eraseConsoleCheck.isSelected();
        Log.info("info.option_form.editor.save_values");
    }

    /**
     * Sets default values to all editor options in the dialog.
     */
    public void updateValues() {
        languageBox.setSelectedItem(LanguageEnum.getLanguage(OptionItems.LANGUAGE));
        xmlDefPathField.setText(OptionItems.XML_DEFINITION_PATH);
        eraseConsoleCheck.setSelected(OptionItems.ERASE_CONSOLE);
        Log.info("info.option_form.editor.update_values");
    }

    /**
     * The <code>ChoosePath</code> class shows the open file dialog that enables to choose a
     * directory. Then the chosen directory path is saved to the <code>xmlDefPathField</code>.
     * 
     * @author Marta Vaclavikova
     * @version 1.0, 05/2007
     */
    class ChoosePath implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            JFileChooser fc = new JFileChooser();
            File directory = new File(OptionItems.XML_DEFINITION_PATH);
            if (directory.exists())
                fc.setCurrentDirectory(directory);
            fc.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
            int returnVal = fc.showOpenDialog(MainFrame.getInstance());
            if (returnVal == JFileChooser.APPROVE_OPTION) {
                xmlDefPathField.setText(fc.getSelectedFile().getPath());
            }
        }
    }
}
