<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

<!-- DocBook stylesheet driver file for processing DocBook
     documents for chunked HTML output using a target database
     for resolving olinks.

     Adjust this relative reference for importing the
     standard chunk.xsl file.
 -->


<xsl:import href="../../docbook-xsl-1.45/html/chunk.xsl"/>
<xsl:output method="html" indent="yes" encoding="UTF-8"/>

<xsl:param name="target.database.document" select="''"/>
<xsl:param name="use.id.as.filename" select="'1'"/>
<xsl:param name="quiet" select="1"/>

<xsl:include href="newolink.xsl"/>

</xsl:stylesheet>

