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

public abstract class FormatCallout {
  protected static final String foURI = "http://www.w3.org/1999/XSL/Format";
  protected static final String xhURI = "http://www.w3.org/1999/xhtml";
  protected boolean foStylesheet = false;

  public FormatCallout(boolean fo) {
    foStylesheet = fo;
  }

  public String areaLabel(ElementInfo area) {
    String label = null;

    if (area.getAttributeList().getValue("label") != null) {
      // If this area has a label, use it
      label = area.getAttributeList().getValue("label");
    } else {
      // Otherwise, if its parent is an areaset and it has a label, use that
      ElementInfo parent = (ElementInfo) area.getParentNode();
      if (parent != null
	  && parent.getLocalName().equalsIgnoreCase("areaset")
	  && parent.getAttributeList().getValue("label") != null) {
	label = parent.getAttributeList().getValue("label");
      }
    }

    return label;
  }

  public void startSpan(Emitter rtf)
    throws SAXException {
    // no point in doing this for FO, right?
    if (!foStylesheet) {
      Name spanName = new Name("span");
      AttributeCollection spanAttr = new AttributeCollection();
      spanAttr.addAttribute(new Name("class"), "CDATA", "co");
      rtf.startElement(spanName, spanAttr);
    }
  }

  public void endSpan(Emitter rtf)
    throws SAXException {
    // no point in doing this for FO, right?
    if (!foStylesheet) {
      Name spanName = new Name("span");
      rtf.endElement(spanName);
    }
  }

  public void formatTextCallout(Emitter rtfEmitter,
				Callout callout) {
    ElementInfo area = callout.getArea();
    int num = callout.getCallout();
    String userLabel = areaLabel(area);
    String label = "(" + num + ")";

    if (userLabel != null) {
      label = userLabel;
    }

    char chars[] = label.toCharArray();

    try {
      startSpan(rtfEmitter);
      rtfEmitter.characters(chars, 0, label.length());
      endSpan(rtfEmitter);
    } catch (SAXException e) {
      System.out.println("SAX Exception in formatTextCallout");
    }
  }

  public abstract void formatCallout(Emitter rtfEmitter,
				     Callout callout);
}

