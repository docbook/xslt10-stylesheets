package cz.zcu.fav.kiv.editor.stylesheet;

import org.w3c.dom.Comment;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.Text;

import cz.zcu.fav.kiv.editor.beans.ConfigData;
import cz.zcu.fav.kiv.editor.beans.common.ParentParameter;
import cz.zcu.fav.kiv.editor.beans.parameters.Parameter;
import cz.zcu.fav.kiv.editor.beans.parameters.TypeParam;
import cz.zcu.fav.kiv.editor.beans.properties.Attribute;
import cz.zcu.fav.kiv.editor.beans.properties.AttributeGroup;
import cz.zcu.fav.kiv.editor.beans.properties.Property;
import cz.zcu.fav.kiv.editor.beans.properties.TypeAttr;
import cz.zcu.fav.kiv.editor.beans.sections.Group;
import cz.zcu.fav.kiv.editor.beans.sections.Section;
import cz.zcu.fav.kiv.editor.beans.sections.Subsection;
import cz.zcu.fav.kiv.editor.controller.options.OptionItems;

/**
 * The <code>SaveFileHandler</code> class contains methods for saving changes of actually opened
 * XSL stylesheet file.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class SaveFileHandler {

    /**
     * Saves changes of actually opened XSL stylesheet file.
     * 
     * @param doc
     *            DOM structure of the opened XSL document.
     * @param data
     *            the data containing editor data structure.
     */
    public static void saveStylesheet(Document doc, ConfigData data) {
        Node stylesheet = doc.getElementsByTagName(XslTagConst.STYLESHEET).item(0);
        Node firstNode = null;
        boolean newInSection;
        boolean isInserted = false;
        for (Section section : data.getSectionList()) {            
            for (Subsection subsection : section.getSubsectionList()) {
                if ((OptionItems.REARRANGE_SAVE)&&(subsection.getComment() != null))
                       subsection.setComment(null);  
                firstNode = null;
                newInSection = false;
                for (Group gr : subsection.getGroupList()) {
                    for (ParentParameter elem : gr.getElementList()) {
                        if (elem instanceof Parameter) {
                            if (OptionItems.REARRANGE_SAVE)
                                isInserted = rearrangeParameter((Parameter) elem, doc, stylesheet);
                            else {
                                isInserted = changeParameter((Parameter) elem, doc, stylesheet, subsection.getComment()); 
                            }           
                        }
                        if (elem instanceof Property) {
                            isInserted = changeProperty((Property) elem, doc, stylesheet, subsection.getComment());                                   
                        }
                        if (elem.getNode() != null) {
                            //first node inserted in section -> insert comment
                            if ((isInserted)&&(!newInSection)) {            
                                newInSection = true;
                                firstNode = elem.getNode(); 
                            }
                        }
                    }
                }
                //has comment?
                if ((OptionItems.GENERATE_COMMENTS) && (firstNode != null)
                    && (subsection.getComment() == null)
                    && (newInSection)) {   
                    Comment comment = doc.createComment(" " + section.getTitle() + " :: "
                            + subsection.getTitle() + " ");
                    subsection.setComment(comment);
                    stylesheet.insertBefore(comment, firstNode);             
                }
                //remove comment - no parameters
                if ((subsection.getComment() != null)
                    && (subsection.getComment().getNextSibling() instanceof Comment)) {                 
                    XslParser.removeNode(subsection.getComment());
                    subsection.setComment(null);                  
                }
            }
        }
    }

    /**
     * Changes the parameter value and places the parameter at the end of stylesheet file.
     * 
     * @param param
     *            the changing parameter.
     * @param doc
     *            DOM structure of the opened XSL document.
     * @param stylesheet
     *            the node of 'stylesheet' element.
     * @return true if the parameter was inserted at the end of stylesheet.
     */
    private static boolean rearrangeParameter(Parameter param, Document doc, Node stylesheet) {
        if (param.getNode() != null) {
            XslParser.removeNode(param.getNode());
            param.setNode(null);
        }
        // add node at the end
        return addNewParameter(param, doc, stylesheet, null);
    }

    /**
     * Change parameter value in the opened stylesheet file. If the parameter is yet in the opened
     * stylesheet then it is inserted at the end of stylesheet.
     * 
     * @param param
     *            the changing parameter.
     * @param doc
     *            DOM structure of the opened XSL document.
     * @param stylesheet
     *            the node of 'stylesheet' element.
     * @param lastNode
     *            the last node of the same subsection.          
     * @return true if the parameter was inserted at the end of stylesheet.
     */
    private static boolean changeParameter(Parameter param, Document doc, Node stylesheet, Node lastNode) {
        if (param.getNode() != null) {
            if (!param.isChosen()) {
                XslParser.removeNode(param.getNode());
                param.setNode(null);
            } else {
                Node newNode = createParamElement(param, doc);
                param.getNode().getParentNode().replaceChild(newNode, param.getNode());
                param.setNode(newNode);
            }
            return false;
        }
        return addNewParameter(param, doc, stylesheet, lastNode);
    }

    /**
     * Inserts a new parameter at the end of stylesheet file 
     * or after the 'lastNode' it it is not null.
     * 
     * @param param
     *            the changing parameter.
     * @param doc
     *            DOM structure of the opened XSL document.
     * @param stylesheet
     *            the node of 'stylesheet' element.
     * @param lastNode
     *            the last node of the same subsection.                   
     * @return true if the parameter was inserted at the end of stylesheet file.
     */
    private static boolean addNewParameter(Parameter param, Document doc, Node stylesheet, Node lastNode) {
        if (param.isChosen()) {
            Node node = createParamElement(param, doc);
            if (lastNode != null)
                stylesheet.insertBefore(node, lastNode.getNextSibling());
            else
                stylesheet.appendChild(node);
            param.setNode(node);
            return true;
        }
        return false;
    }

    /**
     * Changes or inserts property in the stylesheet file.
     * 
     * @param prop
     *            the changing property.
     * @param doc
     *            DOM structure of the opened XSL document.
     * @param stylesheet
     *            the node of 'stylesheet' element.
     * @return true if the property was inserted at the end of stylesheet file.
     */
    private static boolean changeProperty(Property prop, Document doc, Node stylesheet, Node lastNode) {
        if ((prop.getNode() == null) && (prop.isChosen())) {
            Element attrSetElem = doc.createElement(XslTagConst.ATTRIBUTE_SET);
            attrSetElem.setAttribute(XslTagConst.NAME, prop.getName());
            changeAttributes(prop.getAttributeGroupList(), attrSetElem, doc);
            // add new property
            if (attrSetElem.getChildNodes().getLength() > 0) {
                if (lastNode != null)
                    stylesheet.insertBefore(attrSetElem, lastNode.getNextSibling());
                else
                    stylesheet.appendChild(attrSetElem);
                prop.setNode(attrSetElem);
                return true;
            }
            return false;
        }
        // property is not chosen and was in the opened stylesheet file
        if ((prop.getNode() != null) && (!prop.isChosen())) {
            XslParser.removeNode(prop.getNode());
            return false;
        }

        if ((prop.getNode() != null) && (prop.isChosen())) {
            changeAttributes(prop.getAttributeGroupList(), prop.getNode(), doc);
            // move property to the end
            if (OptionItems.REARRANGE_SAVE) {
                stylesheet.appendChild(prop.getNode());
                return true;
            }
            return false;
        }
        return false;
    }

    /**
     * Changes property attributes and their values.
     * 
     * @param attributeGroups
     *            the groups of attributes of the parent property.
     * @param parent
     *            the node of parent property.
     * @param doc
     *            DOM structure of the opened XSL document.
     */
    private static void changeAttributes(AttributeGroup[] attributeGroups, Node parent, Document doc) {
        Node node;
        for (AttributeGroup panel : attributeGroups)
            for (Attribute attr : panel.getAttributeList()) {
                if (attr.isChosen()) {
                    if (attr.getNode() != null) {
                        attr.getNode().setTextContent(createNewValueAttr(attr.getType()));
                    } else {
                        node = createAttributeElement(attr, doc);
                        parent.appendChild(node);
                        attr.setNode(node);
                    }
                } else {
                    if (attr.getNode() != null) {
                        XslParser.removeNode(attr.getNode());
                        attr.setNode(null);
                    }
                }
            }
    }

    /**
     * Creates a new node from parameter.
     * 
     * @param param
     *            the parameter used for creating the node.
     * @param doc
     *            DOM structure of the opened XSL document.
     * @return the new parameter node.
     */
    private static Element createParamElement(Parameter param, Document doc) {
        Element paramElem = doc.createElement(XslTagConst.PARAM);
        // name
        paramElem.setAttribute(XslTagConst.NAME, param.getName());

        String paramValue = createNewValueParam(param.getType());

        if (OptionItems.USE_PARAM_SELECT) {
            paramElem.setAttribute(XslTagConst.SELECT, addApostrophe(paramValue));
        } else {
            Text text = doc.createTextNode(paramValue);
            paramElem.appendChild(text);
        }

        return paramElem;
    }

    /**
     * Creates a new node from attribute.
     * 
     * @param attr
     *            the attribute used for creating the node.
     * @param doc
     *            DOM structure of the opened XSL document.
     * @return the new attribute node.
     */
    private static Element createAttributeElement(Attribute attr, Document doc) {
        Element element = doc.createElement(XslTagConst.ATTRIBUTE);

        Text text = doc.createTextNode(createNewValueAttr(attr.getType()));
        element.appendChild(text);

        // name
        element.setAttribute(XslTagConst.NAME, attr.getName());
        return element;
    }

    /**
     * Creates a new value content of the parameter node.
     * 
     * @param type
     *            the parameter type with value.
     * @return the new value content of the parameter node.
     */
    private static String createNewValueParam(TypeParam type) {
        StringBuilder value = new StringBuilder(type.getValue());
        if (type.getUnit() != null)
            value.append(type.getUnit().getValue());
        return value.toString();
    }

    /**
     * Creates a new value content of the attribute node.
     * 
     * @param types
     *            the attribute type with value.
     * @return the new value content of the attribute node.
     */
    private static String createNewValueAttr(TypeAttr type) {
        StringBuilder attrValue = new StringBuilder();
        attrValue.append(type.getValue().toString());
        if (type.getUnit() != null)
            attrValue.append(type.getUnit().getValue());

        return attrValue.toString().trim();
    }

    /**
     * Adds apostrophes around the value if the value isnt't a number.
     * 
     * @param value
     *            the changing value.
     * @return value with apostrophes if the value isn't a number.
     */
    private static String addApostrophe(String value) {
        try {
            Float.parseFloat(value);
        } catch (NumberFormatException e) {
            value = "'" + value.trim() + "'";
        }
        return value;
    }
    
}
