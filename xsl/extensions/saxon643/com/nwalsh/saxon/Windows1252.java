/* This file was kindly provided by Sectra AB, Sweden to DocBook community */
package com.nwalsh.saxon;

import com.icl.saxon.charcode.PluggableCharacterSet;

/**
 *
 * File:      Windows1252CharacterSet.java
 * Created:   May 26 2004
 * Author:    Pontus Haglund
 * Project:   Venus
 *
 *
 * This class extends Saxon 6.5.3 with the windows-1252 character set
 *              
 * 1. Make sure saxon.jar is in your CLASSPATH
 * 2. Compile file javac Windows1252CharacterSet.java  
 * 3. Create a directory structure $(PATH)/com/icl/saxon/charcode
 *    and make sure $(PATH) is in your CLASSPATH
 * 4. Put Windows1252CharacterSet.class into $(PATH)/com/icl/saxon/charcode
 * 5. Add the following 4 lines to your customization layer
 * 
 * <xsl:param name="htmlhelp.encoding">com.icl.saxon.charcode.Windows1252CharacterSet</xsl:param>
 * <xsl:param name="default.encoding">com.icl.saxon.charcode.Windows1252CharacterSet</xsl:param>
 * <xsl:param name="chunker.output.encoding">com.icl.saxon.charcode.Windows1252CharacterSet</xsl:param>
 * <xsl:param name="saxon.character.representation" select="native"></xsl:param>
 *
 */



public class Windows1252 implements PluggableCharacterSet {

    public final boolean inCharset(int c) {

    return  (c >= 0x00 && c <= 0x7F) ||
            (c >= 0xA0 && c <= 0xFF) ||
            (c == 0x20AC) ||
            (c == 0x201A) ||
            (c == 0x0192) ||
            (c == 0x201E) ||
            (c == 0x2026) ||
            (c == 0x2020) ||
            (c == 0x2021) ||
            (c == 0x02C6) ||
            (c == 0x2030) ||
            (c == 0x0160) ||
            (c == 0x2039) ||
            (c == 0x0152) ||
            (c == 0x017D) ||
            (c == 0x2018) ||
            (c == 0x2019) ||
            (c == 0x201C) ||
            (c == 0x201D) ||
            (c == 0x2022) ||
            (c == 0x2013) ||
            (c == 0x2014) ||
            (c == 0x02DC) ||
            (c == 0x2122) ||
            (c == 0x0161) ||
            (c == 0x203A) ||
            (c == 0x0153) ||
            (c == 0x017E) ||
            (c == 0x0178);


    }

    public String getEncodingName() {
        return "WINDOWS-1252";
    }

}
