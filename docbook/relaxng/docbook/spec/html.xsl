<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:db="http://docbook.org/ns/docbook"
		xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:t="http://docbook.org/xslt/ns/template"
		xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:xs='http://www.w3.org/2001/XMLSchema'
		exclude-result-prefixes="db f h m t xlink xs"
                version="2.0">

<xsl:import href="/sourceforge/docbook/xsl2/base/html/docbook.xsl"/>

<xsl:param name="generate.toc" as="element()*">
<tocparam path="appendix" toc="0" title="0"/>
<tocparam path="article"  toc="1" title="1"/>
</xsl:param>

<xsl:param name="section.label.includes.component.label" select="1"/>

<xsl:param name="bibliography.collection" select="'bibliography.xml'"/>

<xsl:param name="docbook.css" select="'docbook.css'"/>

<xsl:param name="linenumbering" as="element()*">
<ln path="literallayout" everyNth="0"/>
<ln path="programlisting" everyNth="0"/>
<ln path="programlistingco" everyNth="0"/>
<ln path="screen" everyNth="0"/>
<ln path="synopsis" everyNth="0"/>
<ln path="address" everyNth="0"/>
<ln path="epigraph/literallayout" everyNth="0"/>
</xsl:param>

<xsl:param name="profile.condition" select="'online'"/>

<!-- ============================================================ -->

<xsl:template name="t:user-head-content">
  <xsl:param name="node" select="."/>
  <link href="OASIS_Specification_Template_v1-0.css"
	rel="stylesheet" type="text/css" />

  <style type="text/css">
h1,
div.toc p b { 
  font-family: Arial, Helvetica, sans-serif;
  font-size: 18pt;
  font-weight: bold;
  list-style-type: decimal;
  color: #66116D;
}
  </style>
</xsl:template>

<xsl:template match="db:article">
  <xsl:variable name="toc.params"
		select="f:find-toc-params(., $generate.toc)"/>

  <p>
    <img src="http://docs.oasis-open.org/templates/OASISLogo.jpg"
	 alt="OASIS logo" width="203" height="54" />
  </p>

  <xsl:apply-templates select="db:info"/>

  <xsl:call-template name="make-lots">
    <xsl:with-param name="toc.params" select="$toc.params"/>
    <xsl:with-param name="toc">
      <xsl:call-template name="component-toc">
	<xsl:with-param name="toc.title" select="$toc.params/@title != 0"/>
      </xsl:call-template>
    </xsl:with-param>
  </xsl:call-template>

  <xsl:apply-templates select="*[not(self::db:info)]"/>
</xsl:template>

