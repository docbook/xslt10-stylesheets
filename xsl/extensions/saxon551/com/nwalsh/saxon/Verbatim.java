// Verbatim.java - Saxon extensions supporting DocBook verbatim environments

package com.nwalsh.saxon;

import java.util.Stack;
import java.util.StringTokenizer;
import org.xml.sax.*;
import org.w3c.dom.*;
import com.icl.saxon.expr.*;
import com.icl.saxon.om.*;
import com.icl.saxon.pattern.*;
import com.icl.saxon.Context;
import com.icl.saxon.AttributeCollection;
import com.icl.saxon.functions.Extensions;
import com.icl.saxon.tree.*;
import com.nwalsh.saxon.Callout;

/**
 * <p>Saxon extensions supporting DocBook verbatim environments</p>
 *
 * <p>$Id$</p>
 *
 * <p>Copyright (C) 2000 Norman Walsh.</p>
 *
 * <p>This class provides a
 * <a href="http://users.iclway.co.uk/mhkay/saxon/">Saxon</a>
 * implementation of two features that would be impractical to
 * implement directly in XSLT: line numbering and callouts.</p>
 *
 * <p><b>Line Numbering</b></p>
 * <p>The <tt>numberLines</tt> family of functions takes a result tree
 * fragment (assumed to contain the contents of a formatted verbatim
 * element in DocBook: programlisting, screen, address, literallayout,
 * or synopsis) and returns a result tree fragment decorated with
 * line numbers.</p>
 *
 * <p><b>Callouts</b></p>
 * <p>The <tt>insertCallouts</tt> family of functions takes an
 * <tt>areaspec</tt> and a result tree fragment
 * (assumed to contain the contents of a formatted verbatim
 * element in DocBook: programlisting, screen, address, literallayout,
 * or synopsis) and returns a result tree fragment decorated with
 * callouts.</p>
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
 * @version $Id$
 *
 */
public class Verbatim {
  /** A stack to hold the open elements while walking through a verbatim. */
  private static Stack elementStack = null;
  /** A stack to hold the temporarily closed elements. */
  private static Stack tempStack = null;
  /** The current line number. */
  private static int lineNumber = 0;
  /** The current column number. */
  private static int colNumber = 0;
  /** The modulus for line numbering (every 'modulus' line is numbered). */
  private static int modulus = 0;
  /** The width (in characters) of line numbers (for padding). */
  private static int width = 0;
  /** The separator between the line number and the verbatim text. */
  private static String separator = "";
  /** The (sorted) array of callouts obtained from the areaspec. */
  private static Callout callout[] = null;
  /** The number of callouts in the callout array. */
  private static int calloutCount = 0;
  /** A pointer used to keep track of our position in the callout array. */
  private static int calloutPos = 0;
  /** The default column for callouts. */
  private static int defaultColumn = 60;
  /** The callout formatter */
  private static FormatCallout fCallout = null;

  /**
   * <p>Constructor for Verbatim</p>
   *
   * <p>All of the methods are static, so the constructor does nothing.</p>
   */
  public Verbatim() {
  }

  /**
   * <p>Find the string value of a stylesheet variable or parameter</p>
   *
   * <p>Returns the string value of <code>varName</code> in the current
   * <code>context</code>. Returns the empty string if the variable is
   * not defined.</p>
   *
   * @param context The current stylesheet context
   * @param varName The name of the variable (without the dollar sign)
   *
   * @return The string value of the variable
   */
  protected static String getVariable(Context context, String varName) {
    Value variable = null;
    String varString = null;

    try {
      variable = Extensions.evaluate(context, "$" + varName);
      varString = variable.asString();
      return varString;
    } catch (SAXException se) {
      System.out.println("Undefined variable: " + varName);
      return "";
    } catch (IllegalArgumentException e) {
      System.out.println("Undefined variable: " + varName);
      return "";
    }
  }

