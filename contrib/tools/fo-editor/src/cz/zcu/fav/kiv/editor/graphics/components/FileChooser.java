package cz.zcu.fav.kiv.editor.graphics.components;

import java.awt.Dimension;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;
import java.util.Observable;
import java.util.Observer;

import javax.swing.Box;
import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JFileChooser;
import javax.swing.JPanel;
import javax.swing.JTextField;

import cz.zcu.fav.kiv.editor.beans.types.Type;
import cz.zcu.fav.kiv.editor.controller.resource.ResourceController;
import cz.zcu.fav.kiv.editor.graphics.MainFrame;

/**
 * The <code>FileChooser</code> class is the component <em>text-field</em> and <em>button</em>
 * used for choosing a directory path with the <em>file-chooser</em>.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class FileChooser extends JPanel implements Observer, ActionListener {

    private static final long serialVersionUID = -151909741397111994L;

    /** The width of the text-field */
    private static final int WIDTH = 180;

    /** The width of the empty gap between the text-field and the button */
    private static final int EMPTY_GAP_WIDTH = 10;
    
    /** The height of the empty gap between the text-field and the button */
    private static final int EMPTY_GAP_HEIGHT = 0;

    /** The parameter type which values the component displays */
    private Type type;

    /** The text-field displaying directory path */
    private JTextField textField;

    /** The file-chooser used for choosing a directory path */
    JFileChooser fileChooser = new JFileChooser();

    /**
     * Initializes a newly created <code>FileChooser</code> with the parameter type.
     * 
     * @param type
     *            the parameter type.
     */
    public FileChooser(Type type) {
        this.setLayout(new BoxLayout(this, BoxLayout.X_AXIS));

        // text-field
        textField = new JTextField(type.getValue());
        textField.setPreferredSize(new Dimension(WIDTH, textField.getPreferredSize().height));
        this.add(textField);

        this.add(Box.createRigidArea(new Dimension(EMPTY_GAP_WIDTH, EMPTY_GAP_HEIGHT)));

        // chooser button
        JButton chooseButton = new JButton(ResourceController
                .getMessage("option_editor.xml_definition_path.button"));
        chooseButton.addActionListener(this);
        this.add(chooseButton);

        this.type = type;
        type.addObserver(this);
    }

    /**
     * Sets a new parameter value to the text-field.
     * 
     * @param observable
     *            the observable object.
     * @param value
     *            the new parameter value.
     */
    public void update(Observable observable, Object value) {
        textField.setText(value.toString());
    }

    /**
     * Action performed when the button is pressed, it displays the file-chooser enabling to choose
     * a direcotory path. Assignes a new value to the parameter <em>type</em>.
     * 
     * @param event
     *            the item event.
     */
    public void actionPerformed(ActionEvent event) {
        File directory = new File(textField.getText());
        if (directory.exists())
            fileChooser.setCurrentDirectory(directory);

        int returnVal = fileChooser.showOpenDialog(MainFrame.getInstance());
        if (returnVal == JFileChooser.APPROVE_OPTION) {
            textField.setText(fileChooser.getSelectedFile().getPath());
            type.changeValue(fileChooser.getSelectedFile().getPath());
            MainFrame.getInstance().setFileChanged();
        }
    }

}
