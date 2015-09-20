package cz.zcu.fav.kiv.editor.config;

import java.text.DecimalFormat;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import cz.zcu.fav.kiv.editor.beans.parameters.Parameter;
import cz.zcu.fav.kiv.editor.config.constants.FileConst;
import cz.zcu.fav.kiv.editor.config.constants.TagDefinition;
import cz.zcu.fav.kiv.editor.controller.MessageWriter;
import cz.zcu.fav.kiv.editor.controller.errors.ParserException;
import cz.zcu.fav.kiv.editor.controller.resource.ResourceController;
import cz.zcu.fav.kiv.editor.utils.TagControl;

/**
 * The <code>ParameterDependencyParser</code> class contains methods for parsing parameter complex
 * values that contains references to other parameter values.
 * 
 * @author Marta Vaclavikova
 * @version 1.0, 05/2007
 */
public class ParameterDependencyParser {
    /** The sign asterisk */
    private static final String SIGN_ASTERISK = "*";

    /** The sign plus left */
    private static final String SIGN_PLUS_LEFT = "+L";

    /** The sign plus right */
    private static final String SIGN_PLUS_RIGHT = "+R";

    /** The sign equal */
    private static final String SIGN_EQUAL = "=";

    /** The sign not equal */
    private static final String SIGN_NOT_EQUAL = "!=";

    /** The name contains */
    private static final String CONTAINS = "contains";

    /** The format for formating double numbers */
    private static final DecimalFormat formatDouble = new DecimalFormat("0.##");

    /** The parser of XML parameter definitions */
    private ParameterParser paramParser;

    /** The actually parsed parameter */
    private Parameter parameter;

    /** The flag indicating if the parameter value is valid */
    private boolean valid;

    /**
     * Initializes a newly created <code>ParameterDependencyParser</code>.
     * 
     * @param parser
     *            the parser of XML parameter definitions.
     */
    public ParameterDependencyParser(ParameterParser parser) {
        this.paramParser = parser;
    }

    /**
     * Parses the complex value of the parameter.
     * 
     * @param parameter
     *            the parsed parameter.
     * @return true if the parameter value is successfully parsed.
     */
    public boolean parseParameterDependency(Parameter parameter) {
        this.parameter = parameter;
        valid = false;

        processXslChoose(parameter.getType().getValue());

        if (!valid)
            MessageWriter.writeWarning(ResourceController.getMessage(
                    "parser.parameters.invalid_value", FileConst.CONF_FILE_CONFIG, parameter
                            .getName(), parameter.getLineNumber()));
        return valid;
    }

    /**
     * Parses simple complex value.
     * 
     * @param simpleValue
     *            the complex parameter value.
     */
    private void parseSimpleValue(String simpleValue) {
        parseSimpleValue(simpleValue, "");
    }

    /**
     * Parses simple complex value.
     * 
     * @param complexValue
     *            the complex parameter value.
     * @param secondAddValue
     *            the string creating the end of parameter value.
     */
    private void parseSimpleValue(String complexValue, String secondAddValue) {
        // $param * number
        if (complexValue.matches("\\$[\\w\\.]+\\s*\\*\\s*[\\d\\.]+")) {
            String[] valueParts = complexValue.split("\\*");
            evaluateSimpleValue(valueParts[0], valueParts[1], SIGN_ASTERISK, secondAddValue);
            return;
        }
        // number * $param
        if (complexValue.matches("\\d+\\s*\\*\\s*\\$[\\w\\.]+")) {
            String[] valueParts = complexValue.split("\\*");
            evaluateSimpleValue(valueParts[1], valueParts[0], SIGN_ASTERISK, secondAddValue);
            return;
        }
        // $param
        if (complexValue.matches("\\$[\\w\\.]+")) {
            evaluateSimpleValue(complexValue, null, null, secondAddValue);
            return;
        }

        // concat('..', $param)
        if (complexValue.matches("concat\\('\\w+',\\s*\\$[\\w\\.]+\\)")) {
            String[] valueParts = complexValue.split("[(,)]");
            evaluateSimpleValue(valueParts[2].trim(), valueParts[1].replaceAll("'", ""),
                    SIGN_PLUS_LEFT, secondAddValue);
            return;
        }
        // concat($param, '..')
        if (complexValue.matches("concat\\(\\$[\\w\\.]+,\\s*'\\w+'\\)")) {
            String[] valueParts = complexValue.split("[(,)]");
            evaluateSimpleValue(valueParts[1].trim(), valueParts[2].replaceAll("'", ""),
                    SIGN_PLUS_RIGHT, secondAddValue);
            return;
        }
        setParameterValue(complexValue);
    }

    /**
     * Parsed the structure <xsl:value-of select="..."></xsl:value-of><xsl:text>...</xsl:text>.
     * 
     * @param complexValue
     *            the complex parameter value.
     */
    private void processXslValueOf(String complexValue) {
        String lineValue = complexValue.replaceAll("\n", "").trim();
        if (lineValue
                .matches("<xsl:value-of select=\".+?\"></xsl:value-of>(<xsl:text>.+?</xsl:text>)?")) {
            Pattern patternXslValueOf = Pattern
                    .compile("<xsl:value-of select=\"(.+?)\"></xsl:value-of>(<xsl:text>(.+?)</xsl:text>)?");
            Matcher matcherXslValueOf = patternXslValueOf.matcher(complexValue);
            if (matcherXslValueOf.find()) {
                parseSimpleValue(matcherXslValueOf.group(1),
                        ((matcherXslValueOf.group(3) != null) ? matcherXslValueOf.group(3) : ""));
            }
            return;
        }
        parseSimpleValue(complexValue);
    }