  /**
   * <p>Setup the parameters associated with line numbering</p>
   *
   * <p>This method queries the stylesheet for the variables
   * associated with line numbering. It is called automatically before
   * lines are numbered. The context is used to retrieve the values,
   * this allows templates to redefine these variables.</p>
   *
   * <p>The following variables are queried. If the variables do not
   * exist, builtin defaults will be used (but you may also get a bunch
   * of messages from the Java interpreter).</p>
   *
   * <dl>
   * <dt><code>linenumbering.everyNth</code></dt>
   * <dd>Specifies the lines that will be numbered. The first line is
   * always numbered. (builtin default: 5).</dd>
   * <dt><code>linenumbering.width</code></dt>
   * <dd>Specifies the width of the numbers. If the specified width is too
   * narrow for the largest number needed, it will automatically be made
   * wider. (builtin default: 3).</dd>
   * <dt><code>linenumbering.separator</code></dt>
   * <dd>Specifies the string that separates line numbers from lines
   * in the program listing. (builtin default: " ").</dd>
   * <dt><code>stylesheet.result.type</code></dt>
   * <dd>Specifies the stylesheet result type. The value is either 'fo'
   * (for XSL Formatting Objects) or it isn't. (builtin default: html).</dd>
   * </dl>
   *
   * @param context The current stylesheet context
   *
   */
  private static void setupLineNumbering(Context context) {
    // Hardcoded defaults
    modulus = 5;
    width = 3;
    separator = " ";

    String varString = null;

    // Get the modulus
    varString = getVariable(context, "linenumbering.everyNth");
    try {
      modulus = Integer.parseInt(varString);
    } catch (NumberFormatException nfe) {
      System.out.println("$linenumbering.everyNth is not a number: " + varString);
    }

    // Get the width
    varString = getVariable(context, "linenumbering.width");
    try {
      width = Integer.parseInt(varString);
    } catch (NumberFormatException nfe) {
      System.out.println("$linenumbering.width is not a number: " + varString);
    }

    // Get the separator
    varString = getVariable(context, "linenumbering.separator");
    separator = varString;
  }

  /**
   * <p>Number lines in a verbatim environment.</p>
   *
   * <p>This method adds line numbers to a result tree fragment. Each
   * newline that occurs in a text node is assumed to start a new line.
   * The first line is always numbered, every subsequent saxonMod line
   * is numbered (so if saxonMod=5, lines 1, 5, 10, 15, etc. will be
   * numbered. If there are fewer than saxonMod lines in the environment,
   * every line is numbered.</p>
   *
   * <p>Every line number will be right justified in a string saxonWidth
   * characters long. If the line number of the last line in the
   * environment is too long to fit in the specified width, the width
   * is automatically increased to the smallest value that can hold the
   * number of the last line. (In other words, if you specify the value 2
   * and attempt to enumerate the lines of an environment that is 100 lines
   * long, the value 3 will automatically be used for every line in the
   * environment.)</p>
   *
   * <p>The saxonSep string is inserted between the line
   * number and the original program listing. Lines that aren't numbered
   * are preceded by a saxonWidth blank string and the separator.</p>
   *
   * <p>If inline markup extends across line breaks, markup changes are
   * required. All the open elements are closed before the line break and
   * "reopened" afterwards. The reopened elements will have the same
   * attributes as the originals, except that 'name' and 'id' attributes
   * are not duplicated.</p>
   *
   * @param saxonRTF The result tree fragment of the verbatim environment.
   *
   * @return The modified result tree fragment.
   */
  public static FragmentValue numberLines (Context context,
					   FragmentValue saxonRTF) {

    setupLineNumbering(context);

    try {
      int numLines = countLineBreaks(saxonRTF.getFirst()) + 1;

      elementStack = new Stack();
      lineNumber = 0;

      double log10numLines = Math.log(numLines) / Math.log(10);

      if (width < log10numLines + 1) {
	width = (int) Math.floor(log10numLines + 1);
      }

      FragmentValue rtf = new FragmentValue();
      lineNumberFragment(rtf, saxonRTF.getFirst());
      return rtf;
    } catch (SAXException e) {
      // This "can't" happen.
      System.out.println("SAX Exception in numberLines");
      return saxonRTF;
    }
  }

