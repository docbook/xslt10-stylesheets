#!/usr/bin/env ruby
spec = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift(spec) if File.exist?(spec)
require 'spec/spec_helper'

lib = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(lib) if File.exist?(lib)

require 'fileutils'
require 'rexml/document'
require 'tmpdir'

require 'rubygems'
require 'spec'

require 'docbook'

$DEBUG = false


describe DocBook::Epub do
  before(:all) do
    @filedir = File.expand_path(File.join(File.dirname(__FILE__), 'files'))
    @testdocsdir = File.expand_path(File.join(ENV['repo_dir'], 'testdocs', 'tests'))
    @tmpdir = File.join(Dir.mktmpdir(), "epubregressions"); Dir.mkdir(@tmpdir) rescue Errno::EEXIST
  end

  it "should not include two <itemref>s to the contents of <part>s in the OPF file" do
    part_file = File.join(@testdocsdir, "subtitle.001.xml") 
    epub_file = File.join(@tmpdir, File.basename(part_file, ".xml") + ".epub")
    part_epub = DocBook::Epub.new(part_file, @tmpdir)
    part_epub.render_to_file(epub_file, $DEBUG)

    FileUtils.copy(epub_file, "./.t.epub") if $DEBUG

    itemref_tmpdir = File.join(Dir.mktmpdir(), "epubitemref"); Dir.mkdir(itemref_tmpdir) rescue Errno::EEXIST
    system(%Q(unzip -q -o -d "#{itemref_tmpdir}" "#{epub_file}"))
    opf_file = File.join(itemref_tmpdir, "OEBPS", "content.opf")
    opf = REXML::Document.new(File.new(opf_file))

    itemrefs = REXML::XPath.match(opf, "//itemref").map {|e| e.attributes['idref']}
    itemrefs.should == itemrefs.uniq
  end

  it "should preserve content from <dedication> elements" do
    begin
      tmpdir = File.join(Dir.mktmpdir(), "epubdedtest"); Dir.mkdir(tmpdir) rescue Errno::EEXIST
      
      epub = DocBook::Epub.new(File.join(@testdocsdir, "xref.001.xml"), @tmpdir)
      epubfile = File.join(tmpdir, "regress.ded.epub")
      epub.render_to_file(epubfile, $DEBUG)
      FileUtils.copy(epubfile, ".re.ded.epub") if $DEBUG

      success = system(%Q(unzip -q -d "#{File.expand_path(tmpdir)}" -o "#{epubfile}"))
      raise "Could not unzip #{epubfile}" unless success
      glob = Dir.glob(File.join(tmpdir, "**", "*.opf"))
      index_html_links = glob.find_all {|opf_file| File.open(opf_file).readlines.to_s =~ /href=["']index.html["']/}
      index_html_links.should_not be_empty
    rescue => e
      raise e
    ensure
      FileUtils.rm_r(tmpdir, :force => true)
    end  
  end

  it "should use the correct mimetype for CSS files" do
    begin
      css_file_base = "test.css"
      css_file = File.join(@filedir, css_file_base)
      css_epub = DocBook::Epub.new(File.join(@testdocsdir, "book.002.xml"), @tmpdir, css_file)
      css_epubfile = File.join(@tmpdir, "css.epub")
      css_epub.render_to_file(css_epubfile, $DEBUG)

      tmpdir = File.join(Dir.mktmpdir(), "epubcssreg"); Dir.mkdir(tmpdir) rescue Errno::EEXIST

      success = system(%Q(unzip -q -d "#{File.expand_path(tmpdir)}" -o "#{css_epubfile}"))
      raise "Could not unzip #{css_epubfile}" unless success
      opf_files = Dir.glob(File.join(tmpdir, "**", "*.opf"))
      opf_files.find_all {|opf_file| 
        File.open(opf_file).readlines.to_s.should_not =~ /media-type=.test\/css/
      }  
    rescue => e
      raise e
    ensure
      FileUtils.rm_r(tmpdir, :force => true)
    end  
  end  

  it "should not include an XHTML DOCTYPE in the OPF file" do
    part_file = File.join(@testdocsdir, "subtitle.001.xml") 
    epub_file = File.join(@tmpdir, File.basename(part_file, ".xml") + ".epub")
    part_epub = DocBook::Epub.new(part_file, @tmpdir)
    part_epub.render_to_file(epub_file, $DEBUG)

    FileUtils.copy(epub_file, "./.doctype.epub") if $DEBUG

    xhtml_dtd = "DTD XHTML 1.1"

    itemref_tmpdir = File.join(Dir.mktmpdir(), "epubitemref"); Dir.mkdir(itemref_tmpdir) rescue Errno::EEXIST
    system(%Q(unzip -q -o -d "#{itemref_tmpdir}" "#{epub_file}"))

    opf_file = File.join(itemref_tmpdir, "OEBPS", "content.opf")
    xhtml_dtd_in_opf_file = system(%Q(grep "#{xhtml_dtd}" "#{opf_file}"))
    xhtml_dtd_in_opf_file.should_not be_true
  end

  it "should reference a cover in the OPF guide for a DocBook 5.0 test document" do
    opf_lns = opf_lines('v5cover.xml', @filedir)
    opf_lns.to_s.should =~ /reference[^>]+type=['"]cover['"]/
  end

  it "should allow pre elements inside blockquotes" do
    blockquotepre_epub = DocBook::Epub.new(File.join(@filedir, "blockquotepre.xml"), @tmpdir)
    blockquotepre_epubfile  = File.join(@tmpdir, "blockquotepreepub.epub")
    blockquotepre_epub.render_to_file(blockquotepre_epubfile, $DEBUG)
    blockquotepre_epubfile.should be_valid_epub  
  end

  it "should render refentry/refclass without duplicating <p>s" do
    refclass_epub = DocBook::Epub.new(File.join(@filedir, "refclass.xml"), @tmpdir)
    refclass_epubfile  = File.join(@tmpdir, "refclassepub.epub")
    refclass_epub.render_to_file(refclass_epubfile, $DEBUG)
    refclass_epubfile.should be_valid_epub  
  end

  it "should not use namespace prefixes for the OPF manifest because mobigen is unable of handling XML input" do
    opf_lns = opf_lines('refclass.xml', @filedir)
    opf_lns.to_s.should_not =~ /opf:manifest/
  end

  it "should use the @lang of the document being converted for the OPF metadata" do
    opf_lns = opf_lines('de.xml', @filedir)
    opf_lns.to_s.should =~ /language[^>]*>de</
  end

  it "should include images from &entity; and XInclude'd documents" do
    opf_lns = opf_lines('xincludeents.xml', @filedir)
    opf_lns.to_s.should =~ /stamp.png/
    opf_lns.to_s.should =~ /duck-small.png/
    opf_lns.to_s.should_not =~ /duck-small.gif/ # Choose one, not both
    xincludeents_epub = DocBook::Epub.new(File.join(@filedir, "xincludeents.xml"), @tmpdir)
    xincludeents_epubfile  = File.join(@tmpdir, "xincludeentsepub.epub")
    xincludeents_epub.render_to_file(xincludeents_epubfile, $DEBUG)
    xincludeents_epubfile.should be_valid_epub  
  end

  it "should not warn about named &entity;s" do
    ents_epub = DocBook::Epub.new(File.join(@filedir, "entity.xml"), @tmpdir)
    ents_epubfile  = File.join(@tmpdir, "entsepub.epub")
    ents_epub.render_to_file(ents_epubfile, $DEBUG)
    ents_epubfile.should be_valid_epub  
  end

  # https://sourceforge.net/tracker/index.php?func=detail&aid=2790017&group_id=21935&atid=373747
  it "should not use a namespace prefix for the container element to help some broken reading systems" do
    filename = "isbn.xml"
    shortname = filename.gsub(/\W/, '')
    tmpdir = File.join(Dir.mktmpdir(), shortname); Dir.mkdir(tmpdir) rescue Errno::EEXIST
    epub = DocBook::Epub.new(File.join(@filedir, filename), tmpdir)
    epubfile  = File.join(tmpdir, shortname + ".epub")
    epub.render_to_file(epubfile, $DEBUG)
    FileUtils.copy(epubfile, "." + shortname + ".epub") if $DEBUG
    success = system(%Q(unzip -q -d "#{File.expand_path(tmpdir)}" -o "#{File.expand_path(epubfile)}"))
    raise "Could not unzip #{epubfile}" unless success
    container_file = File.join(tmpdir, 'META-INF', 'container.xml')
    container_lines = File.open(container_file).readlines
    container_lines.to_s.should =~ /<container/
  end

  it "should not include an index entry for Symbols when using @types and the symbols are not a part of that @type" do
    css_file = nil
    index_on_type_customization_layer = File.join(@filedir, "test_cust.xsl")
    typed_index_epub = DocBook::Epub.new(File.join(@filedir, "index.with.symbol.and.type.xml"), @tmpdir, css_file, index_on_type_customization_layer)
    typed_index_epubfile  = File.join(@tmpdir, "typed_indexepub.epub")
    typed_index_epub.render_to_file(typed_index_epubfile, $DEBUG)
    typed_index_epubfile.should be_valid_epub  
  end

  it "should include chunked refentries in the spine even when they're deeply nested" do
    opf_lns = opf_lines('orm.book.001.xml', @filedir)
    re01_id = opf_lns.to_s.sub(/.+<item id="([^"]+)" href="re01.html".+/m, '\1')
    opf_lns.to_s.should =~ /<itemref idref="#{re01_id}"/
  end

  it "should include chunked refentries in the spine in the correct order and adjacency even when they're deeply nested" do
    opf_lns = opf_lines('orm.book.001.xml', @filedir)
    before_refentry_id = opf_lns.to_s.sub(/.+<item id="([^"]+)" href="apa.html".+/m, '\1')
    re01_id = opf_lns.to_s.sub(/.+<item id="([^"]+)" href="re01.html".+/m, '\1')
    re02_id = opf_lns.to_s.sub(/.+<item id="([^"]+)" href="re02.html".+/m, '\1')
    opf_lns.to_s.should =~ /<itemref idref="#{before_refentry_id}"[^>]*[^<]*<itemref idref="#{re01_id}"[^>]*>[^<]*<itemref idref="#{re02_id}"/m
  end

  it "should not include font style elements like <b> or <i>" do
    begin
      tmpdir = File.join(Dir.mktmpdir(), "epubbtest"); Dir.mkdir(tmpdir) rescue Errno::EEXIST
      
      epub = DocBook::Epub.new(File.join(@testdocsdir, "book.002.xml"), @tmpdir)
      epubfile = File.join(tmpdir, "bcount.epub")
      epub.render_to_file(epubfile, $DEBUG)
      FileUtils.copy(epubfile, ".b.epub") if $DEBUG

      success = system(%Q(unzip -q -d "#{File.expand_path(tmpdir)}" -o "#{epubfile}"))
      raise "Could not unzip #{epubfile}" unless success
      glob = Dir.glob(File.join(tmpdir, "**", "*.html"))
      glob.each {|html_file| 
        bs = File.open(html_file).readlines.to_s.scan(/<b>/)
        bs.should be_empty
        is = File.open(html_file).readlines.to_s.scan(/<i>/)
        is.should be_empty
      }
    rescue => e
      raise e
    ensure
      FileUtils.rm_r(tmpdir, :force => true)
    end  
  end  

  it "should allow sect2s inside partintros" do
    partintro_epub = DocBook::Epub.new(File.join(@filedir, "partintro.xml"), @tmpdir)
    partintro_epubfile  = File.join(@tmpdir, "partintro.epub")
    partintro_epub.render_to_file(partintro_epubfile, $DEBUG)
    partintro_epubfile.should be_valid_epub  
  end

  it "should create NCX documents using a default namespace" do
    ncx_epub = DocBook::Epub.new(File.join(@filedir, "partintro.xml"), @tmpdir)
    ncx_epubfile  = File.join(@tmpdir, "ncx.epub")
    ncx_epub.render_to_file(ncx_epubfile, $DEBUG)
    ncx_epubfile.should be_valid_epub  

    ncx_tmpdir = File.join(Dir.mktmpdir(), "epubncx"); Dir.mkdir(ncx_tmpdir) rescue Errno::EEXIST
    system(%Q(unzip -q -o -d "#{ncx_tmpdir}" "#{ncx_epubfile}"))

    ncx_file = File.join(ncx_tmpdir, "OEBPS", "toc.ncx")
    ncx_default = '<ncx '

    ncx_in_default_ns = system(%Q(grep "#{ncx_default}" "#{ncx_file}"))
    ncx_in_default_ns.should be_true
  end

  after(:all) do
    FileUtils.rm_r(@tmpdir, :force => true)
  end  
end
