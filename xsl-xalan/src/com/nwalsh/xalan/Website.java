// Website.java - Xalan extensions supporting Website2

package com.nwalsh.xalan;

import java.io.File;
import java.lang.Boolean;
import java.lang.NullPointerException;

import org.apache.xalan.extensions.ExpressionContext;

public class Website {
  public Website() {
  }

  public static Boolean exists(ExpressionContext context, String filename) {
    try {
      File file = new File(filename);
      return new Boolean(file.exists());
    } catch (NullPointerException npe) {
      return new Boolean(false);
    }
  }

  public static Boolean needsUpdate(ExpressionContext context,
				    String srcFilename,
				    String targetFilename) {
    File srcFile;
    File targetFile;

    try {
      targetFile = new File(targetFilename);
    } catch (NullPointerException npe) {
      return new Boolean(false);
    }

    try {
      srcFile = new File(srcFilename);
    } catch (NullPointerException npe) {
      return new Boolean(false);
    }

    if (!srcFile.exists()) {
      return new Boolean(false);
    }

    if (!targetFile.exists()) {
      return new Boolean(true);
    }

    return new Boolean(srcFile.lastModified() > targetFile.lastModified());
  }
}