  /**
   * <p>Count the number of lines in a verbatim environment.</p>
   *
   * <p>This method walks over the nodes of a FragmentValue and
   * returns the number of lines breaks that it contains.</p>
   *
   * @param node The root of the tree walk over.
   */
  private static int countLineBreaks(NodeInfo node) {
    NodeInfo children[] = null;
    int numLines = 0;

    if (node.getNodeType() == NodeInfo.DOCUMENT) {
      children = ((DocumentInfo) node).getAllChildNodes();
    } else if (node.getNodeType() == NodeInfo.ELEMENT) {
      children = ((ElementInfo) node).getAllChildNodes();
    } else if (node.getNodeType() == NodeInfo.TEXT) {
      String text = node.getValue();

	// Walk through the text node looking for newlines
      char chars[] = new char[text.length()];
      int pos = 0;
      for (int count = 0; count < text.length(); count++) {
	if (text.charAt(count) == '\n') {
	  numLines++;
	}
      }
    } else {
      // nop
    }

    if (children != null) {
      for (int count = 0; count < children.length; count++) {
	numLines += countLineBreaks(children[count]);
      }
    }

    return numLines;
  }

  /**
   * <p>Build a FragmentValue with numbered lines.</p>
   *
   * <p>This is the method that actually does the work of numbering
   * lines in a verbatim environment. It recursively walks through a
   * tree of nodes, copying the structure into the rtf. Text nodes
   * are examined for new lines and modified as requested by the
   * global line numbering parameters.</p>
   *
   * <p>When called, rtf should be an empty FragmentValue and node
   * should be the first child of the result tree fragment that contains
   * the existing, formatted verbatim text.</p>
   *
   * @param rtf The resulting verbatim environment with numbered lines.
   * @param node The root of the tree to copy.
   */
  private static void lineNumberFragment(FragmentValue rtf,
					 NodeInfo node) {
    NodeInfo children[] = null;
    boolean skipStack = false;

    try {
      if (node.getNodeType() == NodeInfo.DOCUMENT) {
	rtf.startDocument();
	children = ((DocumentInfo) node).getAllChildNodes();
      } else if (node.getNodeType() == NodeInfo.ELEMENT) {
	rtf.startElement(node.getExpandedName(),
			 ((ElementInfo) node).getAttributeList());

	if (elementStack.empty()) {
	  Name foBlock = new Name("fo",
				  "http://www.w3.org/1999/XSL/Format",
				  "block");
	  if (foBlock.equals(node.getExpandedName())
	      || node.getNodeName().equalsIgnoreCase("pre")
	      || node.getNodeName().equalsIgnoreCase("div")) {
	    // Don't push the outer-most wrapping div, pre, or fo:block
	    skipStack = true;
	  }
	}

	if (!skipStack) {
	  elementStack.push(node);
	}

	children = ((ElementInfo) node).getAllChildNodes();
      } else if (node.getNodeType() == NodeInfo.TEXT) {
	String text = node.getValue();

	if (lineNumber == 0) {
	  // The first line is always numbered
	  formatLineNumber(rtf, ++lineNumber);
	}

	// Walk through the text node looking for newlines
	char chars[] = new char[text.length()];
	int pos = 0;
	for (int count = 0; count < text.length(); count++) {
	  if (text.charAt(count) == '\n') {
	    // This is the tricky bit; if we find a newline, make sure
	    // it doesn't occur inside any markup.

	    if (pos > 0) {
	      rtf.characters(chars, 0, pos);
	      pos = 0;
	    }

	    // Close all the open elements...
	    closeOpenElements(rtf);

	    // Copy the newline to the output
	    chars[pos++] = text.charAt(count);
	    rtf.characters(chars, 0, pos);
	    pos = 0;

	    // Add the line number
	    formatLineNumber(rtf, ++lineNumber);

	    // Now "reopen" the elements that we closed...
	    openClosedElements(rtf);
	  } else {
	    chars[pos++] = text.charAt(count);
	  }
	}

	if (pos > 0) {
	  rtf.characters(chars, 0, pos);
	}
      } else if (node.getNodeType() == NodeInfo.COMMENT) {
	String text = node.getValue();

	char chars[] = new char[text.length()];
	for (int count = 0; count < text.length(); count++) {
	  chars[count] = text.charAt(count);
	}
	rtf.comment(chars, 0, text.length());
      } else if (node.getNodeType() == NodeInfo.PI) {
	rtf.processingInstruction(node.getNodeName(), node.getValue());
      } else {
	System.out.println("Warning: unexpected node type in lineNumberFragment");
      }

      if (children != null) {
	for (int count = 0; count < children.length; count++) {
	  lineNumberFragment(rtf, children[count]);
	}
      }

      if (node.getNodeType() == NodeInfo.DOCUMENT) {
	rtf.endDocument();
      } else if (node.getNodeType() == NodeInfo.ELEMENT) {
	rtf.endElement(node.getExpandedName());
	if (!skipStack) {
	  elementStack.pop();
	}
      } else {
	// nop
      }
    } catch (SAXException e) {
      System.out.println("SAX Exception in lineNumberFragment");
    }
  }

