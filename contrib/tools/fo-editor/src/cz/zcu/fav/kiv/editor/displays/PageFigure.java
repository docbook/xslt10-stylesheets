package cz.zcu.fav.kiv.editor.displays;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.geom.Rectangle2D;
import java.util.Observable;
import java.util.Observer;

import cz.zcu.fav.kiv.editor.beans.parameters.Parameter;

/**
 * The <code>PageFigure</code> class represents a graphics figure illustrating dimesions of the
 * paper.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class PageFigure extends GraphicsFigure implements Observer {

    private static final long serialVersionUID = 7211322657832007934L;

    /** The reference to the parameter representing paper width */
    private Parameter pageWidthParameter;

    /** The reference to the parameter representing paper height */
    private Parameter pageHeightParameter;

    /** The total size of graphics figure */
    private static final int SIZE = 140;

    /** The maximum size of the paper */
    private static final int PAPER_SIZE = 100;

    /** The actual width of the graphics figure illustrating paper */
    private int widthSize;

    /** The actual height of the graphics figure illustrating paper */
    private int heightSize;

    /** The color of the graphics figure illustrating paper */
    private static final Color PAPER_COLOR = new Color(0, 64, 128);

    public PageFigure() {
        this.setPreferredSize(new Dimension(SIZE, SIZE));
    }

    /**
     * Repaints the graphics figure according to actual parameter values.
     */
    public void paintComponent(Graphics graphics) {
        Graphics2D graphics2 = (Graphics2D) graphics;
        super.paintComponent(graphics);
        countSizes();

        graphics2.setColor(PAPER_COLOR);
        graphics2.fill(new Rectangle2D.Double((SIZE - PAPER_SIZE) / 2, (SIZE - PAPER_SIZE) / 2,
                widthSize, heightSize));
    }

    @Override
    public void setInputs(Parameter[] parameterList) {
        this.pageWidthParameter = parameterList[0];
        this.pageWidthParameter.addObserver(this);
        this.pageHeightParameter = parameterList[1];
        this.pageHeightParameter.addObserver(this);
    }

    /**
     * Method is called when some dependent parameter changes his value. Then the graphics figure
     * values are updated according to parameter values.
     */
    public void update(Observable arg0, Object arg1) {
        this.repaint();
    }

    /**
     * Counts new sizes of the graphics figure illustrating paper. New sizes are counted on the
     * basis of parameter actual values.
     */
    private void countSizes() {
        Double pageWidth = Double.valueOf(pageWidthParameter.getType().getValue().replace(",", "."));
        double pageHeight = Double.valueOf(pageHeightParameter.getType().getValue().replace(",", "."));
        Double max = Math.max(pageWidth, pageHeight);
        max /= PAPER_SIZE;
        widthSize = (int) (pageWidth / max);
        heightSize = (int) (pageHeight / max);
    }
}
