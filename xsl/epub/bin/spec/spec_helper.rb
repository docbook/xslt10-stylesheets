lib = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(lib) if File.exist?(lib)

require 'docbook'

# Helper classes
class BeValidEpub
  
  def initialize
  end
  
  def matches?(epubfile)
    invalidity = DocBook::Epub.invalid?(epubfile)
    @message = invalidity
    # remember backward logic here
    if invalidity
      return false
    else
      return true
    end
  end
  
  def description
    "be valid .epub"
  end
  
  def failure_message
   " expected .epub file to be valid, but validation produced these errors:\n #{@message}"
  end
  
  def negative_failure_message
    " expected to not be valid, but was (missing validation?)"
  end
end

def be_valid_epub
  BeValidEpub.new
end


# Helper Functions
def opf_lines(filename, filedir)
  shortname = filename.gsub(/\W/, '')
  tmpdir = File.join(Dir.mktmpdir(), shortname); Dir.mkdir(tmpdir) rescue Errno::EEXIST
  epub = DocBook::Epub.new(File.join(filedir, filename), tmpdir)
  epubfile  = File.join(tmpdir, shortname + ".epub")
  epub.render_to_file(epubfile, $DEBUG)
  FileUtils.copy(epubfile, "." + shortname + ".epub") if $DEBUG
  success = system(%Q(unzip -q -d "#{File.expand_path(tmpdir)}" -o "#{File.expand_path(epubfile)}"))
  raise "Could not unzip #{epubfile}" unless success
  opf_file = Dir.glob(File.join(tmpdir, "**", "*.opf")).first
  opf_lines = File.open(opf_file).readlines
  return opf_lines
end
