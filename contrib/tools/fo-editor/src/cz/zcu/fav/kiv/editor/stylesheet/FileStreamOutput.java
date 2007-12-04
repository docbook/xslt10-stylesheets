package cz.zcu.fav.kiv.editor.stylesheet;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;

import cz.zcu.fav.kiv.editor.controller.options.OptionItems;

/**
 * The <code>FileStreamOutput</code> class is used for changing chars of ends of line (CR+LF, CR,
 * LF) in the output XSL stylesheet file stream.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class FileStreamOutput extends OutputStream {
    /** The output XSL file stream */
    private final FileOutputStream file;

    /** The char defining CR (carriage return) */
    private static final int CR = 13;

    /** The char defining CR (line feed) */
    private static final int LF = 10;

    /**
     * Initializes a newly created <code>FileStreamOutput</code> with defined file output stream.
     * 
     * @param outputStream
     *            the output file stream.
     */
    public FileStreamOutput(final FileOutputStream outputStream) {
        super();
        this.file = outputStream;
    }

    @Override
    public void write(int b) throws IOException {
        file.write(b);
    }

    @Override
    public void close() throws IOException {
        file.close();
        super.close();
    }

    @Override
    public void flush() throws IOException {
        file.flush();
    }

    @Override
    public void write(byte[] b, int off, int len) throws IOException {
        replaceNewline(b, off, len);
    }

    @Override
    public void write(byte[] b) throws IOException {
        replaceNewline(b, 0, b.length);
    }

    /**
     * Replaces chars at ends of lines. There are defined 3 types of chars: CR, LF, or CR+LF.
     * 
     * @param byteArrray
     *            the array of byte representing a text.
     * @param begin
     *            the begin of the actually processing part of the byte array.
     * @param length
     *            the length of the actually processing part of the byte array.
     * @throws IOException
     */
    private void replaceNewline(byte[] byteArrray, int begin, int length) throws IOException {
        for (int i = begin; i < length; i++) {
            switch (OptionItems.NEWLINE) {
            case CRLF:
                if ((byteArrray[i] == CR) && (byteArrray[i + 1] != LF)) {
                    file.write(byteArrray[i]);
                    file.write(LF);
                } else if ((byteArrray[i] != CR) && (byteArrray.length > (i + 1))
                        && (byteArrray[i + 1] == LF)) {
                    file.write(byteArrray[i]);
                    file.write(CR);
                } else {
                    file.write(byteArrray[i]);
                }
                break;
            case CR:
                if (byteArrray[i] != LF)
                    file.write(byteArrray[i]);
                break;
            case LF:
                if (byteArrray[i] != CR)
                    file.write(byteArrray[i]);
                break;
            default:
                file.write(byteArrray[i]);
            }
        }
    }
}
