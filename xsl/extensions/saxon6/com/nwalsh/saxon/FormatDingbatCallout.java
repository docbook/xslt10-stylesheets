package com.nwalsh.saxon;

import org.xml.sax.SAXException;
import org.w3c.dom.*;

import com.icl.saxon.om.ElementInfo;
import com.icl.saxon.om.NamePool;
import com.icl.saxon.output.Emitter;
import com.icl.saxon.tree.AttributeCollection;

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

  public FormatDingbatCallout(NamePool nPool, int max, boolean fo) {
    super(nPool, fo);
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
	int inName = 0;
	AttributeCollection inAttr = null;
	int namespaces[] = new int[1];

	if (foStylesheet) {
	  inName = namePool.allocate("fo", foURI, "inline");
	  inAttr = new AttributeCollection(namePool);
	  inAttr.addAttribute("", "", "font-family", "CDATA", "ZapfDingbats");
	} else {
	  inName = namePool.allocate("", "", "font");
	  inAttr = new AttributeCollection(namePool);
	  inAttr.addAttribute("", "", "face", "CDATA", "ZapfDingbats");
	}

	startSpan(rtfEmitter);
	rtfEmitter.startElement(inName, inAttr, namespaces, 0);

	char chars[] = new char[1];
	chars[0] = (char) (0x2775 + num);
	rtfEmitter.characters(chars, 0, 1);

	rtfEmitter.endElement(inName);
	endSpan(rtfEmitter);
      } else {
	formatTextCallout(rtfEmitter, callout);
      }
    } catch (SAXException e) {
      System.out.println("SAX Exception in graphic formatCallout");
    }
  }
}