  /**
   * <p>Add a formatted line number to the result tree fragment.</p>
   *
   * <p>This method examines the global parameters that control line
   * number presentation (modulus, width, and separator) and adds
   * the appropriate text to the result tree fragment.</p>
   *
   * @param rtf The resulting verbatim environment with numbered lines.
   * @param lineNumber The number of the current line.
   */
  private static void formatLineNumber(FragmentValue rtf,
				       int lineNumber) {
    char ch = 160;
    String lno = "";
    if (lineNumber == 1
	|| (modulus >= 1 && (lineNumber % modulus == 0))) {
      lno = "" + lineNumber;
    }

    while (lno.length() < width) {
      lno = ch + lno;
    }

    lno += separator;

    char chars[] = new char[lno.length()];
    for (int count = 0; count < lno.length(); count++) {
      chars[count] = lno.charAt(count);
    }

    try {
      rtf.characters(chars, 0, lno.length());
    } catch (SAXException e) {
      System.out.println("SAX Exception in formatLineNumber");
    }
  }

  /**
   * <p>Setup the parameters associated with callouts</p>
   *
   * <p>This method queries the stylesheet for the variables
   * associated with line numbering. It is called automatically before
   * callouts are processed. The context is used to retrieve the values,
   * this allows templates to redefine these variables.</p>
   *
   * <p>The following variables are queried. If the variables do not
   * exist, builtin defaults will be used (but you may also get a bunch
   * of messages from the Java interpreter).</p>
   *
   * <dl>
   * <dt><code>callout.graphics</code></dt>
   * <dd>Are we using callout graphics? A value of 0 or "" is false,
   * any other value is true. If callout graphics are not used, the
   * parameters related to graphis are not queried.</dd>
   * <dt><code>callout.graphics.path</code></dt>
   * <dd>Specifies the path to callout graphics.</dd>
   * <dt><code>callout.graphics.extension</code></dt>
   * <dd>Specifies the extension ot use for callout graphics.</dd>
   * <dt><code>callout.graphics.number.limit</code></dt>
   * <dd>Identifies the largest number that can be represented as a
   * graphic. Larger callout numbers will be represented using text.</dd>
   * <dt><code>callout.defaultcolumn</code></dt>
   * <dd>Specifies the default column for callout bullets that do not
   * specify a column.</dd>
   * <dt><code>stylesheet.result.type</code></dt>
   * <dd>Specifies the stylesheet result type. The value is either 'fo'
   * (for XSL Formatting Objects) or it isn't. (builtin default: html).</dd>
   * </dl>
   *
   * @param context The current stylesheet context
   *
   */
  private static void setupCallouts(Context context) {
    boolean useGraphics = false;
    boolean useUnicode = false;

    int unicodeStart = 48;
    int unicodeMax = 0;

    // Hardcoded defaults
    defaultColumn = 60;
    String graphicsPath = null;
    String graphicsExt = null;
    int graphicsMax = 0;
    boolean foStylesheet = false;

    Value variable = null;
    String varString = null;

    // Get the stylesheet type
    varString = getVariable(context, "stylesheet.result.type");
    foStylesheet = (varString.equals("fo"));

    // Get the default column
    varString = getVariable(context, "callout.defaultcolumn");
    try {
      defaultColumn = Integer.parseInt(varString);
    } catch (NumberFormatException nfe) {
      System.out.println("$callout.defaultcolumn is not a number: "
			 + varString);
    }

    // Use graphics at all?
    varString = getVariable(context, "callout.graphics");
    useGraphics = !(varString.equals("0") || varString.equals(""));

      // Use unicode at all?
    varString = getVariable(context, "callout.unicode");
    useUnicode = !(varString.equals("0") || varString.equals(""));

    if (useGraphics) {
      // Get the graphics path
      varString = getVariable(context, "callout.graphics.path");
      graphicsPath = varString;

      // Get the graphics extension
      varString = getVariable(context, "callout.graphics.extension");
      graphicsExt = varString;

      // Get the number limit
      varString = getVariable(context, "callout.graphics.number.limit");
      try {
	graphicsMax = Integer.parseInt(varString);
      } catch (NumberFormatException nfe) {
	System.out.println("$callout.graphics.number.limit is not a number: "
			   + varString);
	graphicsMax = 0;
      }

      fCallout = new FormatGraphicCallout(graphicsPath,
					  graphicsExt,
					  graphicsMax,
					  foStylesheet);
    } else if (useUnicode) {
      // Get the starting character
      varString = getVariable(context, "callout.unicode.start.character");
      try {
	unicodeStart = Integer.parseInt(varString);
      } catch (NumberFormatException nfe) {
	System.out.println("$callout.unicode.start.character is not a number: "
			   + varString);
	unicodeStart = 48;
      }

      // Get the number limit
      varString = getVariable(context, "callout.unicode.number.limit");
      try {
	unicodeMax = Integer.parseInt(varString);
      } catch (NumberFormatException nfe) {
	System.out.println("$callout.unicode.number.limit is not a number: "
			   + varString);
	unicodeStart = 0;
      }

      fCallout = new FormatUnicodeCallout(unicodeStart,
					  unicodeMax,
					  foStylesheet);
    } else {
      fCallout = new FormatTextCallout(foStylesheet);
    }
  }