<xsl:template match="db:article/db:info">
  <div class="head">
    <h1>
      <xsl:apply-templates select="db:title/node()"/>
      <xsl:text> Version </xsl:text>
      <xsl:value-of select="db:productnumber"/>
    </h1>

    <h2>
      <xsl:value-of select="../@status"/>
    </h2>

    <h2 class="pubdate">
      <xsl:value-of select="format-date(xs:date(db:pubdate[1]),
	                                '[D01] [MNn,*-3] [Y0001]')"/>
    </h2>

    <xsl:variable name="odnRoot">
      <xsl:value-of select="db:productname[1]"/>
      <xsl:text>-</xsl:text>
      <xsl:value-of select="db:productnumber[1]"/>
      <xsl:text>-</xsl:text>
      <xsl:value-of select="'spec'"/>
      <xsl:text>-</xsl:text>
      <xsl:value-of select="db:releaseinfo[@role='stage'][1]"/>
      <xsl:text>-</xsl:text>
      <xsl:value-of select="db:biblioid[@class='pubsnumber'][1]"/>
      <xsl:if test="ancestor::*[@xml:lang][1]
		    and ancestor::*[@xml:lang][1]/@xml:lang != 'en'">
	<xsl:text>-</xsl:text>
	<xsl:value-of select="ancestor::*[@xml:lang][1]/@xml:lang"/>
      </xsl:if>
    </xsl:variable>

    <div class="uris">
      <h3>Specification URIs:</h3>
      <dl>
	<dt>This Version:</dt>
	<xsl:for-each select="('.html','.pdf','.xml')">
	  <dd>
	    <a href="{$odnRoot}{.}">
	      <xsl:text>http://docs.oasis-open.org/docbook/specs/</xsl:text>
	      <xsl:value-of select="$odnRoot"/>
	      <xsl:value-of select="."/>
	    </a>
	  </dd>
	</xsl:for-each>
      </dl>
    </div>

    <div class="committee">
      <dl>
	<dt>Technical Committee:</dt>
	<xsl:for-each select="db:org/db:orgdiv">
	  <dd>
	    <a href="{@xlink:href}">
	      <xsl:value-of select="."/>
	    </a>
	  </dd>
	</xsl:for-each>

	<dt>
	  <xsl:text>Chair</xsl:text>
	  <xsl:if test="count(db:othercredit[@otherclass = 'chair']) &gt; 1">
	    <xsl:text>s</xsl:text>
	  </xsl:if>
	</dt>
	<xsl:for-each select="db:othercredit[@otherclass = 'chair']">
	  <dd>
	    <xsl:apply-templates select="db:personname"/>
	  </dd>
	</xsl:for-each>

	<xsl:variable name="editors" select="db:authorgroup/db:editor|db:editor"/>
	<dt>
	  <xsl:text>Editor</xsl:text>
	  <xsl:if test="count($editors) &gt; 1">
	    <xsl:text>s</xsl:text>
	  </xsl:if>
	</dt>
	<xsl:for-each select="$editors">
	  <dd>
	    <xsl:apply-templates select="db:personname"/>
	  </dd>
	</xsl:for-each>

	<xsl:variable name="replaces" select="db:bibliorelation[@type='replaces']"/>
	<xsl:variable name="supersedes" select="db:bibliorelation[@othertype='supersedes']"/>
	<xsl:variable name="related" select="db:bibliorelation[@type='references']"/>

	<xsl:if test="$replaces | $supersedes | $related">
	  <dt>Related Work:</dt>
	  <dd>
	    <dl>
	      <xsl:if test="$replaces|$supersedes">
		<dt>This specification replaces or supersedes:</dt>
		<xsl:for-each select="$replaces|$supersedes">
		  <dd>
		    <xsl:value-of select="@xlink:href"/>
		  </dd>
		</xsl:for-each>
	      </xsl:if>
	      <xsl:if test="$related">
		<dt>This specification is related to:</dt>
		<xsl:for-each select="$related">
		  <dd>
		    <xsl:value-of select="@xlink:href"/>
		  </dd>
		</xsl:for-each>
	      </xsl:if>
	    </dl>
	  </dd>
	</xsl:if>
      </dl>
    </div>

    <xsl:if test="db:bibliomisc[@role='namespace']">
      <div class="namespaces">
	<dl>
	  <dt>
	    <xsl:text>Declared XML Namespace</xsl:text>
	    <xsl:if test="count(db:bibliomisc[@role='namespace']) &gt; 1">s</xsl:if>
	  </dt>
	  <xsl:for-each select="db:bibliomisc[@role='namespace']">
	    <dd>
	      <xsl:value-of select="."/>
	    </dd>
	  </xsl:for-each>
	</dl>
      </div>
    </xsl:if>

    <div class="abstract">
      <h3>Abstract:</h3>
      <xsl:apply-templates select="db:abstract"/>
    </div>

    <div class="abstract">
      <h3>Status:</h3>
      <xsl:apply-templates select="db:legalnotice[@role='status']"/>
    </div>

    <div class="notices">
      <h2>Notices:</h2>
      <xsl:apply-templates select="db:legalnotice[@role='notices']"/>
    </div>
  </div>
</xsl:template>

