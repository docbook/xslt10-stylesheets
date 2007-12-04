package cz.zcu.fav.kiv.editor.stylesheet;

import org.w3c.dom.Element;
import org.w3c.dom.Node;

import cz.zcu.fav.kiv.editor.beans.ConfigData;
import cz.zcu.fav.kiv.editor.beans.parameters.Parameter;
import cz.zcu.fav.kiv.editor.beans.properties.Attribute;
import cz.zcu.fav.kiv.editor.beans.properties.Property;
import cz.zcu.fav.kiv.editor.beans.types.Type;
import cz.zcu.fav.kiv.editor.controller.MessageWriter;
import cz.zcu.fav.kiv.editor.controller.errors.ParserException;
import cz.zcu.fav.kiv.editor.controller.resource.ResourceController;

/**
 * The <code>OpenFileHadler</code> class contains methods for processing elements of loading XSL
 * stylesheet files.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class OpenFileHadler {

    /**
     * Parses node 'parameter' and its value in the input XSL file.
     * 
     * @param node
     *            the node 'parameter' in the input XSL file.
     * @param line
     *            the number of line where is the node 'parameter' in the input XSL file.
     * @param data
     *            the data containing editor data structure.
     */
    public static void parserParameterTag(Element node, int line, ConfigData data) {
        String paramName = null;
        String paramValue = null;
        try {
            paramName = node.getAttributeNode(XslTagConst.NAME).getNodeValue();
            // param has both - select and text value
            if (node.hasAttribute(XslTagConst.SELECT) && (node.hasChildNodes()))
                throw new ParserException();

            if (node.hasAttribute(XslTagConst.SELECT))
                paramValue = node.getAttribute(XslTagConst.SELECT);
            else {
                Node text = node.getFirstChild(); // Text
                paramValue = text.getNodeValue().toString();
            }

            Parameter param = data.searchParameter(paramName);
            if (param != null) {
                parserValue(param.getType(), paramValue);
                param.setNode(node);
                param.setChosen();
            } else {
                MessageWriter.writeWarning(ResourceController.getMessage(
                        "open_file.parameter_exist", line, paramName));
            }
        } catch (Throwable ex) {
            MessageWriter.writeWarning(ResourceController.getMessage("open_file.parameter_invalid",
                    line, paramName));
        }
    }

    /**
     * Parses node 'attribute-set' and its value in the input XSL file.
     * 
     * @param node
     *            the node 'attribute-set' in the input XSL file.
     * @param line
     *            the number of line where is the node 'attribute-set' in the input XSL file.
     * @param data
     *            the data containing editor data structure.
     * @return the editor property corresponding to the node 'attribute-set'
     */
    public static Property parserPropertyTag(Element node, int line, ConfigData data) {
        String propName = null;
        Property prop = null;
        try {
            propName = node.getAttributeNode(XslTagConst.NAME).getNodeValue();

            prop = data.searchProperty(propName);
            if (prop != null) {
                prop.setNode(node);
                prop.setChosen();
            } else
                MessageWriter.writeWarning(ResourceController.getMessage(
                        "open_file.attribute_set_exist", line, propName));

        } catch (Throwable ex) {
            MessageWriter.writeWarning(ResourceController.getMessage(
                    "open_file.attribute_set_invalid", line, propName));
        }
        return prop;
    }

    /**
     * Parses node 'attribute' of the node 'attribute-set' and its value in the input XSL file.
     * 
     * @param node
     *            the node 'attribute' in the input XSL file.
     * @param line
     *            the number of line where is the node 'attribute' in the input XSL file.
     * @param propery
     *            the parent property of attribute.
     */
    public static void parserPropertyAttribute(Element node, int line, Property propery) {
        String attrName = null;
        String attrValue = null;
        try {
            attrName = node.getAttributeNode(XslTagConst.NAME).getNodeValue();
            Node text = node.getFirstChild(); // Text
            attrValue = text.getNodeValue().toString();

            Attribute attr = propery.searchAttribute(attrName);
            if (attr != null) {
                parserValue(attr.getType(), attrValue);
                attr.setChosen(true);
                attr.setNode(node);
            } else
                MessageWriter.writeWarning(ResourceController.getMessage(
                        "open_file.attribute_exist", line, attrName));

        } catch (Throwable ex) {
            MessageWriter.writeWarning(ResourceController.getMessage("open_file.attribute_invalid",
                    line, attrName));
        }
    }

    /**
     * Parses the value of node 'parameter' and assignes it to the corresponding parameter.
     * <code>Type</code>.
     * 
     * @param type
     *            the type of parameter.
     * @param typeValue
     *            the new value of the type.
     * @throws ParserException
     *             if the new value is not valid.
     */
    private static void parserValue(Type type, String typeValue) throws ParserException {
        typeValue = typeValue.trim().replaceAll("'", "");
        type.setLoadedValue(typeValue);
    }

}
