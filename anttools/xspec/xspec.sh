#! /bin/bash -e

export CLASSPATH=".:/Library/Application Support/oxygen9.3/lib/saxon9.jar"

XSPEC=$1

if [ ! -f "$XSPEC" ]
then
   echo File not found.
   echo Usage:
   echo   xspec filename [coverage]
   echo     filename should specify an XSpec document
   echo     if coverage is specified, outputs test coverage report
   exit 1
   # exit with code 1 is error exit
fi

COVERAGE=$2

TEST_DIR=$(dirname "$XSPEC")/xspec
TARGET_FILE_NAME=$(basename "$XSPEC" | sed -E 's:\..+$::g')

TEST_STYLESHEET=$TEST_DIR/$TARGET_FILE_NAME.xsl
COVERAGE_XML=$TEST_DIR/$TARGET_FILE_NAME-coverage.xml
COVERAGE_HTML=$TEST_DIR/$TARGET_FILE_NAME-coverage.html
RESULT=$TEST_DIR/$TARGET_FILE_NAME-result.xml
HTML=$TEST_DIR/$TARGET_FILE_NAME-result.html

if [ ! -d "$TEST_DIR" ]
then
 echo "Creating XSpec Directory at $TEST_DIR..."
 mkdir "$TEST_DIR"
 echo
fi 

echo "Creating Test Stylesheet..."
java net.sf.saxon.Transform -o:"$TEST_STYLESHEET" -s:"$XSPEC" -xsl:generate-xspec-tests.xsl
echo

echo "Running Tests..."
if test "$COVERAGE" = "coverage" 
then 
 echo "Collecting test coverage data; suppressing progress report..."
 java net.sf.saxon.Transform -T:com.jenitennison.xslt.tests.XSLTCoverageTraceListener	\
     -o:"$RESULT" -s:"$XSPEC" -xsl:"$TEST_STYLESHEET" -it:{http://www.jenitennison.com/xslt/xspec}main 2> "$COVERAGE_XML"
else
 java net.sf.saxon.Transform -o:"$RESULT" -s:"$XSPEC" -xsl:"$TEST_STYLESHEET" -it:{http://www.jenitennison.com/xslt/xspec}main
fi

echo
echo "Formatting Report..."
java net.sf.saxon.Transform -o:"$HTML" -s:"$RESULT" -xsl:format-xspec-report.xsl
if test "$COVERAGE" = "coverage" 
then 
 java net.sf.saxon.Transform -l:on -o:"$COVERAGE_HTML" -s:"$COVERAGE_XML" -xsl:coverage-report.xsl "tests=$XSPEC"
 open "$COVERAGE_HTML"
else
 open "$HTML"
fi

echo "Done."
exit 0
