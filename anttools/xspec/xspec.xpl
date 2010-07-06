<?xml version="1.0" encoding="UTF-8"?>
<p:pipeline xmlns:p="http://www.w3.org/ns/xproc"
	xmlns:c="http://www.w3.org/ns/xproc-step"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:t="http://www.jenitennison.com/xslt/xspec"
	name="xspec" type="t:xspec">
	
	<p:documentation>
		<p>This pipeline executes an XSpec test.</p>
		<p><b>Primary input:</b> A XSpec test document.</p>
		<p><b>Primary output:</b> A formatted HTML XSpec report.</p>
	</p:documentation>
	
	<p:serialization port="result" encoding="ISO-8859-1" indent="true"/>
	
	<p:xslt name="create-test-stylesheet">
		<p:input port="stylesheet">
			<p:document href="generate-xspec-tests.xsl"/>
		</p:input>
	</p:xslt>
	
	<p:xslt name="run-tests" template-name="t:main">
		<p:input port="source">
			<p:pipe step="xspec" port="source"/>
		</p:input>
		<p:input port="stylesheet">
			<p:pipe step="create-test-stylesheet" port="result"/>
		</p:input>
	</p:xslt>
	
	<p:xslt name="format-report">
		<p:input port="stylesheet">
			<p:document href="format-xspec-report.xsl"/>
		</p:input>
	</p:xslt>
	
</p:pipeline>