package cz.zcu.fav.kiv.editor.graphics.components.attributes;

import java.awt.BorderLayout;
import java.awt.Container;
import java.awt.Dimension;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.BorderFactory;
import javax.swing.Box;
import javax.swing.BoxLayout;

import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JPanel;
import javax.swing.JTabbedPane;

import cz.zcu.fav.kiv.editor.beans.properties.AttributeGroup;
import cz.zcu.fav.kiv.editor.beans.properties.Property;
import cz.zcu.fav.kiv.editor.controller.resource.ResourceController;
import cz.zcu.fav.kiv.editor.graphics.MainFrame;
import cz.zcu.fav.kiv.editor.graphics.images.EditorIcon;

/**
 * The <code>AttributeDialog</code> class is the dialog with <code>Attribute</code>s of one
 * <code>Property</code>.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class AttributeDialog extends JDialog implements ActionListener {

    private static final long serialVersionUID = -6526357047305363516L;

    /** The dialog representing the <code>Property</code> */
    private static AttributeDialog dialog;

    /** The property which <code>Attribute</code>s the dialog displays */
    private static Property property;

    /** The save command */
    private static final String SAVE_COMMAND = "save";

    /** The size of margin */
    private static final int MARGIN = 10;

    /**
     * Displays the dialog with property attributes.
     * 
     * @param prop
     *            the property with attributes.
     */
    public static void showDialog(Property prop) {
        property = prop;
        dialog = new AttributeDialog();
        dialog.setVisible(true);
    }

    /**
     * Initializes a newly created <code>AttributeDialog</code>.
     */
    private AttributeDialog() {
        super(MainFrame.getInstance(), ResourceController.getMessage("frame.attribute.title")
                + property.getName(), true);

        Container pan = new JPanel(new BorderLayout());

        ImageIcon icon = EditorIcon.createTabIcon();

        JTabbedPane tabPanel = new JTabbedPane(JTabbedPane.TOP);
        for (AttributeGroup panel : property.getAttributeGroupList()) {
            tabPanel.addTab(panel.getTitle(), icon,
                    new AttributeComponent(panel.getAttributeList()));
        }
        pan.add(tabPanel, BorderLayout.CENTER);

        // Create and initialize the buttons.
        JButton cancelButton = new JButton(ResourceController.getMessage("button.cancel"));
        cancelButton.addActionListener(this);

        JButton setButton = new JButton(ResourceController.getMessage("button.save"));
        setButton.setActionCommand(SAVE_COMMAND);
        setButton.addActionListener(this);
        getRootPane().setDefaultButton(setButton);

        // Lay out the buttons from left to right.
        JPanel buttonPane = new JPanel();
        buttonPane.setLayout(new BoxLayout(buttonPane, BoxLayout.LINE_AXIS));
        buttonPane.setBorder(BorderFactory.createEmptyBorder(MARGIN, MARGIN, MARGIN, MARGIN));
        buttonPane.add(Box.createHorizontalGlue());
        buttonPane.add(setButton);
        buttonPane.add(Box.createRigidArea(new Dimension(MARGIN, MARGIN)));
        buttonPane.add(cancelButton);

        pan.add(buttonPane, BorderLayout.PAGE_END);

        this.getContentPane().add(pan, BorderLayout.CENTER);

        this.pack();
        this.setLocationRelativeTo(MainFrame.getInstance());
    }

    /**
     * Action performed when a button of the dialog is pressed. If the <em>Save</em> button is
     * pressed, then the changed attribute values are saved.
     */
    public void actionPerformed(ActionEvent event) {
        if (SAVE_COMMAND.equals(event.getActionCommand())) {
            property.setValuesFromTemporary();
            property.setChosen();
            MainFrame.getInstance().setFileChanged();
        }
        AttributeDialog.dialog.setVisible(false);
        AttributeDialog.dialog.dispose();
    }

}