    /**
     * Parsed the structure <xsl:choose>...</xsl:choose>.
     * 
     * @param complexValue
     *            the complex parameter value.
     */
    private void processXslChoose(String complexValue) {
        String lineValue = complexValue.replaceAll("\n", "");
        if (lineValue.matches("<xsl:choose>.*</xsl:choose>")) {
            Pattern patternWhen = Pattern.compile("<xsl:when test=\"(.+?)\">(.+?)</xsl:when>");
            Matcher matcherWhen = patternWhen.matcher(lineValue);
            boolean testResult = false;
            while (matcherWhen.find()) {
                testResult = parseXslWhenTest(matcherWhen.group(1));
                if (testResult) {
                    processXslValueOf(matcherWhen.group(2));
                    break;
                }
            }
            if (!testResult) {
                Pattern patternOtherwise = Pattern.compile("<xsl:otherwise>(.*)</xsl:otherwise>");
                Matcher matcherOtherwise = patternOtherwise.matcher(lineValue);
                while (matcherOtherwise.find()) {
                    processXslValueOf(matcherOtherwise.group(1));
                }
            }
            return;
        }
        processXslValueOf(complexValue);
    }

    /**
     * Parses the condition test of the structure <xsl:when test="..."></xsl:when>.
     * 
     * @param testAttribute
     *            the content of attribute test.
     * @return true if the condition in the <code>test</code> attribute is true.
     */
    private boolean parseXslWhenTest(String testAttribute) {
        // $param = 'value' or $param != 'value'
        if (testAttribute.startsWith("$")) {
            // control pattern: $param = 'value' or $param = value
            Pattern pattern = Pattern.compile("\\$(.+?) ?(!?=) ?('?.++'?)");
            Matcher matcher = pattern.matcher(testAttribute);
            if (matcher.find()) {
                return evaluateXslWhenTest(matcher.group(1), matcher.group(2), matcher.group(3)
                        .replaceAll("'", ""));
            }
        }

        // contains($param, 'value')
        if (testAttribute.startsWith(TagDefinition.ParameterTags.CONTAINS)) {
            Pattern pattern = Pattern.compile("contains\\(\\$(\\$.+?), *('?.+?'?)\\)");
            Matcher matcher = pattern.matcher(testAttribute);
            if (matcher.find()) {
                return evaluateXslWhenTest(matcher.group(1), CONTAINS, matcher.group(2).replaceAll(
                        "'", ""));
            }
        }
        return false;
    }

    /**
     * Evaluate the condition in the test attribute.
     * 
     * @param param
     *            the name of parameter.
     * @param sign
     *            the sign of the condition.
     * @param value
     *            the value of the parameter.
     * @return true if the condition is true.
     */
    private boolean evaluateXslWhenTest(String param, String sign, String value) {
        Parameter testParam = paramParser.getParsedParameterList().get(param);
        if (sign.equals(SIGN_NOT_EQUAL)) {
            return !testParam.getType().getValue().equals(value);
        }
        if (sign.equals(SIGN_EQUAL)) {
            return testParam.getType().getValue().equals(value);
        }
        if (sign.equals(CONTAINS)) {
            return testParam.getType().getValue().contains(value);
        }
        return false;
    }

    /**
     * Evaluates the content of the simple complex value and assigns the new value to the parameter.
     * 
     * @param param
     *            the parameter on which the parameter is dependent.
     * @param addValue
     *            the value added to the parameter value.
     * @param sign
     *            the sign used for adding the value to the parameter value.
     * @param secondAddValue
     *            the second value added to the parameter value.
     */
    private void evaluateSimpleValue(String param, String addValue, String sign,
            String secondAddValue) {
        // parameter name without $
        String paramName = param.trim().substring(1);
        // control parameter
        Parameter par = paramParser.getParsedParameterList().get(paramName);
        if (par == null) {
            return;
        }
        String endValue = secondAddValue
                + ((par.getType().getUnit() != null) ? par.getType().getUnit().getValue() : "");
        // only param value
        if ((addValue == null) && (sign == null)) {
            setParameterValue(par.getType().getValue() + endValue);
            return;
        }

        // * -> addValue must be number
        if (sign.equals(SIGN_ASTERISK)) {
            try {
                Double result = Double.valueOf(addValue.trim())
                        * Double.valueOf(par.getType().getValue());
                setParameterValue(formatDouble.format(result) + endValue);
            } catch (NumberFormatException ex) {
            }
            return;
        }

        // + -> addValue is string
        if (sign.equals(SIGN_PLUS_LEFT)) {
            setParameterValue(addValue + par.getType().getValue() + endValue);
        }
        if (sign.equals(SIGN_PLUS_RIGHT)) {
            setParameterValue(par.getType().getValue() + addValue + endValue);
        }
    }

    /**
     * Sets the new value to the parameter.
     * 
     * @param newValue
     *            the new parameter value.
     */
    private void setParameterValue(String newValue) {
        try {
            TagControl.controlSetTypeValue(parameter.getType(), newValue);
            parameter.getType().assignDefaultFromValue();
            valid = true;
        } catch (ParserException ex) {
            valid = false;
        }

    }
}
