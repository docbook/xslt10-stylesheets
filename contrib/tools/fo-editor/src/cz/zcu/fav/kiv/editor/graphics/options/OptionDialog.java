package cz.zcu.fav.kiv.editor.graphics.options;

import java.awt.BorderLayout;
import java.awt.Container;
import java.awt.Dimension;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.BorderFactory;
import javax.swing.Box;
import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JPanel;

import cz.zcu.fav.kiv.editor.controller.resource.ResourceController;
import cz.zcu.fav.kiv.editor.graphics.MainFrame;

/**
 * The abstract class <code>OptionDialog</code> is the dialog used for editing application
 * options.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public abstract class OptionDialog extends JDialog implements ActionListener {

    private static final long serialVersionUID = -6526357047305363516L;

    /** The width of the dialog */
    private static final int DIALOG_WIDTH = 500;

    /** The size of margin */
    private static final int MARGIN = 10;

    /** The command SAVE */
    private static final String SAVE_COMMAND = "save";

    /** The option dialog */
    protected static OptionDialog dialog;

    /**
     * Initializes a newly created <code>OptionDialog</code> with specified title.
     * 
     * @param title
     *            the title of the dialog.
     */
    protected OptionDialog(String title) {
        super(MainFrame.getInstance(), ResourceController.getMessage(title), true);

        Container pan = new JPanel(new BorderLayout());

        JPanel contentPanel = new JPanel();
        contentPanel.setLayout(new BoxLayout(contentPanel, BoxLayout.PAGE_AXIS));

        contentPanel.add(createForm());

        pan.add(contentPanel, BorderLayout.PAGE_START);
        pan.add(createButtonPane(), BorderLayout.PAGE_END);

        this.getContentPane().add(pan, BorderLayout.CENTER);
        this.setResizable(false);

        this.pack();
        this.setSize(new Dimension(DIALOG_WIDTH, this.getHeight()));
        this.setLocationRelativeTo(MainFrame.getInstance());
    }

    /**
     * Creates the form that makes the content of the dialog.
     * 
     * @return the form creating the dialog content.
     */
    protected abstract JPanel createForm();

    /**
     * Saves the changes of options made in the dialog by user.
     */
    protected abstract void saveChanges();

    /**
     * Sets default values to all options in the dialog.
     */
    protected abstract void updateValues();

    /**
     * Action performed when a button of dialog is pressed. If the button is Save, then the changes
     * of options are saved.
     */
    public void actionPerformed(ActionEvent e) {
        if (SAVE_COMMAND.equals(e.getActionCommand())) {
            saveChanges();
        }

        OptionDialog.dialog.setVisible(false);
        OptionDialog.dialog.dispose();
    }

    /**
     * Creates the dialog panel with buttons.
     * 
     * @return the panel with buttons.
     */
    private JPanel createButtonPane() {
        JButton defaultButton = new JButton(ResourceController.getMessage("button.default"));
        defaultButton.addActionListener(new ChangeDefault());

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
        buttonPane.add(defaultButton);
        buttonPane.add(Box.createRigidArea(new Dimension(3 * MARGIN, 0)));
        buttonPane.add(setButton);
        buttonPane.add(Box.createRigidArea(new Dimension(MARGIN, 0)));
        buttonPane.add(cancelButton);

        return buttonPane;
    }

    /**
     * The inner class <code>ChangeDefault</code> class sets default values to options in the
     * dialog when the button Restore Defaults is set.
     * 
     * @author Marta Vaclavikova
     * @version 1.0, 05/2007
     */
    class ChangeDefault implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            updateValues();
        }
    }
}
