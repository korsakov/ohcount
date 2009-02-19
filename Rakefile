require 'rake'
require 'rake/clean'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rake/testtask'
require 'rbconfig'
include Config

NAME = 'ohcount'
VERS = '2.0.1'

EXT_DIR  = "ext/ohcount_native"
EXT_DL   = "#{EXT_DIR}/ohcount_native.#{CONFIG['DLEXT']}"
ARCH_DIR = "lib/#{::Config::CONFIG['arch']}"
ARCH_DL  = "#{ARCH_DIR}/ohcount_native.#{CONFIG['DLEXT']}"

RAGEL_DIR = File.join(EXT_DIR, 'ragel_parsers')

CLEAN.include FileList["#{EXT_DIR}/*.{so,bundle,#{CONFIG['DLEXT']}}"],
						  FileList["#{EXT_DIR}/*.o"],
						  FileList["#{EXT_DIR}/Makefile"],
						  FileList["#{RAGEL_DIR}/*.h"]
						  FileList["#{RAGEL_DIR}/*.tmp"]

RDOC_OPTS = ['--quiet', '--title', 'Ohcount Reference', '--main', 'README', '--inline-source']

Rake::RDocTask.new do |rdoc|
	rdoc.rdoc_dir = 'doc'
	rdoc.options += RDOC_OPTS
	rdoc.rdoc_files.add ['README' ,'COPYING', 'lib/**/*.rb', 'ext/**/*.rb', 'ext/**/*.c', 'test/test_helper.rb', 'test/unit/detector_test.rb']
end

PKG_FILES = %w(README COPYING Rakefile lib/ohcount.rb) +
	Dir.glob("#{EXT_DIR}/*.{h,c,rb}") +
	Dir.glob("#{RAGEL_DIR}/*.h") +
	Dir.glob("#{RAGEL_DIR}/*.rl") +
	Dir.glob("lib/**/*.rb") +
	Dir.glob("bin/*")

SPEC =
	Gem::Specification.new do |s|
		s.name = NAME
		s.version = VERS
		s.platform = Gem::Platform::RUBY
		s.has_rdoc = true
		s.rdoc_options = RDOC_OPTS
		s.extra_rdoc_files = ['README']
		s.summary = "The Ohloh source code line counter"
		s.description = s.summary
		s.author = "Ohloh Corporation"
		s.email = "info@ohloh.net"
		s.homepage = "http://labs.ohloh.net/ohcount"
		s.files = PKG_FILES.to_a
		s.require_paths = ['lib']
		s.extensions << 'ext/ohcount_native/extconf.rb'
		s.bindir = 'bin'
		s.executables = ['ohcount']
		s.add_dependency 'diff-lcs'
	end

Rake::GemPackageTask.new(SPEC) do |p|
	p.need_tar = true
	p.gem_spec = SPEC
end

task :install => :package do
	`sudo gem install pkg/#{NAME}-#{VERS}`
end

file ARCH_DL => EXT_DL do
	mkdir_p ARCH_DIR
	cp EXT_DL, ARCH_DIR
end

rule ".h" => ".rl" do |t|
	if has_embedded_language?(t.source)
		construct_language(t.source) do |constructed_file|
			sh "ragel #{constructed_file} -o #{t.name}"
		end
	else
		sh "ragel #{t.source} -o #{t.name}"
	end
end

def has_embedded_language?(parser_file)
  return IO.read(parser_file).include?('#EMBED')
end

def construct_language(parser_file)
  parser_text = IO.read(parser_file).gsub(/#EMBED\([\w_]+\)/) do |elang|
    lang = elang.scan(/^#EMBED\(([\w_]+)\)/)[0][0]
    eparser_file = File.join(RAGEL_DIR, lang + '.rl')
    if File.exists?(eparser_file)
      eparser = IO.read(eparser_file)
      ragel = eparser.scan(/%%\{(.+?)\}%%/m)[0][0]
      # eliminate machine definition, writes, and includes
      ragel.gsub!(/^\s*machine[^;]+;\s+write[^;]+;\s+include[^;]+;\s+/, '')
      "}%%\n%%{\n#{ragel}"
    else
      ''
    end
  end
	tmp = parser_file + '.tmp'
  File.open(tmp, 'w') { |f| f.write parser_text }
	yield tmp
	File.delete(tmp)
end

file EXT_DL => FileList["#{EXT_DIR}/Makefile", "#{EXT_DIR}/*.{c,h,rb}", "#{RAGEL_DIR}/*.h"] do
	cd EXT_DIR do
		sh 'make'
	end
end

file "#{EXT_DIR}/ragel_parser.c" => FileList["#{RAGEL_DIR}/*.rl"].gsub(/\.rl/,'.h') do
	# When any ragel parser changes, we need to rebuild ragel_parser.c.
	# We force this by deleting the existing object file.
	# We have no better option than this because C dependencies are controlled by mkmf,
	# outside of the control of this Rakefile.
	File.delete(File.join(EXT_DIR, 'ragel_parser.o')) if File.exist?(File.join(EXT_DIR, 'ragel_parser.o'))
end

file "#{EXT_DIR}/Makefile" => "#{EXT_DIR}/extconf.rb" do
	cd EXT_DIR do
		if ENV['DEBUG']
			ruby 'extconf.rb', 'debug'
		else
			ruby 'extconf.rb'
		end
	end
end

Rake::TestTask.new :ohcount_unit_tests => ARCH_DL do |t|
	# puts File.dirname(__FILE__) + '/test/unit/*_test.rb'
	t.test_files = FileList[File.dirname(__FILE__) + '/test/unit/**/*_test.rb']
	# t.verbose = true
end

task :default => :ohcount_unit_tests
