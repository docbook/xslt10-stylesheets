package cz.zcu.fav.kiv.editor.beans.types;

import java.util.List;
import java.util.Map;

public class CommonTypes {
    /** The list of unit values */
    private List<String> units;

    /** The list of font values */
    private Map<String, String> fonts;

    /** The list of color values */
    private Map<String, String> colors;
    
    public CommonTypes(List<String> units, Map<String, String> colors, Map<String, String> fonts){
        this.units = units;
        this.colors = colors;
        this.fonts = fonts;
    }

    public Map<String, String> getColors() {
        return colors;
    }

    public Map<String, String> getFonts() {
        return fonts;
    }

    public List<String> getUnits() {
        return units;
    }
}
