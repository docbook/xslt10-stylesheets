# Makefile to demonstrate how to disassemble an existing
# DocBook 5 book into an assembly with topics,
# and then reassemble that into a book.

disassemble:
	-mkdir topics
	xsltproc \
	-o myassembly.xml \
	--stringparam base.dir topics/ \
	../topic-maker-chunk.xsl \
	originalbook.xml


assemble:
	xsltproc \
	-o reassembled.xml \
	../assemble.xsl \
	myassembly.xml