  /**
   * <p>Insert callouts into a verbatim environment.</p>
   *
   * <p>This method examines the <tt>areaset</tt> and <tt>area</tt> elements
   * in the supplied <tt>areaspec</tt> and decorates the supplied
   * result tree fragment with appropriate callout markers.</p>
   *
   * <p>If a <tt>label</tt> attribute is supplied on an <tt>area</tt>,
   * its content will be used for the label, otherwise the callout
   * number will be used. Callouts are
   * numbered in document order. All of the <tt>area</tt>s in an
   * <tt>areaset</tt> get the same number.</p>
   *
   * <p>If the callout number is not greater than <tt>gMax</tt>, the
   * callout generated will be:</p>
   *
   * <pre>
   * &lt;img src="$gPath/conumber$gExt" alt="conumber">
   * </pre>
   *
   * <p>Otherwise, it will be the callout number surrounded by
   * parenthesis.</p>
   *
   * <p>Only the <tt>linecolumn</tt> and <tt>linerange</tt> units are
   * supported. If no unit is specifed, <tt>linecolumn</tt> is assumed.
   * If only a line is specified, the callout decoration appears in
   * the defaultColumn. Lines will be padded with blanks to reach the
   * necessary column, but callouts that are located beyond the last
   * line of the verbatim environment will be ignored.</p>
   *
   * <p>Callouts are inserted before the character at the line/column
   * where they are to occur.</p>
   *
   * @param areaspecNodeSet The source node set that contains the areaspec.
   * @param saxonRTF The result tree fragment of the verbatim environment.
   * @param defaultColumn The column for callouts that specify only a line.
   * @param gPath The path to use for callout graphics.
   * @param gExt The extension to use for callout graphics.
   * @param gMax The largest number that can be represented as a graphic.
   * @param useFO Should fo:external-graphics be produced, as opposed to
   * HTML imgs. This is bogus, the extension should figure it out, but I
   * haven't figured out how to do that yet.
   *
   * @return The modified result tree fragment.
   */
  public static FragmentValue insertCallouts (Context context,
					      NodeSetIntent areaspecNodeSet,
					      FragmentValue saxonRTF) {

    setupCallouts(context);

    elementStack = new Stack();
    callout = new Callout[10];
    calloutCount = 0;
    calloutPos = 0;
    lineNumber = 1;
    colNumber = 1;

    // First we walk through the areaspec to calculate the position
    // of the callouts
    //  <areaspec>
    //  <areaset id="ex.plco.const" coords="">
    //    <area id="ex.plco.c1" coords="4"/>
    //    <area id="ex.plco.c2" coords="8"/>
    //  </areaset>
    //  <area id="ex.plco.ret" coords="12"/>
    //  <area id="ex.plco.dest" coords="12"/>
    //  </areaspec>
    try {
      int pos = 0;
      int coNum = 0;
      boolean inAreaSet = false;
      NodeInfo areaspec = areaspecNodeSet.getFirst();
      NodeInfo children[] = areaspec.getAllChildNodes();

      for (int count = 0; count < children.length; count++) {
	NodeInfo node = children[count];
	if (node.getNodeType() == NodeInfo.ELEMENT) {
	  if (node.getNodeName().equalsIgnoreCase("areaset")) {
	    coNum++;
	    NodeInfo areas[] = node.getAllChildNodes();
	    for (int acount = 0; acount < areas.length; acount++) {
	      NodeInfo area = areas[acount];
	      if (area.getNodeType() == NodeInfo.ELEMENT) {
		if (area.getNodeName().equalsIgnoreCase("area")) {
		  addCallout(coNum, area, defaultColumn);
		} else {
		  System.out.println("Unexpected element in areaset: "
				     + area.getNodeName());
		}
	      }
	    }
	  } else if (node.getNodeName().equalsIgnoreCase("area")) {
	    coNum++;
	    addCallout(coNum, node, defaultColumn);
	  } else {
	    System.out.println("Unexpected element in areaspec: "
			       + node.getNodeName());
	  }
	}
      }

      // Now sort them
      java.util.Arrays.sort(callout, 0, calloutCount);

      FragmentValue rtf = new FragmentValue();
      calloutFragment(rtf, saxonRTF.getFirst());
      return rtf;
    } catch (SAXException e) {
      return saxonRTF;
    }
  }

