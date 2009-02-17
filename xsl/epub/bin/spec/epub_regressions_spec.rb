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
    @testdocsdir = File.expand_path(File.join(ENV['DOCBOOK_SVN'], 'testdocs', 'tests'))
    @tmpdir = File.join(Dir::tmpdir(), "epubregressions"); Dir.mkdir(@tmpdir) rescue Errno::EEXIST
  end

  it "should not include two <itemref>s to the contents of <part>s in the OPF file" do
    part_file = File.join(@testdocsdir, "subtitle.001.xml") 
    epub_file = File.join(@tmpdir, File.basename(part_file, ".xml") + ".epub")
    part_epub = DocBook::Epub.new(part_file, @tmpdir)
    part_epub.render_to_file(epub_file, $DEBUG)

    FileUtils.copy(epub_file, "./.t.epub") if $DEBUG

    itemref_tmpdir = File.join(Dir::tmpdir(), "epubitemref"); Dir.mkdir(itemref_tmpdir) rescue Errno::EEXIST
    system("unzip -q -o -d #{itemref_tmpdir} #{epub_file}")
    opf_file = File.join(itemref_tmpdir, "OEBPS", "content.opf")
    opf = REXML::Document.new(File.new(opf_file))

    itemrefs = REXML::XPath.match(opf, "//itemref").map {|e| e.attributes['idref']}
    itemrefs.should == itemrefs.uniq
  end

  it "should preserve content from <dedication> elements" do
    begin
      tmpdir = File.join(Dir::tmpdir(), "epubdedtest"); Dir.mkdir(tmpdir) rescue Errno::EEXIST
      
      epub = DocBook::Epub.new(File.join(@testdocsdir, "xref.001.xml"), @tmpdir)
      epubfile = File.join(tmpdir, "regress.ded.epub")
      epub.render_to_file(epubfile, $DEBUG)
      FileUtils.copy(epubfile, ".re.ded.epub") if $DEBUG

      success = system("unzip -q -d #{File.expand_path(tmpdir)} -o #{epubfile}")
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

      tmpdir = File.join(Dir::tmpdir(), "epubcssreg"); Dir.mkdir(tmpdir) rescue Errno::EEXIST

      success = system("unzip -q -d #{File.expand_path(tmpdir)} -o #{css_epubfile}")
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

    itemref_tmpdir = File.join(Dir::tmpdir(), "epubitemref"); Dir.mkdir(itemref_tmpdir) rescue Errno::EEXIST
    system("unzip -q -o -d #{itemref_tmpdir} #{epub_file}")

    opf_file = File.join(itemref_tmpdir, "OEBPS", "content.opf")
    xhtml_dtd_in_opf_file = system("grep '#{xhtml_dtd}' #{opf_file}")
    xhtml_dtd_in_opf_file.should_not be_true
  end

  it "should reference a cover in the OPF guide for a DocBook 5.0 test document" do
    opf_lns = opf_lines('v5cover.xml', @filedir)
    opf_lns.to_s.should =~ /reference[^>]+type=['"]cover['"]/
  end

  after(:all) do
    FileUtils.rm_r(@tmpdir, :force => true)
  end  
end
