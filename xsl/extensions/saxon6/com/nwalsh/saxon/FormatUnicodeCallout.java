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

public class FormatUnicodeCallout extends FormatCallout {
  int unicodeMax = 0;
  int unicodeStart = 0;

  public FormatUnicodeCallout(NamePool nPool, int start, int max, boolean fo) {
    super(nPool, fo);
    unicodeMax = max;
    unicodeStart = start;
  }

  public void formatCallout(Emitter rtfEmitter,
			    Callout callout) {
    ElementInfo area = callout.getArea();
    int num = callout.getCallout();
    String label = areaLabel(area);

    try {
      if (label == null && num <= unicodeMax) {
	char chars[] = new char[1];
	chars[0] = (char) (unicodeStart + num - 1);

	startSpan(rtfEmitter);
	rtfEmitter.characters(chars, 0, 1);
	endSpan(rtfEmitter);
      } else {
	formatTextCallout(rtfEmitter, callout);
      }
    } catch (SAXException e) {
      System.out.println("SAX Exception in graphic formatCallout");
    }
  }
}
