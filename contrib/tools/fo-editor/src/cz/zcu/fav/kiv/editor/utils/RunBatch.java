package cz.zcu.fav.kiv.editor.utils;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

import cz.zcu.fav.kiv.editor.controller.MessageWriter;
import cz.zcu.fav.kiv.editor.controller.logger.Log;

/**
 * The <code>StreamWriter</code> class is used for reporting messages and errors generated during
 * lauch of the batch file.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
class StreamWriter extends Thread {
    /** The constant defining error message */
    public static final String ERROR = "error";

    /** The constant defining output message */
    public static final String OUTPUT = "output";

    /** The input message stream */
    private InputStream inputStream;

    /** The type of output message */
    private String type;

    /**
     * Initializes a newly created <code>StreamWriter</code> with defined <code>InputStream</code>
     * and message type.
     * 
     * @param is
     *            the input stream.
     * @param type
     *            the type of message.
     */
    public StreamWriter(InputStream is, String type) {
        this.inputStream = is;
        this.type = type;
    }

    /**
     * Launches the message writer.
     */
    public void run() {
        try {
            InputStreamReader input = new InputStreamReader(inputStream);
            BufferedReader reader = new BufferedReader(input);
            String line = null;
            while ((line = reader.readLine()) != null) {
                if (type.equals(ERROR))
                    MessageWriter.writeEmphasis(line);
                else
                    MessageWriter.write(line);
            }
        } catch (IOException ioe) {
            Log.error(ioe);
        }
    }
}

/**
 * The <code>RunBatch</code> class launches a batch file defined by user.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class RunBatch {
    /** The constant defining file separator */
    private static final String FILE_SEPARATOR = "\\" + File.separator;

    /** The in the batch file that determine place where the actual XSL stylesheet is placed */
    private static final String XSL = "\\[XSL\\]";

    /** The constant defining quote */
    private static final String QUOTE = "\"";

    /** The name of the auxiliary batch file */
    public static final String RUN_BAT = "transformation.bat";

    /**
     * Executes the batch file.
     * 
     * @throws Throwable
     *             if the batch file cannot be executed.
     */
    public static void execBatch() throws Throwable {
        String osName = System.getProperty("os.name");
        String[] cmd = new String[3];
        if (osName.startsWith("Windows")) {
            cmd[0] = "cmd.exe";
            cmd[1] = "/C";
            cmd[2] = RUN_BAT;
        }

        Runtime rt = Runtime.getRuntime();
        Process proc = rt.exec(cmd);
        // any error message?
        StreamWriter errorGobbler = new StreamWriter(proc.getErrorStream(), StreamWriter.ERROR);

        // any output?
        StreamWriter outputGobbler = new StreamWriter(proc.getInputStream(), StreamWriter.OUTPUT);

        // kick them off
        errorGobbler.start();
        outputGobbler.start();
    }

    /**
     * Replace the mark [XSL] in the batch file by the actual opened XSL stylesheet file.
     * 
     * @param batchName
     *            the name of the batch file.
     * @param xslName
     *            the name of the actually opened XSL stylesheet file.
     * @throws Throwable
     *             if the batch file is invalid.
     */
    public static void replaceXslName(String batchName, String xslName) throws Throwable {
        FileReader fileRead = new FileReader(batchName);
        BufferedReader in = new BufferedReader(fileRead);
        FileWriter fw = new FileWriter(RUN_BAT);
        BufferedWriter out = new BufferedWriter(fw);

        String line;
        while ((line = in.readLine()) != null) {
            line = line.replaceAll(XSL, QUOTE
                    + xslName.replaceAll(FILE_SEPARATOR, FILE_SEPARATOR + FILE_SEPARATOR) + QUOTE);

            out.write(line);
            out.newLine();
        }
        fileRead.close();
        out.close();
    }
}
