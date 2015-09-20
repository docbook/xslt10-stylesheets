// Website.java - Saxon extensions supporting Website2

package com.nwalsh.saxon;

import java.io.File;
import java.lang.NullPointerException;

public class Website {
  public Website() {
  }

  public static boolean exists(String filename) {
    try {
      File file = new File(filename);
      return file.exists();
    } catch (NullPointerException npe) {
      return false;
    }
  }

  public static boolean needsUpdate(String srcFilename,
				    String targetFilename) {
    File srcFile;
    File targetFile;

    try {
      targetFile = new File(targetFilename);
    } catch (NullPointerException npe) {
      return false;
    }

    try {
      srcFile = new File(srcFilename);
    } catch (NullPointerException npe) {
      return false;
    }

    if (!srcFile.exists()) {
      return false;
    }

    if (!targetFile.exists()) {
      return true;
    }

    return (srcFile.lastModified() > targetFile.lastModified());
  }
}
