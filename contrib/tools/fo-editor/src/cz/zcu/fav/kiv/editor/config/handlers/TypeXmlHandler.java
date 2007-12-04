package cz.zcu.fav.kiv.editor.config.handlers;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.xml.sax.Attributes;
import org.xml.sax.helpers.DefaultHandler;

import cz.zcu.fav.kiv.editor.config.constants.TagDefinition;
import cz.zcu.fav.kiv.editor.config.constants.TagDefinition.TypeTags;

/**
 * The <code>TypeXmlHandler</code> class is used for parsing the configuration file with types -
 * types.xml.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class TypeXmlHandler extends DefaultHandler {
    /** The list of units */
    private List<String> unitList;

    /** The list of font - key is font name or font itself */
    private Map<String, String> fontList;

    /** The list of font - key is color name or color itself */
    private Map<String, String> colorList;

    /** The key of actually parsed element */
    private String key;

    /** The flag specifying whether the parser is inside unit element */
    private boolean insideUnitElement = false;

    /** The flag specifying whether the parser is inside color element */
    private boolean insideColorElement = false;

    /** The flag specifying whether the parser is inside font element */
    private boolean insideFontElement = false;

    /** The string buffer for content of unit element */
    private StringBuffer unitBuffer = new StringBuffer(TagDefinition.BUFFER_SIZE);

    /** The string buffer for content of color element */
    private StringBuffer colorBuffer = new StringBuffer(TagDefinition.BUFFER_SIZE);

    /** The string buffer for content of font element */
    private StringBuffer fontBuffer = new StringBuffer(TagDefinition.BUFFER_SIZE);

    /**
     * Initializes a newly created empty <code>TypeXmlHandler</code>.
     */
    public TypeXmlHandler() {
        unitList = new ArrayList<String>();
        fontList = new LinkedHashMap<String, String>();
        colorList = new LinkedHashMap<String, String>();
    }

    @Override
    public void startElement(String namespaceURI, String localName, String qName, Attributes atts) {
        TypeTags enumTag = TagDefinition.TypeTags.getValue(qName);
        switch (enumTag) {
            case COLOR:
                insideColorElement = true;
                colorBuffer.setLength(0);
                key = atts.getValue(0);
            break;
            case UNIT:
                insideUnitElement = true;
                unitBuffer.setLength(0);
            break;
            case FONT:
                insideFontElement = true;
                fontBuffer.setLength(0);
            break;
        }
    }

    @Override
    public void endElement(String namespaceURI, String localName, String qName) {
        TypeTags enumTag = TagDefinition.TypeTags.getValue(qName);
        switch (enumTag) {
            case COLOR:
                insideColorElement = false;
                colorList.put(key, colorBuffer.toString());
            break;
            case UNIT:
                insideUnitElement = false;
                unitList.add(unitBuffer.toString());
            break;
            case FONT:
                insideFontElement = false;
                fontList.put(fontBuffer.toString(), fontBuffer.toString());
            break;
        }
    }

    @Override
    public void characters(char[] ch, int start, int length) {
        if (insideColorElement) {
            colorBuffer.append(ch, start, length);
        } else if (insideUnitElement) {
            unitBuffer.append(ch, start, length);
        } else if (insideFontElement) {
            fontBuffer.append(ch, start, length);
        }
    }

    public Map<String, String> getColorList() {
        return colorList;
    }

    public Map<String, String> getFontList() {
        return fontList;
    }

    public List<String> getUnitList() {
        return unitList;
    }
}
