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

public class FormatGraphicCallout extends FormatCallout {
  String graphicsPath = "";
  String graphicsExt = "";
  int graphicsMax = 0;

  public FormatGraphicCallout(String path, String ext, int max, boolean fo) {
    super(fo);
    graphicsPath = path;
    graphicsExt = ext;
    graphicsMax = max;
  }

  public void formatCallout(Emitter rtfEmitter,
			    Callout callout) {
    ElementInfo area = callout.getArea();
    int num = callout.getCallout();
    String userLabel = areaLabel(area);
    String label = "(" + num + ")";

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
			     "external-graphic");
	  imgAttr = new AttributeCollection();
	  imgAttr.addAttribute(new Name("src"), "CDATA",
			       graphicsPath + num + graphicsExt);
	  imgAttr.addAttribute(new Name("alt"), "CDATA", label);
	} else {
	  imgName = new Name("img");
	  imgAttr = new AttributeCollection();
	  imgAttr.addAttribute(new Name("src"), "CDATA",
			       graphicsPath + num + graphicsExt);
	  imgAttr.addAttribute(new Name("alt"), "CDATA", label);
	}

	startSpan(rtfEmitter);
	rtfEmitter.startElement(imgName, imgAttr);
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