  /**
   * <p>Build a FragmentValue with callout decorations.</p>
   *
   * <p>This is the method that actually does the work of adding
   * callouts to a verbatim environment. It recursively walks through a
   * tree of nodes, copying the structure into the rtf. Text nodes
   * are examined for the position of callouts as described by the
   * global callout parameters.</p>
   *
   * <p>When called, rtf should be an empty FragmentValue and node
   * should be the first child of the result tree fragment that contains
   * the existing, formatted verbatim text.</p>
   *
   * @param rtf The resulting verbatim environment with numbered lines.
   * @param node The root of the tree to copy.
   */
  private static void calloutFragment(FragmentValue rtf,
				      NodeInfo node) {
    NodeInfo children[] = null;

    try {
      if (node.getNodeType() == NodeInfo.DOCUMENT) {
	rtf.startDocument();
	children = ((DocumentInfo) node).getAllChildNodes();
      } else if (node.getNodeType() == NodeInfo.ELEMENT) {
	rtf.startElement(node.getExpandedName(),
			 ((ElementInfo) node).getAttributeList());
	children = ((ElementInfo) node).getAllChildNodes();
	elementStack.push(node);
      } else if (node.getNodeType() == NodeInfo.TEXT) {
	String text = node.getValue();

	char chars[] = new char[text.length()];
	int pos = 0;
	for (int count = 0; count < text.length(); count++) {
	  if (calloutPos < calloutCount
	      && callout[calloutPos].getLine() == lineNumber
	      && callout[calloutPos].getColumn() == colNumber) {
	    if (pos > 0) {
	      rtf.characters(chars, 0, pos);
	      pos = 0;
	    }

	    closeOpenElements(rtf);

	    while (calloutPos < calloutCount
		   && callout[calloutPos].getLine() == lineNumber
		   && callout[calloutPos].getColumn() == colNumber) {
	      fCallout.formatCallout(rtf, callout[calloutPos]);
	      calloutPos++;
	    }

	    openClosedElements(rtf);
	  }

	  if (text.charAt(count) == '\n') {
	    // What if we need to pad this line?
	    if (calloutPos < calloutCount
		&& callout[calloutPos].getLine() == lineNumber
		&& callout[calloutPos].getColumn() > colNumber) {

	      if (pos > 0) {
		rtf.characters(chars, 0, pos);
		pos = 0;
	      }

	      closeOpenElements(rtf);

	      while (calloutPos < calloutCount
		     && callout[calloutPos].getLine() == lineNumber
		     && callout[calloutPos].getColumn() > colNumber) {
		formatPad(rtf, callout[calloutPos].getColumn() - colNumber);
		colNumber = callout[calloutPos].getColumn();
		while (calloutPos < calloutCount
		       && callout[calloutPos].getLine() == lineNumber
		       && callout[calloutPos].getColumn() == colNumber) {
		  fCallout.formatCallout(rtf, callout[calloutPos]);
		  calloutPos++;
		}
	      }

	      openClosedElements(rtf);
	    }

	    lineNumber++;
	    colNumber = 1;
	  } else {
	    colNumber++;
	  }
	  chars[pos++] = text.charAt(count);
	}

	if (pos > 0) {
	  rtf.characters(chars, 0, pos);
	}
      } else if (node.getNodeType() == NodeInfo.COMMENT) {
	String text = node.getValue();
	char chars[] = new char[text.length()];
	for (int count = 0; count < text.length(); count++) {
	  chars[count] = text.charAt(count);
	}
	rtf.comment(chars, 0, text.length());
      } else if (node.getNodeType() == NodeInfo.PI) {
	rtf.processingInstruction(node.getNodeName(), node.getValue());
      } else {
	System.out.println("Warning: unexpected node type in calloutFragment");
      }

      if (children != null) {
	for (int count = 0; count < children.length; count++) {
	  calloutFragment(rtf, children[count]);
	}
      }

      if (node.getNodeType() == NodeInfo.DOCUMENT) {
	rtf.endDocument();
      } else if (node.getNodeType() == NodeInfo.ELEMENT) {
	rtf.endElement(node.getExpandedName());
	elementStack.pop();
      } else {
	// nop
      }
    } catch (SAXException e) {
      System.out.println("SAX Exception in calloutFragment");
    }
  }

