// Text - Saxon extension element for inserting text

package com.nwalsh.saxon;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.InputStream;
import java.io.IOException;
import java.io.FileNotFoundException;
import java.net.URL;
import java.net.MalformedURLException;
import com.icl.saxon.*;
import com.icl.saxon.style.*;
import com.icl.saxon.expr.*;
import com.icl.saxon.output.*;
import org.xml.sax.SAXException;
import org.xml.sax.AttributeList;

/**
 * <p>Saxon extension element for inserting text
 *
 * <p>$Id$</p>
 *
 * <p>Copyright (C) 2000 Norman Walsh.</p>
 *
 * <p>This class provides a
 * <a href="http://users.iclway.co.uk/mhkay/saxon/">Saxon</a>
 * extension element for inserting text into a result tree.</p>
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
public class Text extends StyleElement {
  /**
   * <p>Constructor for Text</p>
   *
   * <p>Does nothing.</p>
   */
  public Text() {
  }

  /**
   * <p>Validate the arguments</p>
   *
   * <p>The element must have an href attribute.</p>
   */
  public void prepareAttributes() throws SAXException {
    // Get mandatory database attribute
    try {
      String fnAtt = attributeList.getValue("href");
      if (fnAtt == null) {
	reportAbsence("href");
      }
    } catch (NoSuchFieldError e) {
      // nop, must be Saxon6 parsing this extension element
    }
  }

  /** Validate that the element occurs in a reasonable place. */
  public void validate() throws SAXException {
    checkWithinTemplate();
  }

  /**
   * <p>Insert the text of the file into the result tree</p>
   *
   * <p>Processing this element inserts the contents of the URL named
   * by the href attribute into the result tree as plain text.</p>
   *
   */
  public void process( Context context ) throws SAXException {
    Outputter out = context.getOutputter();

    String hrefAtt = attributeList.getValue("href");
    Expression hrefExpr = AttributeValueTemplate.make(hrefAtt, this);
    String href = hrefExpr.evaluateAsString(context);
    URL fileURL = null;

    try {
      try {
	fileURL = new URL(href);
      } catch (MalformedURLException e1) {
	try {
	  fileURL = new URL("file:" + href);
	} catch (MalformedURLException e2) {
	  System.out.println("Cannot open " + href);
	  return;
	}
      }

      InputStreamReader isr = new InputStreamReader(fileURL.openStream());
      BufferedReader is = new BufferedReader(isr);

      char chars[] = new char[4096];
      int len = 0;
      while ((len = is.read(chars)) > 0) {
	out.writeContent(chars, 0, len);
      }
      is.close();
    } catch (Exception e) {
      System.out.println("Cannot read " + href);
    }
  }
}
