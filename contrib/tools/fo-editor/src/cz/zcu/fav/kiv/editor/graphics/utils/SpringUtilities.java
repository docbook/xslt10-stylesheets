package cz.zcu.fav.kiv.editor.graphics.utils;

import java.awt.Component;
import java.awt.Container;

import javax.swing.Spring;
import javax.swing.SpringLayout;

import cz.zcu.fav.kiv.editor.controller.logger.Log;

/**
 * The <code>SpringUtilities</code> class is used for laying out components within a container in
 * the compact grid.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class SpringUtilities {

    /**
     * Gets the constraints for the specified cell.
     * 
     * @param row
     *            row where the cell is placed.
     * @param col
     *            column where the cell is placed.
     * @param parent
     *            the parent container of the cell.
     * @param cols
     *            number of columns.
     * @return the constraints for the cell.
     */
    private static SpringLayout.Constraints getConstraintsForCell(int row, int col,
            Container parent, int cols) {
        SpringLayout layout = (SpringLayout) parent.getLayout();
        Component c = parent.getComponent(row * cols + col);

        return layout.getConstraints(c);
    }

    /**
     * Aligns the first <code>rows</code> * <code>cols</code> components of <code>parent</code>
     * in a grid. Each component in a column is as wide as the maximum preferred width of the
     * components in that column; height is similarly determined for each row. The parent is made
     * just big enough to fit them all.
     * 
     * @param rows
     *            number of rows.
     * @param cols
     *            number of columns.
     * @param initialX
     *            x location to start the grid at.
     * @param initialY
     *            y location to start the grid at.
     * @param xPad
     *            x padding between cells.
     * @param yPad
     *            y padding between cells.
     */
    public static void makeCompactGrid(Container parent, int rows, int cols, int initialX,
            int initialY, int xPad, int yPad) {
        SpringLayout layout;
        try {
            layout = (SpringLayout) parent.getLayout();
        } catch (ClassCastException exc) {
            Log.error(exc);
            return;
        }

        // Align all cells in each column and make them the same width.
        Spring x = Spring.constant(initialX);
        for (int c = 0; c < cols; c++) {
            Spring width = Spring.constant(0);
            for (int r = 0; r < rows; r++) {
                width = Spring.max(width, getConstraintsForCell(r, c, parent, cols).getWidth());
            }
            for (int r = 0; r < rows; r++) {
                SpringLayout.Constraints constraints = getConstraintsForCell(r, c, parent, cols);
                constraints.setX(x);
                constraints.setWidth(width);
            }
            x = Spring.sum(x, Spring.sum(width, Spring.constant(xPad)));
        }

        // Align all cells in each row and make them the same height.
        Spring y = Spring.constant(initialY);
        for (int r = 0; r < rows; r++) {
            Spring height = Spring.constant(0);
            for (int c = 0; c < cols; c++) {
                height = Spring.max(height, getConstraintsForCell(r, c, parent, cols).getHeight());
            }

            for (int c = 0; c < cols; c++) {
                SpringLayout.Constraints constraints = getConstraintsForCell(r, c, parent, cols);
                constraints.setY(y);
                constraints.setHeight(height);
            }
            y = Spring.sum(y, Spring.sum(height, Spring.constant(yPad)));
        }

        // Set the parent's size.
        SpringLayout.Constraints pCons = layout.getConstraints(parent);
        pCons.setConstraint(SpringLayout.SOUTH, y);
        pCons.setConstraint(SpringLayout.EAST, x);
    }
}
