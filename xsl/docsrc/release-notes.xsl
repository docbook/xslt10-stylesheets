<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

<!-- This doesn't really belong in docsrc... -->

<xsl:import href="doc-link-docbook.xsl"/>

<xsl:template name="user.head.content">
  <xsl:param name="node" select="."/>

  <style type="text/css"><xsl:text>
p.commit-changes { font-size: 8pt;
                   font-family: monospace;
                   color: #9F9F9F;
                 }
</xsl:text></style>

</xsl:template>

</xsl:stylesheet>