  /**
   * <p>Add a callout to the global callout array</p>
   *
   * <p>This method examines a callout <tt>area</tt> and adds it to
   * the global callout array if it can be interpreted.</p>
   *
   * <p>Only the <tt>linecolumn</tt> and <tt>linerange</tt> units are
   * supported. If no unit is specifed, <tt>linecolumn</tt> is assumed.
   * If only a line is specified, the callout decoration appears in
   * the <tt>defaultColumn</tt>.</p>
   *
   * @param coNum The callout number.
   * @param node The <tt>area</tt>.
   * @param defaultColumn The default column for callouts.
   */
  private static void addCallout (int coNum,
				  NodeInfo node,
				  int defaultColumn) {
    ElementInfo area = (ElementInfo) node;
    AttributeCollection attr = area.getAttributeList();
    String units  = attr.getValue("units");
    String coords = attr.getValue("coords");

    if (units != null
	&& !units.equalsIgnoreCase("linecolumn")
	&& !units.equalsIgnoreCase("linerange")) {
      System.out.println("Only linecolumn and linerange units are supported");
      return;
    }

    if (coords == null) {
      System.out.println("Coords must be specified");
      return;
    }

    // Now let's see if we can interpret the coordinates...
    StringTokenizer st = new StringTokenizer(coords);
    int tokenCount = 0;
    int c1 = 0;
    int c2 = 0;
    while (st.hasMoreTokens()) {
      tokenCount++;
      if (tokenCount > 2) {
	System.out.println("Unparseable coordinates");
	return;
      }
      try {
	String token = st.nextToken();
	int coord = Integer.parseInt(token);
	c2 = coord;
	if (tokenCount == 1) {
	  c1 = coord;
	}
      } catch (NumberFormatException e) {
	System.out.println("Unparseable coordinate");
	return;
      }
    }

    // Make sure we aren't going to blow past the end of our array
    if (calloutCount == callout.length) {
      Callout bigger[] = new Callout[calloutCount+10];
      for (int count = 0; count < callout.length; count++) {
	bigger[count] = callout[count];
      }
      callout = bigger;
    }

    // Ok, add the callout
    if (tokenCount == 2) {
      if (units != null && units.equalsIgnoreCase("linerange")) {
	for (int count = c1; count <= c2; count++) {
	  callout[calloutCount++] = new Callout(coNum, area,
						count, defaultColumn);
	}
      } else {
	// assume linecolumn
	callout[calloutCount++] = new Callout(coNum, area, c1, c2);
      }
    } else {
      // if there's only one number, assume it's the line
      callout[calloutCount++] = new Callout(coNum, area, c1, defaultColumn);
    }
  }

