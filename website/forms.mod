<!-- ====================================================================== -->
<!-- Website DTD Forms Module V1.7
     Part of the Website DTD
     http://nwalsh.com/website/

     See COPYRIGHT for more information

     Please direct all questions and comments about this DTD to
     Norman Walsh, <ndw@nwalsh.com>.
                                                                            -->
<!-- ====================================================================== -->

<!ENTITY % events
 "onclick		CDATA		#IMPLIED
  ondblclick		CDATA		#IMPLIED
  onmousedown		CDATA		#IMPLIED
  onmouseup		CDATA		#IMPLIED
  onmouseover		CDATA		#IMPLIED
  onmousemove		CDATA		#IMPLIED
  onmouseout		CDATA		#IMPLIED
  onkeypress		CDATA		#IMPLIED
  onkeydown		CDATA		#IMPLIED
  onkeyup		CDATA		#IMPLIED"
>

<!ELEMENT html:form ((%component.mix;)|html:input|html:button
			|html:label|html:select|html:textarea)+>

<!ATTLIST html:form
	%common.attrib;
	%events;
	action		CDATA		#REQUIRED
	method		(GET|POST)	"GET"
	onsubmit	CDATA		#IMPLIED
	onreset		CDATA		#IMPLIED
>

<!ENTITY % inputtype  "(text | password | checkbox | radio
                       | submit | reset | file | hidden | image | button)">

<!ELEMENT html:input EMPTY>
<!ATTLIST html:input
	%common.attrib;
	%events;
	type		%inputtype;	"text"
	name		CDATA		#IMPLIED
	value		CDATA		#IMPLIED
	checked		(checked)	#IMPLIED
	disabled	(disabled)	#IMPLIED
	readonly	(readonly)	#IMPLIED
	size		CDATA		#IMPLIED
	maxlength	CDATA		#IMPLIED
	src		CDATA		#IMPLIED
	alt		CDATA		#IMPLIED
	usemap		CDATA		#IMPLIED
	tabindex	CDATA		#IMPLIED
	accesskey	CDATA		#IMPLIED
	onfocus		CDATA		#IMPLIED
	onblur		CDATA		#IMPLIED
	onselect	CDATA		#IMPLIED
	onchange	CDATA		#IMPLIED
>

<!ELEMENT html:button (%para.char.mix;)*>
<!ATTLIST html:button
	%common.attrib;
	%events;
	name		CDATA		#IMPLIED
	value		CDATA		#IMPLIED
	type		(button|submit|reset)	"submit"
	disabled	(disabled)	#IMPLIED
	tabindex	CDATA		#IMPLIED
	accesskey	CDATA		#IMPLIED
	onfocus		CDATA		#IMPLIED
	onblur		CDATA		#IMPLIED
>

<!ELEMENT html:label (%para.char.mix;)*>
<!ATTLIST html:label
	%common.attrib;
	%events;
	for		IDREF		#IMPLIED
	accesskey	CDATA		#IMPLIED
	onfocus		CDATA		#IMPLIED
	onblur		CDATA		#IMPLIED
>

<!ELEMENT html:select (html:option)+>
<!ATTLIST html:select
	%common.attrib;
	%events;
	name		CDATA		#IMPLIED
	size		CDATA		#IMPLIED
	multiple	(multiple)	#IMPLIED
	disabled	(disabled)	#IMPLIED
	tabindex	CDATA		#IMPLIED
	onfocus		CDATA		#IMPLIED
	onblur		CDATA		#IMPLIED
	onchange	CDATA		#IMPLIED
>

<!ELEMENT html:option (#PCDATA)>
<!ATTLIST html:option
	%common.attrib;
	%events;
	selected    	(selected)	#IMPLIED
	disabled    	(disabled)	#IMPLIED
	value		CDATA		#IMPLIED
>

<!ELEMENT html:textarea (#PCDATA)>
<!ATTLIST html:textarea
	%common.attrib;
	%events;
	name		CDATA		#IMPLIED
	rows		CDATA		#REQUIRED
	cols		CDATA		#REQUIRED
	disabled	(disabled)	#IMPLIED
	readonly	(readonly)	#IMPLIED
	tabindex	CDATA		#IMPLIED
	accesskey	CDATA		#IMPLIED
	onfocus		CDATA		#IMPLIED
	onblur		CDATA		#IMPLIED
	onselect	CDATA		#IMPLIED
	onchange	CDATA		#IMPLIED
>

<!-- End of forms.mod V1.7 ................................................ -->
<!-- ...................................................................... -->
