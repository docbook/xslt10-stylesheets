package com.nwalsh.saxon;

import org.xml.sax.SAXException;
import org.w3c.dom.*;

import com.icl.saxon.om.ElementInfo;
import com.icl.saxon.om.Name;
import com.icl.saxon.output.Emitter;
import com.icl.saxon.AttributeCollection;

import com.nwalsh.saxon.Callout;

/**
 * <p>Utility class for the Verbatim extension (ignore this).</p>
 *
 * <p>$Id$</p>
 *
 * <p>Copyright (C) 2000, 2001 Norman Walsh.</p>
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
 **/

public class FormatDingbatCallout extends FormatCallout {
  int graphicsMax = 0;

  public FormatDingbatCallout(int max, boolean fo) {
    super(fo);
    graphicsMax = max;
  }

  public void formatCallout(Emitter rtfEmitter,
			    Callout callout) {
    ElementInfo area = callout.getArea();
    int num = callout.getCallout();
    String userLabel = areaLabel(area);
    String label = "";

    if (userLabel != null) {
      label = userLabel;
    }

    try {
      if (userLabel == null && num <= graphicsMax) {
	Name imgName = null;
	AttributeCollection imgAttr = null;

	if (foStylesheet) {
	  imgName = new Name("fo",
			     "http://www.w3.org/1999/XSL/Format",
			     "inline");
	  imgAttr = new AttributeCollection();
	  imgAttr.addAttribute(new Name("font-family"), "CDATA",
			       "ZapfDingbats");
	} else {
	  imgName = new Name("font");
	  imgAttr = new AttributeCollection();
	  imgAttr.addAttribute(new Name("face"), "CDATA",
			       "ZapfDingbats");
	}

	startSpan(rtfEmitter);
	rtfEmitter.startElement(imgName, imgAttr);

	char chars[] = new char[1];
	chars[0] = (char) (0x2775 + num);
	rtfEmitter.characters(chars, 0, 1);

	rtfEmitter.endElement(imgName);
	endSpan(rtfEmitter);
      } else {
	formatTextCallout(rtfEmitter, callout);
      }
    } catch (SAXException e) {
      System.out.println("SAX Exception in graphic formatCallout");
    }
  }
}
