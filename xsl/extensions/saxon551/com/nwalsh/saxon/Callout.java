package com.nwalsh.saxon;

import com.icl.saxon.om.ElementInfo;

/**
 * <p>Utility class for the Verbatim extension (ignore this).</p>
 *
 * <p>$Id$</p>
 *
 * <p>Copyright (C) 2000 Norman Walsh.</p>
 *
 * <p>This class is just for book keeping in the Verbatim class.
 * It stores information about the location of callouts.</p>
 *
 * <p>Only line/column based callouts are supported. This class
 * implements the Comparable interface so that callouts can be sorted.
 * Callouts are sorted so that they occur in left-to-right,
 * top-to-bottom order based on line/column.</p>
 *
 * <p><b>Change Log:</b></p>
 * <dl>
 * <dt>1.0</dt>
 * <dd><p>Initial release.</p></dd>
 * </dl>
 *
 * @author Norman Walsh
 * <a href="mailto:ndw@nwalsh.com">ndw@nwalsh.com</a>
 *
 * @see Verbatim
 *
 * @version $Id$
 * */
public class Callout implements Comparable {
  /** The callout number. */
  private int callout = 0;
  /** The area ElementInfo item that generated this callout. */
  private ElementInfo area = null;
  /** The line on which this callout occurs. */
  private int line = 0;
  /** The column in which this callout appears. */
  private int col = 0;

  /** The constructor; initialize the private data structures. */
  public Callout(int callout, ElementInfo area, int line, int col) {
    this.callout = callout;
    this.area = area;
    this.line = line;
    this.col = col;
  }

  /**
   * <p>The compareTo method compares this Callout with another.</p>
   *
   * <p>Given two Callouts, A and B, A < B if:</p>
   *
   * <ol>
   * <li>A.line < B.line, or</li>
   * <li>A.line = B.line && A.col < B.col, or</li>
   * <li>A.line = B.line && A.col = B.col && A.callout < B.callout</li>
   * <li>Otherwise, they're equal.</li>
   * </ol>
   */
  public int compareTo (Object o) {
    Callout c = (Callout) o;

    if (line == c.getLine()) {
      if (col > c.getColumn()) {
	return 1;
      } else if (col < c.getColumn()) {
	return -1;
      } else {
	if (callout < c.getCallout()) {
	  return -1;
	} else if (callout > c.getCallout()) {
	  return 1;
	} else {
	  return 0;
	}
      }
    } else {
      if (line > c.getLine()) {
	return 1;
      } else {
	return -1;
      }
    }
  }

  /** Access the Callout's area. */
  public ElementInfo getArea() {
    return area;
  }

  /** Access the Callout's line. */
  public int getLine() {
    return line;
  }

  /** Access the Callout's column. */
  public int getColumn() {
    return col;
  }

  /** Access the Callout's callout number. */
  public int getCallout() {
    return callout;
  }
}