  /**
   * <p>Add blanks to the result tree fragment.</p>
   *
   * <p>This method adds <tt>numBlanks</tt> to the result tree fragment.
   * It's used to pad lines when callouts occur after the last existing
   * characater in a line.</p>
   *
   * @param rtf The resulting verbatim environment with numbered lines.
   * @param numBlanks The number of blanks to add.
   */
  private static void formatPad(FragmentValue rtf,
				int numBlanks) {
    char chars[] = new char[numBlanks];
    for (int count = 0; count < numBlanks; count++) {
      chars[count] = ' ';
    }

    try {
      rtf.characters(chars, 0, numBlanks);
    } catch (SAXException e) {
      System.out.println("SAX Exception in formatCallout");
    }
  }

  private static void closeOpenElements(FragmentValue rtf)
    throws SAXException {
    String foURI = "http://www.w3.org/1999/XSL/Format";
    String xhURI = "http://www.w3.org/1999/xhtml";

    // Close all the open elements...
    tempStack = new Stack();
    while (!elementStack.empty()) {
      ElementInfo elem = (ElementInfo) elementStack.pop();
      Name exName = elem.getExpandedName();
      String localName = elem.getLocalName();
      String ns = exName.getURI();

      if (ns != null && ns.equals("")) {
	ns = null;
      }

      // If this is the bottom of the stack and it's an fo:block
      // or an HTML pre or div, don't duplicate it...
      if (elementStack.empty()
	  && (((ns != null)
	       && ns.equals(foURI)
	       && localName.equals("block"))
	      || ((ns == null)
		  && localName.equalsIgnoreCase("pre"))
	      || ((ns != null)
		  && ns.equals(xhURI)
		  && localName.equals("pre"))
	      || ((ns == null)
		  && localName.equalsIgnoreCase("div"))
	      || ((ns != null)
		  && ns.equals(xhURI)
		  && localName.equals("div")))) {
	elementStack.push(elem);
	break;
      } else {
	rtf.endElement(exName);
	tempStack.push(elem);
      }
    }
  }

  private static void openClosedElements(FragmentValue rtf)
    throws SAXException {
    // Now "reopen" the elements that we closed...
    while (!tempStack.empty()) {
      ElementInfo elem = (ElementInfo) tempStack.pop();
      AttributeCollection elemAttr = elem.getAttributeList();
      AttributeCollection newAttr = new AttributeCollection();
      for (int acount = 0; acount < elemAttr.getLength(); acount++) {
	String name = elemAttr.getName(acount);

	if (name.equalsIgnoreCase("name")
	    || name.equalsIgnoreCase("id")) {
	  // skip 'name' and 'id' attributes
	} else {
	  newAttr.addAttribute(elemAttr.getExpandedName(acount),
			       elemAttr.getType(acount),
			       elemAttr.getValue(acount));
	}
      }

      rtf.startElement(elem.getExpandedName(), newAttr);
      elementStack.push(elem);
    }
  }
}
