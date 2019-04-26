#!/usr/bin/env ruby
spec = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift(spec) if File.exist?(spec)
require 'spec/spec_helper'

lib = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(lib) if File.exist?(lib)

require 'fileutils'
require 'tmpdir'

require 'rubygems'
require 'spec'

require 'docbook'

$DEBUG = false

TESTDOCSDIR = File.expand_path(File.join(File.dirname(__FILE__), 'files'))

describe DocBook::Epub do
  before(:all) do
    @tmpdir = File.join(Dir.mktmpdir(), "epubspecreal"); Dir.mkdir(@tmpdir) rescue Errno::EEXIST
    @xml_file = Dir["#{TESTDOCSDIR}/orm*.[0-9][0-9][0-9].xml"].sort_by { rand }.first 
    @epub = DocBook::Epub.new(@xml_file, @tmpdir)
    @epub_file = File.join(@tmpdir, File.basename(@xml_file, ".xml") + ".epub")
    @epub.render_to_file(@epub_file, $DEBUG)

    FileUtils.copy(@epub_file, "." + File.basename(@xml_file, ".xml") + ".epub") if $DEBUG

    @tmpdir2 = File.join(Dir.mktmpdir(), "epubreal"); Dir.mkdir(@tmpdir2) rescue Errno::EEXIST
    success = system(%Q(unzip -q -o -d "#{@tmpdir2}" "#{@epub_file}"))
    raise "Could not unzip #{epub_file}" unless success

    @html_files = Dir.glob(File.join(@tmpdir2, "**", "*.html"))
    @opf_file = Dir.glob(File.join(@tmpdir2, "**", "*.opf")).first
    @opf_lines = File.open(@opf_file).readlines
  end  

  it "should be able to render a valid .epub for the 'Real Book' test document #{@xml_file}" do
    @epub_file.should be_valid_epub  
  end

  it "should include the large cover image in each rendered epub of a 'Real Book' test document like #{@xml_file}" do
    @cover_links = @html_files.find_all {|html_file| File.open(html_file).readlines.to_s =~ /cvr_lrg.jpg/}
    @cover_links.length.should == 1
  end  

  it "should mark the HTML cover as not linear for the 'Real Book' test document #{@xml_file}" do
    @opf_lines.each {|l|
      if l =~ /itemref[^>]+idref=['"]cover['"]/
        l.should =~ /item[^>]+linear=['"]no['"]/
      end  
    }  
  end

  it "should use the cover image @id for the opf/meta[@name='cover'] for the 'Real Book' test document #{@xml_file}" do
    @opf_lines.each {|l|
      if l =~ /meta[^>]+name=['"]cover['"]/
        l.should =~ /meta[^>]+cover-image/
      end  
    }  
  end

  it "should reference the cover in the OPF guide for the 'Real Book' test document #{@xml_file}" do
    @opf_lines.to_s.should =~ /reference[^>]+type=['"]cover['"]/
  end

  it "should use the <isbn> as dc:identifier for the 'Real Book' test document #{@xml_file}" do
    @opf_lines.to_s.should =~ /identifier[^>]+>urn:isbn:[0-9]/
  end

  it "should use the <copyright> as dc:rights for the 'Real Book' test document #{@xml_file}" do
    @opf_lines.to_s.should =~ /:rights[^>]+>Copyright © dddd O/
  end

  it "should use the <publishername> as dc:publisher for the 'Real Book' test document #{@xml_file}" do
    @opf_lines.to_s.should =~ /publisher[^>]+>O'Rxxxxx Mxxxx, Ixx.</
  end

  it "should use the <abstract> as dc:description for the 'Real Book' test document #{@xml_file}" do
    @opf_lines.to_s.should =~ /description[^>]+>This is a great title! Many people love it!</
  end

  it "should use the <date> as dc:date for the 'Real Book' test document #{@xml_file}" do
    @opf_lines.to_s.should =~ /date[^>]+>2008-04-15</
  end

  it "should use the <subjectset> as dc:subject for the 'Real Book' test document #{@xml_file}" do
    @opf_lines.to_s.should =~ /subject[^>]+>COM018000</
  end



  after(:all) do
    FileUtils.rm_r(@tmpdir, :force => true)
    FileUtils.rm_r(@tmpdir2, :force => true)
  end  
end
