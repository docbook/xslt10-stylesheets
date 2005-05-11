<!--  ======================================================================  -->
<!--
 |
 |file:  html/chunktoc.xsl
 |       replace "base.dir" with "$target.doc.dir.path"
 |
 -->

<xsl:template name="process-chunk">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="chunks" select="document($chunk.toc,.)"/>

  <xsl:variable name="chunk" select="$chunks//tocentry[@linkend=$id]"/>
  <xsl:variable name="prev-id"
                select="($chunk/preceding::tocentry
                         |$chunk/ancestor::tocentry)[last()]/@linkend"/>
  <xsl:variable name="next-id"
                select="($chunk/following::tocentry
                         |$chunk/child::tocentry)[1]/@linkend"/>

  <xsl:variable name="prev" select="key('id',$prev-id)"/>
  <xsl:variable name="next" select="key('id',$next-id)"/>

  <xsl:variable name="ischunk">
    <xsl:call-template name="chunk"/>
  </xsl:variable>

  <xsl:variable name="chunkfn">
    <xsl:if test="$ischunk='1'">
      <xsl:apply-templates mode="chunk-filename" select="."/>
    </xsl:if>
  </xsl:variable>

  <xsl:variable name="target.doc.dir.path">
    <xsl:call-template name="target.doc.dir.path">
      <xsl:with-param name="doc.node" select="."/>
    </xsl:call-template>
  </xsl:variable>


  <xsl:variable name="filename">
    <xsl:call-template name="make-relative-filename">
      <xsl:with-param name="base.dir" select="$target.doc.dir.path"/>
      <xsl:with-param name="base.name" select="$chunkfn"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$ischunk = 0">
      <xsl:apply-imports/>
    </xsl:when>

    <xsl:otherwise>
      <xsl:call-template name="write.chunk">
        <xsl:with-param name="filename" select="$filename"/>
        <xsl:with-param name="content">
          <xsl:call-template name="chunk-element-content">
            <xsl:with-param name="prev" select="$prev"/>
            <xsl:with-param name="next" select="$next"/>
          </xsl:call-template>
        </xsl:with-param>
        <xsl:with-param name="quiet" select="$chunk.quietly"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
