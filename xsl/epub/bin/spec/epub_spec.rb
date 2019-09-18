#!/usr/bin/env ruby
spec = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift(spec) if File.exist?(spec)
require 'spec/spec_helper'

lib = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(lib) if File.exist?(lib)

require 'tmpdir'
require 'fileutils'

require 'rubygems'
require 'spec'

require 'docbook'

$DEBUG = false


describe DocBook::Epub do
  before(:all) do
    @filedir = File.expand_path(File.join(File.dirname(__FILE__), 'files'))
    @testdocsdir = File.expand_path(File.join(ENV['repo_dir'], 'testdocs', 'tests'))
    exampledir = File.expand_path(File.join(File.dirname(__FILE__), 'examples'))
    @valid_epub = File.join(exampledir, "AMasqueOfDays.epub")
    @tmpdir = File.join(Dir.mktmpdir(), "epubspec"); Dir.mkdir(@tmpdir) rescue Errno::EEXIST


    @simple_bookfile = File.join(@testdocsdir, "book.001.xml")
    @simple_epub = DocBook::Epub.new(@simple_bookfile, @tmpdir)
    @simple_epubfile  = File.join(@tmpdir, "testepub.epub")
    @simple_epub.render_to_file(@simple_epubfile, $DEBUG)

    @manygraphic_epub = DocBook::Epub.new(File.join(@filedir, "manygraphics.xml"), @tmpdir)
    @manygraphic_epubfile  = File.join(@tmpdir, "manygraphicepub.epub")
    @manygraphic_epub.render_to_file(@manygraphic_epubfile, $DEBUG)

    @css_file_base = "test.css"
    @css_file = File.join(@filedir, @css_file_base)
    customization_layer = nil
    @embedded_font_file_base = "DejaVuSerif.otf"
    @embedded_font_file2_base = "DejaVuSerif-Italic.otf"
    @embedded_fonts = [File.join(@filedir, @embedded_font_file_base),
                       File.join(@filedir, @embedded_font_file2_base),
                      ]
    @css_epub = DocBook::Epub.new(File.join(@testdocsdir, "book.002.xml"), @tmpdir, @css_file, customization_layer, @embedded_fonts)
    @css_epubfile = File.join(@tmpdir, "css.epub")
    @css_epub.render_to_file(@css_epubfile, $DEBUG)

    FileUtils.copy(@css_epubfile, ".css.epub") if $DEBUG
    FileUtils.copy(@simple_epubfile, ".t.epub") if $DEBUG
    FileUtils.copy(@manygraphic_epubfile, ".mg.epub") if $DEBUG
  end

  it "should be able to be created" do
    lambda {
      DocBook::Epub.new(@simple_bookfile)
    }.should_not raise_error
  end

  it "should fail on a nonexistent file" do
    dne = "thisfiledoesnotexist.dex"
    lambda {
      DocBook::Epub.new(dne)
    }.should raise_error(ArgumentError)
  end  

  it "should be able to render to a file" do
    @simple_epub.should respond_to(:render_to_file)
  end

  it "should create a file after rendering" do
    @simple_epubfile.should satisfy {|rse| File.exist?(rse)}
  end

  it "should have the correct mimetype after rendering" do
    header = File.read(@simple_epubfile, 200)
    regex = Regexp.quote(DocBook::Epub::MIMETYPE)
    header.should match(/#{regex}/)
  end     

  it "should be valid .epub after rendering an article" do
    article_epub = DocBook::Epub.new(File.join(@testdocsdir, "article.006.xml"), @tmpdir)
    article_epubfile  = File.join(@tmpdir, "testartepub.epub")
    article_epub.render_to_file(article_epubfile, $DEBUG)
    article_epubfile.should be_valid_epub  

    FileUtils.copy(article_epubfile, ".a.epub") if $DEBUG
  end

  it "should be valid .epub after rendering an article without sections" do
    article_nosects_epub = DocBook::Epub.new(File.join(@testdocsdir, "admonitions.001.xml"), @tmpdir)
    article_nosects_epubfile = File.join(@tmpdir, "nosects.epub")
    article_nosects_epub.render_to_file(article_nosects_epubfile, $DEBUG)
    FileUtils.copy(article_nosects_epubfile, ".as.epub") if $DEBUG

    article_nosects_epubfile.should be_valid_epub  
  end


  it "should be valid .epub after rendering a book" do
    @simple_epubfile.should be_valid_epub  
  end

  it "should be valid .epub after rendering a book even if it has one graphic" do
    graphic_epub = DocBook::Epub.new(File.join(@filedir, "onegraphic.xml"), @tmpdir)
    graphic_epubfile  = File.join(@tmpdir, "graphicepub.epub")
    graphic_epub.render_to_file(graphic_epubfile, $DEBUG)

    FileUtils.copy(graphic_epubfile, ".g.epub") if $DEBUG

    graphic_epubfile.should be_valid_epub  
  end

  it "should be valid .epub after rendering a book even if it has many graphics" do
    @manygraphic_epubfile.should be_valid_epub  
  end

  it "should be valid .epub after rendering a book even if it has many duplicated graphics" do
    dupedgraphic_epub = DocBook::Epub.new(File.join(@filedir, "dupedgraphics.xml"), @tmpdir)
    dupedgraphic_epubfile  = File.join(@tmpdir, "dupedgraphicepub.epub")
    dupedgraphic_epub.render_to_file(dupedgraphic_epubfile, $DEBUG)
    FileUtils.copy(dupedgraphic_epubfile, ".duped.epub") if $DEBUG

    dupedgraphic_epubfile.should be_valid_epub  
  end


  it "should report an empty file as invalid" do
    tmpfile = File.join(@tmpdir, "testepub.epub")
    begin
      File.open(tmpfile, "w") {|f| f.puts }  
      tmpfile.should satisfy {|dbf| DocBook::Epub.invalid?(dbf)}
    ensure
      File.delete(tmpfile) rescue Errno::ENOENT
    end  
  end

  it "should confirm that a valid .epub file is valid" do
    @valid_epub.should_not satisfy {|ve| DocBook::Epub.invalid?(ve)}
  end

  it "should include at least one dc:identifier" do
    # TODO Consider UUID
    opf_lns = opf_lines('nogoodid.xml', @filedir)
    opf_lns.to_s.should =~ /identifier[^>]+>[^<][^_<]+</
  end

  it "should include an ISBN as URN for dc:identifier if an ISBN was in the metadata" do
    opf_lns = opf_lines('isbn.xml', @filedir)
    opf_lns.to_s.should =~ /identifier[^>]+>urn:isbn:123456789X</
  end

  it "should include an ISSN as URN for dc:identifier if an ISSN was in the metadata" do
    opf_lns = opf_lines('issn.xml', @filedir)
    opf_lns.to_s.should =~ /identifier[^>]+>urn:issn:X987654321</
  end

  it "should include an biblioid as a dc:identifier if an biblioid was in the metadata" do
    opf_lns = opf_lines('biblioid.xml', @filedir)
    opf_lns.to_s.should =~ /identifier[^>]+>thebiblioid</
  end

  it "should include a URN for a biblioid with @class attribute as a dc:identifier if an biblioid was in the metadata" do
    opf_lns = opf_lines('biblioid.doi.xml', @filedir)
    opf_lns.to_s.should =~ /identifier[^>]+>urn:doi:thedoi</
  end

  it "should not include PDFs in rendered epub files as valid image inclusions" do
    begin
      tmpdir = File.join(Dir.mktmpdir(), "epubinclusiontest"); Dir.mkdir(tmpdir) rescue Errno::EEXIST

      success = system(%Q(unzip -q -d "#{File.expand_path(tmpdir)}" -o "#{File.expand_path(@manygraphic_epubfile)}"))
      raise "Could not unzip #{@manygraphic_epubfile}" unless success
      glob = Dir.glob(File.join(tmpdir, "**", "*.*"))
      pdfs_in_glob = glob.find_all {|file| file =~ /\.pdf/i}
      pdfs_in_glob.should be_empty
    rescue => e
      raise e
    ensure
      FileUtils.rm_r(tmpdir, :force => true)
    end  
  end

  it "should include a CSS link in HTML files when a CSS file has been provided" do
    begin
      tmpdir = File.join(Dir.mktmpdir(), "epubcsshtmltest"); Dir.mkdir(tmpdir) rescue Errno::EEXIST

      success = system(%Q(unzip -q -d "#{File.expand_path(tmpdir)}" -o "#{@css_epubfile}"))
      raise "Could not unzip #{@css_epubfile}" unless success
      html_files = Dir.glob(File.join(tmpdir, "**", "*.html"))
      html_links = html_files.find_all {|html_file| File.open(html_file).readlines.to_s =~ /<link [^>]*#{@css_file_base}/}
      html_links.size.should == html_files.size
    rescue => e
      raise e
    ensure
      FileUtils.rm_r(tmpdir, :force => true)
    end
  end

  it "should include CSS file in .epub when a CSS file has been provided" do
    begin
      tmpdir = File.join(Dir.mktmpdir(), "epubcssfiletest"); Dir.mkdir(tmpdir) rescue Errno::EEXIST

      success = system(%Q(unzip -q -d "#{File.expand_path(tmpdir)}" -o "#{@css_epubfile}"))
      raise "Could not unzip #{@css_epubfile}" unless success
      css_files = Dir.glob(File.join(tmpdir, "**", "*.css"))
      css_files.should_not be_empty
    rescue => e
      raise e
    ensure
      FileUtils.rm_r(tmpdir, :force => true)
    end
  end

  it "should include a reference in the OPF manifest to the provided CSS file" do
    begin
      tmpdir = File.join(Dir.mktmpdir(), "epubcsshtmltest"); Dir.mkdir(tmpdir) rescue Errno::EEXIST
      
      success = system(%Q(unzip -q -d "#{File.expand_path(tmpdir)}" -o "#{@css_epubfile}"))
      raise "Could not unzip #{@css_epubfile}" unless success
      opf_files = Dir.glob(File.join(tmpdir, "**", "*.opf"))
      opf_links = opf_files.find_all {|opf_file| File.open(opf_file).readlines.to_s =~ /<(opf:item|item) [^>]*#{@css_file_base}/}
      opf_links.should_not be_empty
    rescue => e
      raise e
    ensure
      FileUtils.rm_r(tmpdir, :force => true)
    end
  end

  it "should include a reference in the OPF manifest to the embedded font" do
    begin
      tmpdir = File.join(Dir.mktmpdir(), "epubfontman"); Dir.mkdir(tmpdir) rescue Errno::EEXIST
      
      success = system(%Q(unzip -q -d "#{File.expand_path(tmpdir)}" -o "#{@css_epubfile}"))
      raise "Could not unzip #{@css_epubfile}" unless success
      opf_files = Dir.glob(File.join(tmpdir, "**", "*.opf"))

      @embedded_fonts.each {|font|
        opf_links = opf_files.find_all {|opf_file| File.open(opf_file).readlines.to_s =~ /<(opf:item|item) [^>]*#{File.basename(font)}/}
        opf_links.should_not be_empty
      }  
    rescue => e
      raise e
    ensure
      FileUtils.rm_r(tmpdir, :force => true)
    end
  end

  it "should include the embedded font file in the bundle" do
    begin
      tmpdir = File.join(Dir.mktmpdir(), "epubfontbundle"); Dir.mkdir(tmpdir) rescue Errno::EEXIST
      
      success = system(%Q(unzip -q -d "#{File.expand_path(tmpdir)}" -o "#{@css_epubfile}"))
      raise "Could not unzip #{@css_epubfile}" unless success
      @embedded_fonts.each {|font|
        font_files = Dir.glob(File.join(tmpdir, "**", File.basename(font)))
        font_files.should_not be_empty
      }  
    rescue => e
      raise e
    ensure
      FileUtils.rm_r(tmpdir, :force => true)
    end
  end

  it "should be valid .epub after including more than one embedded font" do
    @css_epubfile.should be_valid_epub
  end

  it "should include one and only one <h1> in each HTML file in rendered ePub files for <book>s" do
    begin
      tmpdir = File.join(Dir.mktmpdir(), "epubtoctest"); Dir.mkdir(tmpdir) rescue Errno::EEXIST
      
      epub = DocBook::Epub.new(File.join(@testdocsdir, "book.002.xml"), @tmpdir)
      epubfile = File.join(tmpdir, "h1count.epub")
      epub.render_to_file(epubfile, $DEBUG)
      FileUtils.copy(epubfile, ".h1c.epub") if $DEBUG

      success = system(%Q(unzip -q -d "#{File.expand_path(tmpdir)}" -o "#{epubfile}"))
      raise "Could not unzip #{epubfile}" unless success
      glob = Dir.glob(File.join(tmpdir, "**", "*.html"))
      glob.each {|html_file| 
        h1s = File.open(html_file).readlines.to_s.scan(/<h1/)
        puts html_file if $DEBUG && h1s.length != 1 
        h1s.length.should == 1
      }
    rescue => e
      raise e
    ensure
      FileUtils.rm_r(tmpdir, :force => true)
    end  
  end

  it "should include one and only one <h1> in each HTML file in rendered ePub files for <book>s even if they do not have section markup" do
    begin
      tmpdir = File.join(Dir.mktmpdir(), "epubtoctest"); Dir.mkdir(tmpdir) rescue Errno::EEXIST
      
      epub = DocBook::Epub.new(File.join(@testdocsdir, "book.002.xml"), @tmpdir)
      epubfile = File.join(tmpdir, "h1count2.epub")
      epub.render_to_file(epubfile, $DEBUG)
      FileUtils.copy(epubfile, ".h1c2.epub") if $DEBUG

      success = system(%Q(unzip -q -d "#{File.expand_path(tmpdir)}" -o "#{epubfile}"))
      raise "Could not unzip #{epubfile}" unless success
      glob = Dir.glob(File.join(tmpdir, "**", "*.html"))
      glob.each {|html_file| 
        h1s = File.open(html_file).readlines.to_s.scan(/<h1/)
        puts html_file if $DEBUG && h1s.length != 1 
        h1s.length.should == 1
      }
    rescue => e
      raise e
    ensure
      FileUtils.rm_r(tmpdir, :force => true)
    end  
  end

  it "should include a TOC link in rendered epub files for <book>s" do
    begin
      tmpdir = File.join(Dir.mktmpdir(), "epubtoctest"); Dir.mkdir(tmpdir) rescue Errno::EEXIST
      
      epub = DocBook::Epub.new(File.join(@testdocsdir, "book.002.xml"), @tmpdir)
      epubfile = File.join(tmpdir, "toclink.epub")
      epub.render_to_file(epubfile, $DEBUG)
      FileUtils.copy(epubfile, ".tcl.epub") if $DEBUG

      success = system(%Q(unzip -q -d "#{File.expand_path(tmpdir)}" -o "#{epubfile}"))
      raise "Could not unzip #{epubfile}" unless success
      glob = Dir.glob(File.join(tmpdir, "**", "*.opf"))
      toc_links = glob.find_all {|opf_file| File.open(opf_file).readlines.to_s =~ /type=["']toc["']/}
      puts File.open(glob.first).readlines.to_s if $DEBUG
      toc_links.should_not be_empty
    rescue => e
      raise e
    ensure
      FileUtils.rm_r(tmpdir, :force => true)
    end  
  end

  it "should allow for the stylesheets to be overridden by a customization layer" do
    begin
      tmpdir = File.join(Dir.mktmpdir(), "epubcusttest"); Dir.mkdir(tmpdir) rescue Errno::EEXIST
      
      css_file = nil
      customization_layer = File.join(@filedir, "test_cust.xsl")
      epub = DocBook::Epub.new(File.join(@testdocsdir, "xref.001.xml"), @tmpdir, css_file, customization_layer)
      epubfile = File.join(tmpdir, "cust.epub")
      epub.render_to_file(epubfile, $DEBUG)
      FileUtils.copy(epubfile, ".cust.epub") if $DEBUG

      success = system(%Q(unzip -q -d "#{File.expand_path(tmpdir)}" -o "#{epubfile}"))
      raise "Could not unzip #{epubfile}" unless success
      glob = Dir.glob(File.join(tmpdir, "**", "*.html")) 
      # The customization layer changes the style of cross references to _not_
      # include the title, so it should only appear in the part file and the
      # TOC
      files_including_part_title = glob.find_all {|html_file| File.open(html_file).readlines.to_s =~ />[^<]*Part One Title/}
      p files_including_part_title if $DEBUG
      files_including_part_title.length.should == 2
    rescue => e
      raise e
    ensure
      FileUtils.rm_r(tmpdir, :force => true)
    end  
  end

  after(:all) do
    FileUtils.rm_r(@tmpdir, :force => true)
  end  
end