<xsl:template match="db:abstract|db:legalnotice">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="db:section/db:info/db:title" mode="m:titlepage-mode">
  <xsl:variable name="depth"
		select="count(ancestor::db:section)"/>

  <xsl:variable name="hslevel"
		select="if ($depth &lt; 6) then $depth else 6"/>

  <xsl:variable name="hlevel"
		select="if (ancestor::db:appendix) then $hslevel+1 else $hslevel"/>

  <xsl:element name="h{$hlevel}" namespace="http://www.w3.org/1999/xhtml">
    <xsl:apply-templates select="../.." mode="m:object-title-markup">
      <xsl:with-param name="allow-anchors" select="1"/>
    </xsl:apply-templates>
  </xsl:element>
</xsl:template>

</xsl:stylesheet>

<!--
<div class="notices">
<h2>Notices</h2>
<p>Copyright &copy; OASIS&reg; 2008. All Rights Reserved.</p>

<p>All capitalized terms in the following text have the meanings
assigned to them in the OASIS Intellectual Property Rights Policy (the
&quot;OASIS IPR Policy&quot;). The full Policy may be found at the
OASIS website.</p>

<p>This document and translations of it may be copied and furnished to
others, and derivative works that comment on or otherwise explain it
or assist in its implementation may be prepared, copied, published,
and distributed, in whole or in part, without restriction of any kind,
provided that the above copyright notice and this section are included
on all such copies and derivative works. However, this document itself
may not be modified in any way, including by removing the copyright
notice or references to OASIS, except as needed for the purpose of
developing any document or deliverable produced by an OASIS Technical
Committee (in which case the rules applicable to copyrights, as set
forth in the OASIS IPR Policy, must be followed) or as required to
translate it into languages other than English. </p>

<p>The limited permissions granted above are perpetual and will not be
revoked by OASIS or its successors or assigns. </p>

<p>This document and the information contained herein is provided on
an &quot;AS IS&quot; basis and OASIS DISCLAIMS ALL WARRANTIES, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO ANY WARRANTY THAT THE USE OF
THE INFORMATION HEREIN WILL NOT INFRINGE ANY OWNERSHIP RIGHTS OR ANY
IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR
PURPOSE. </p>

<p>OASIS requests that any OASIS Party or any other party that
believes it has patent claims that would necessarily be infringed by
implementations of this OASIS Committee Specification or OASIS
Standard, to notify OASIS TC Administrator and provide an indication
of its willingness to grant patent licenses to such patent claims in a
manner consistent with the IPR Mode of the OASIS Technical Committee
that produced this specification.</p>

<p>OASIS invites any party to contact the OASIS TC Administrator if it
is aware of a claim of ownership of any patent claims that would
necessarily be infringed by implementations of this specification by a
patent holder that is not willing to provide a license to such patent
claims in a manner consistent with the IPR Mode of the OASIS Technical
Committee that produced this specification. OASIS may include such
claims on its website, but disclaims any obligation to do so.</p>

<p>OASIS takes no position regarding the validity or scope of any
intellectual property or other rights that might be claimed to pertain
to the implementation or use of the technology described in this
document or the extent to which any license under such rights might or
might not be available; neither does it represent that it has made any
effort to identify any such rights. Information on OASIS' procedures
with respect to rights in any document or deliverable produced by an
OASIS Technical Committee can be found on the OASIS website. Copies of
claims of rights made available for publication and any assurances of
licenses to be made available, or the result of an attempt made to
obtain a general license or permission for the use of such proprietary
rights by implementers or users of this OASIS Committee Specification
or OASIS Standard, can be obtained from the OASIS TC Administrator.
OASIS makes no representation that any information or list of
intellectual property rights will at any time be complete, or that any
claims in such list are, in fact, Essential Claims.</p>

<p>The names "OASIS", [insert specific trademarked names,
abbreviations, etc. here] are trademarks of <a
href="http://www.oasis-open.org">OASIS</a>, the owner and developer of
this specification, and should be used only to refer to the
organization and its official outputs. OASIS welcomes reference to,
and implementation and use of, specifications, while reserving the
right to enforce its marks against misleading uses. Please see <a
href="http://www.oasis-open.org/who/trademark.php">http://www.oasis-open.org/who/trademark.php</a>
for above guidance.</p>
</div>
</div>

