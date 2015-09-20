package cz.zcu.fav.kiv.editor.graphics.components;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.ItemEvent;
import java.awt.event.ItemListener;
import java.util.Observable;
import java.util.Observer;

import javax.swing.Box;
import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JColorChooser;
import javax.swing.JComboBox;
import javax.swing.JDialog;
import javax.swing.JPanel;

import cz.zcu.fav.kiv.editor.beans.types.Type;
import cz.zcu.fav.kiv.editor.controller.MessageWriter;
import cz.zcu.fav.kiv.editor.controller.resource.ResourceController;
import cz.zcu.fav.kiv.editor.graphics.MainFrame;
import cz.zcu.fav.kiv.editor.graphics.images.EditorIcon;
import cz.zcu.fav.kiv.editor.utils.TagParser;

/**
 * The <code>ColorChooser</code> class is the component used for choosing colors from the list of
 * colors or from the color palette.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class ColorChooser extends JPanel implements ActionListener, ItemListener, Observer {

    private static final long serialVersionUID = -2515399651281284846L;

    /** The width of the rectangle displaying the actually chosen color */
    public static final int COLOR_RECT_WIDTH = 25;

    /** The height of the rectangle displaying the actually chosen color */
    public static final int COLOR_RECT_HEIGHT = 23;

    /** The size of the button displaying the dialog with color palette */
    public static final int BUTTON_SIZE = 20;

    /** The width of the empty gap components */
    private static final int EMPTY_GAP_WIDTH = 10;

    /** The height of the empty gap components */
    private static final int EMPTY_GAP_HEIGHT = 0;

    /** The list of predefined colors */
    private JComboBox colorBox;

    /** The button displaying the dialog with color palette */
    private JButton colorButton;

    /** The color palette enabling choosing of colors */
    private JColorChooser colorChooser;

    /** The rectangle displaying the actually chosen color */
    private ColorRect colorRect;

    /** The dialog displaying the color palette */
    private JDialog dialog;

    /** The parameter type which values the component displays */
    private Type type;

    /** The actually choosen color */
    private Color color;

    /**
     * Initializes a newly created <code>ColorChooser</code> with the parameter type.
     * 
     * @param type
     *            the parameter type.
     */
    public ColorChooser(Type type) {
        this.setLayout(new BoxLayout(this, BoxLayout.X_AXIS));
        this.type = type;
        type.addObserver(this);

        // color combo-box
        colorBox = new JComboBox(type.getValueList().keySet().toArray());
        this.color = getColor(type.getValue());
        setSelectedColor(type.getValue());
        colorBox.setEditable(true);
        colorBox.addItemListener(this);
        this.add(colorBox);

        this.add(Box.createRigidArea(new Dimension(EMPTY_GAP_WIDTH, EMPTY_GAP_HEIGHT)));

        // button displaying the color palette
        colorButton = new JButton(EditorIcon.createColorIcon());
        colorButton.setPreferredSize(new Dimension(BUTTON_SIZE, BUTTON_SIZE));
        colorButton.addActionListener(this);
        this.add(colorButton);

        this.add(Box.createRigidArea(new Dimension(EMPTY_GAP_WIDTH, EMPTY_GAP_HEIGHT)));

        // color rectangle
        colorRect = new ColorRect();
        this.add(colorRect);
    }

    /**
     * Sets a new color according to the input value. If the input value is not valid color value,
     * then the previous color is kept.
     * 
     * @param observable
     *            the observable object.
     * @param value
     *            the new parameter value.
     */
    public void update(Observable observable, Object value) {
        Color newColor = getColor(value.toString());
        if (newColor != null) {
            setSelectedColor(value);
            this.color = newColor;
        } else {
            type.changeValue(TagParser.createColor(color));
            MessageWriter.writeWarning(ResourceController.getMessage(
                    "error.component.update_value", type.getOwnerName(), value));
        }
    }

    /**
     * Action performed when the button is pressed, it displays the dialog with color palette.
     * 
     * @param event
     *            the item event.
     */
    public void actionPerformed(ActionEvent event) {
        colorChooser = new JColorChooser(color);
        colorChooser.setPreviewPanel(new JPanel());

        dialog = JColorChooser.createDialog(this, ResourceController
                .getMessage("component.color_editor.title"), true, colorChooser, new ActionColor(),
                null);
        dialog.setVisible(true);
    }

    /**
     * Action performed when a color from the combo-box list has been selected or a new one is
     * inserted. Assignes a new value to the parameter <em>type</em>. If the inserted color is
     * invalid, then the previous color is kept.
     * 
     * @param event
     *            the item event.
     */
    public void itemStateChanged(ItemEvent event) {
        if ((event.getStateChange() & ItemEvent.ITEM_STATE_CHANGED) != 0) {
            Color col = getColor(colorBox.getSelectedItem().toString());
            if (col != null) {
                type.changeValue((String) colorBox.getSelectedItem());
                this.color = col;
                colorRect.repaint();
                MainFrame.getInstance().setFileChanged();
            } else {
                setSelectedColor(type.getValue());
            }
        }
    }

    /**
     * Selects the input color in the list if the list contains it or adds the new color to the
     * list.
     * 
     * @param newColor
     *            the actually selected color.
     */
    private void setSelectedColor(Object newColor) {
        for (int i = 0; i < colorBox.getItemCount(); i++) {
            if (colorBox.getItemAt(i).equals(type.getKeyFromValue(newColor.toString()))
                    || colorBox.getItemAt(i).equals(newColor.toString())) {
                colorBox.setSelectedIndex(i);
                return;
            }
        }
        if (colorBox.getItemCount() > type.getValueList().size())
            colorBox.removeItemAt(0);
        colorBox.insertItemAt(newColor, 0);
        colorBox.setSelectedIndex(0);
    }

    /**
     * The <em>ActionColor</em> inner class represents the action performed when a color is
     * choosen in the color palette.
     * 
     * @author Marta Vaclavikova
     * @version 1.0, 05/2007
     */
    class ActionColor implements ActionListener {
        public void actionPerformed(ActionEvent event) {
            color = colorChooser.getColor();

            String colStr = TagParser.createColor(color);
            dialog.dispose();
            type.changeValue(colStr);
            setSelectedColor(colStr);
            MainFrame.getInstance().setFileChanged();
        }
    }

    /**
     * Creates <em>Color</em> from the string containing a color in the hexadecimal format #rrggbb
     * or containing a color name.
     * 
     * @param color
     *            the string containing a color in the hexadecimal format #rrggbb or containing a
     *            color name.
     * @return the color parsed from the string.
     */
    private Color getColor(String color) {
        if (type.getValueList().get(color) != null)
            return TagParser.parseColor(type.getValueList().get(color));
        else
            return TagParser.parseColor(color);
    }

    /**
     * The <code>ColorRect</code> inner class represents the rectangle displaying actually choosen
     * color.
     * 
     * @author Marta Vaclavikova
     * @version 1.0, 05/2007
     */
    class ColorRect extends JPanel {

        private static final long serialVersionUID = 5631478801104148565L;

        /**
         * Initializes a newly created <code>ColorRect</code>class.
         */
        public ColorRect() {
            this.setPreferredSize(new Dimension(COLOR_RECT_WIDTH, COLOR_RECT_HEIGHT));
        }

        /**
         * Changes the color of the rectangle according to the actually chosen color.
         */
        public void paintComponent(Graphics graphics) {
            super.paintComponent(graphics);
            graphics.setColor(color);
            graphics.fillRect(0, 0, COLOR_RECT_WIDTH, COLOR_RECT_HEIGHT);
        }
    }
}
