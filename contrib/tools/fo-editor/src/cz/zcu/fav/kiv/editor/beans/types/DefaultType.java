package cz.zcu.fav.kiv.editor.beans.types;

import java.util.Iterator;
import java.util.Map;

import cz.zcu.fav.kiv.editor.controller.logger.Log;

public class DefaultType implements Cloneable {

    /** The default value of the type */
    protected String defaultValue;
    
    /** The list of predefined values of the type */
    protected Map<String, String> valueList;
    
    public Object clone() {
        DefaultType type = null;
        try {
            type = (DefaultType) super.clone();
            type.setDefaultValue(defaultValue);
            type.setValueList(this.valueList);           
        } catch (CloneNotSupportedException ex) {
            Log.error(ex);
        }
        return type;
    }

    public void setDefaultValue(String defaultValue) {
        this.defaultValue = defaultValue;
    }

    public void setValueList(Map<String, String> valueList) {
        this.valueList = valueList;
    }

    public String getDefaultValue() {
        return defaultValue;
    }

    public Map<String, String> getValueList() {
        return valueList;
    }
    
    /**
     * Returns the key for input value it it is contained in the list of predefined values.
     * 
     * @param value
     *            a value of the searched value contained in the list of predefined values.
     * @return a key belonging to the input value contained in the list of predefined values.
     */
    public String getKeyFromValue(String value) {
        if (valueList != null)
            for (Iterator it = valueList.entrySet().iterator(); it.hasNext();) {
                Map.Entry e = (Map.Entry) it.next();
                if (e.getValue().equals(value))
                    return e.getKey().toString();
            }
        return null;
    }
}
