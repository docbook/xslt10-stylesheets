all: refentry.007.xml refentry.007.ns.xml

refentry.007.xml: $(repo_dir)/releasetools/refentry.007.xml 
	cp $< $@

refentry.007.ns.xml: $(repo_dir)/releasetools/refentry.007.ns.xml 
	cp $< $@

clean:
	$(RM) refentry.007.xml refentry.007.ns.xml