<p class="heading1">Table of Contents</p>
<p>[build table of contents here. Should list at least 3 levels (sections numbered x.x.x) which are hyperlinked to the actual section.] </p>
<p class="titlepageinfodescription">1.0 <a href="#A1">Introduction</a></p>
<p class="titlepageinfodescription">1.1 <a href="#A1-1"> Terminology</a></p>
<p class="titlepageinfodescription">1.2 <a href="#A1-2">Normative References</a></p>

<p class="titlepageinfodescription">1.3 <a href="#A1-3">Non-Normative References</a></p>
<p class="titlepageinfodescription">2.0 <a href="#A2">[Section title]</a></p>
<p class="titlepageinfodescription">#.0 <a href="#A9">Conformance</a></p>
<p class="titlepageinfodescription">A. <a href="#AA">Acknowledgements</a></p>
<p class="titlepageinfodescription">B. <a href="#AB">[Non-normative text] </a></p>
<p class="titlepageinfodescription">C. <a href="#AC">Revision History</a> </p>

<div>
<p class="heading1"><a name="A1" id="A1"></a>1. Introduction</p>
<p>[All text is normative unless otherwise labeled.] </p>
<div>
<p class="heading2"><a name="A1-1" id="A1-1"></a>1.1 Terminology</p>
<p> The key words &ldquo;MUST&rdquo;, &ldquo;MUST NOT&rdquo;, &ldquo;REQUIRED&rdquo;, &ldquo;SHALL&rdquo;, &ldquo;SHALL NOT&rdquo;, &ldquo;SHOULD&rdquo;, &ldquo;SHOULD NOT&rdquo;, &ldquo;RECOMMENDED&rdquo;, &ldquo;MAY&rdquo;, and &ldquo;OPTIONAL&rdquo;  are to be interpreted as described in [<a href="#rfc2119" >RFC2119</a>].</p>

</div>
<div>
<p class="heading2"> <a name="A1-2" id="A1-2"></a>1.2 Normative References</p>
<p class="refterm"><a name="rfc2119" id="rfc2119"> [RFC2119]</a> </p>
<p class="ref">S. Bradner, <em>Key words for use in RFCs to Indicate Requirement Levels</em>, <a href="http://www.ietf.org/rfc/rfc2119.txt">http://www.ietf.org/rfc/rfc2119.txt</a>, IETF RFC 2119, March 1997.</p>
<p class="refterm"><a name="insert" id="insert"> [Reference]</a> </p>

<p class="ref">[Full reference citation]</p></div>
<div>
<p class="heading2"> <a name="A1-3" id="A1-3"></a>1.3 Non-Normative References</p>
<p class="refterm"><a name="insert2" id="insert2"> [Reference]</a> </p>
<p class="ref">[Full reference citation]</p></div>
</div>
<div>
<p class="heading1"><a name="A2" id="A2"></a>2. Section Title</p>
<p>[body of standard goes here] </p></div>

<div>
<p class="heading1"><a name="A9" id="A9"></a>#. Conformance</p>
<p>[conformance clauses/statements go here] </p></div>
<div>
<p class="appendixheading1"><a name="AA" id="AA"></a>Appendix A. Acknowledgements</p>
<p>The following individuals have participated in the creation of this specification and are gratefully acknowledged:</p>
<span class="titlepageinfo">Participants:</span>
<p>[list of acknowledgements as determined by Technical Committee chair(s)]</p></div>
<div>
<p class="appendixheading1"><a name="AB" id="AB"></a>Appendix B. Non-Normative Text </p>

<p>[any additional appendices go here]</p>
<p>&nbsp;</p></div>
<div>
<p class="appendixheading1"><a name="AC" id="AC"></a>Appendix C. Revision History </p>
<p>[optional; should NOT be included in OASIS Standards]</p>
<table width="600" border="1">
  <tr>
    <th scope="col">Revision</th>
    <th scope="col">Date</th>

    <th scope="col">Editor</th>
    <th scope="col">Changes Made </th>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>

  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>
<p>&nbsp;</p>
</div>

</body>
</html>
-->
