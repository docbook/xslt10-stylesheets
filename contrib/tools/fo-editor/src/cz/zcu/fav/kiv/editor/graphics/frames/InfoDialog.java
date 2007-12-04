package cz.zcu.fav.kiv.editor.graphics.frames;

import java.awt.BorderLayout;
import java.awt.Container;
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
 * The abstract class <code>InfoDialog</code> is the dialog used for displaying various information.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public abstract class InfoDialog extends JDialog implements ActionListener {

    private static final long serialVersionUID = -4632123976081227814L;

    /** The size of horizontal margin */
    protected static final int HORIZONTAL_MARGIN = 8;

    /** The size of vertical margin */
    protected static final int VERTICAL_MARGIN = 25;

    /**
     * Initializes a newly created <code>InfoDialog</code> with specified title.
     * 
     * @param title
     *            the title of the dialog.
     */
    protected InfoDialog(String title) {
        super(MainFrame.getInstance(), ResourceController.getMessage(title), true);
        this.setLocationRelativeTo(MainFrame.getInstance());
    }

    /**
     * Initializes the content of the dialog.
     */
    public void dialogInit() {
        JPanel buttonPane = new JPanel();
        buttonPane.setBorder(BorderFactory.createEmptyBorder(HORIZONTAL_MARGIN, VERTICAL_MARGIN,
                HORIZONTAL_MARGIN, VERTICAL_MARGIN));
        buttonPane.add(Box.createHorizontalGlue());
        buttonPane.setLayout(new BoxLayout(buttonPane, BoxLayout.LINE_AXIS));

        JButton button = new JButton(ResourceController.getMessage("button.ok"));
        button.addActionListener(this);
        buttonPane.add(button);

        super.dialogInit();
        Container content = this.getContentPane();
        content.add(createContent(), BorderLayout.PAGE_START);
        content.add(buttonPane, BorderLayout.PAGE_END);

        pack();
    }

    /**
     * Creates the panel forming the content of the dialog.
     * 
     * @return the panel forming the content of the dialog.
     */
    abstract protected JPanel createContent();

    /**
     * Action performed when a button of dialog is pressed - then the dialog closes.
     */
    public void actionPerformed(ActionEvent e) {
        this.setVisible(false);
    }
}
