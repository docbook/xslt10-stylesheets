package cz.zcu.fav.kiv.editor.config;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.io.StringReader;

import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import cz.zcu.fav.kiv.editor.config.constants.FileConst;
import cz.zcu.fav.kiv.editor.controller.logger.Log;

public class ParameterTransformation {
    /**
     * Transform text description in DocBook to HTML format.
     * 
     * @param input
     *            the text in DocBook.
     * @return the input text transformed to HTML.
     */
    public static String htmlTransform(String input) {
        try {
            InputStream convertFile = ConfigParser.class
                    .getResourceAsStream(FileConst.CONF_FILE_CONVERT);

            TransformerFactory trf = TransformerFactory.newInstance();
            Transformer transformer = trf.newTransformer(new StreamSource(convertFile));

            ByteArrayOutputStream out = new ByteArrayOutputStream();

            String tempStr = new String(input.getBytes(), "windows-1250");
            transformer.transform(new StreamSource(new StringReader(tempStr)),
                    new StreamResult(out));

            return out.toString();
        } catch (Throwable ex) {
            Log.warn("error.param_parser.transformation_error", ex);
        }
        return null;
    }
}
