// Func - Xalan extension function test

package com.nwalsh.xalan;

import org.w3c.dom.DocumentFragment;
import org.w3c.dom.Element;
import org.w3c.dom.traversal.NodeIterator;

public class Func {
  public Func() {
  }

  public DocumentFragment doSomething(NodeIterator rtf) {
    System.out.println("Got here 2: " + rtf);

    DocumentFragment df = (DocumentFragment) rtf.nextNode();
    Element node = (Element) df.getFirstChild();

    System.out.println("node=" + node);
    System.out.println("namesp uri: " + node.getNamespaceURI());
    System.out.println("local name: " + node.getLocalName());

    return df;
  }

  public DocumentFragment doSomething(DocumentFragment rtf) {
    System.out.println("Got here: " + rtf);

    return rtf;
    /*
    Element node = (Element) rtf.getFirstChild();

    System.out.println("node=" + node);
    System.out.println("namesp uri: " + node.getNamespaceURI());
    System.out.println("local name: " + node.getLocalName());

    return rtf;
    */
  }
}
