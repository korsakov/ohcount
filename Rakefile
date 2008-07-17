require 'rake'
require 'rake/clean'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rake/testtask'
require 'rbconfig'
include Config

NAME = 'ohcount'
VERS = '2.0.0'

EXT_DIR  = "ext/ohcount_native"
EXT_DL   = "#{EXT_DIR}/ohcount_native.#{CONFIG['DLEXT']}"
ARCH_DIR = "lib/#{::Config::CONFIG['arch']}"
ARCH_DL  = "#{ARCH_DIR}/ohcount_native.#{CONFIG['DLEXT']}"

CLEAN.include FileList["#{EXT_DIR}/*.{so,bundle,#{CONFIG['DLEXT']}}"],
						  FileList["#{EXT_DIR}/*.o"],
						  FileList["#{EXT_DIR}/Makefile"],
						  (FileList["#{EXT_DIR}/*_parser.h"] - FileList["#{EXT_DIR}/ragel_parser.h"])

RDOC_OPTS = ['--quiet', '--title', 'Ohcount Reference', '--main', 'README', '--inline-source']

PKG_FILES = %w(README COPYING Rakefile lib/ohcount.rb) +
	Dir.glob("ext/ohcount_native/*.{h,c,rb}") +
	Dir.glob("lib/**/*.rb") +
	Dir.glob("test/*") +
	Dir.glob("test/**/*") +
	Dir.glob("bin/*")

SPEC =
	Gem::Specification.new do |s|
		s.name = NAME
		s.version = VERS
		s.platform = Gem::Platform::RUBY
		s.has_rdoc = true
		s.rdoc_options = RDOC_OPTS
		s.summary = "The Ohloh source code line counter"
		s.description = s.summary
		s.author = "Ohloh Corporation"
		s.email = "info@ohloh.net"
		s.homepage = "http://labs.ohloh.net/ohcount"
		s.files = PKG_FILES
		s.require_paths <<  'lib'
		s.extensions << 'ext/ohcount_native/extconf.rb'
		s.bindir = 'bin'
		s.executables = ['ohcount']
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

file EXT_DL => FileList["#{EXT_DIR}/Makefile", "#{EXT_DIR}/*.{c,h,rb}"] do
	cd EXT_DIR do
		cd 'ragel_parsers' do
			require 'construct_embedded'
			rls = FileList['*.rl']
			rls.exclude('common.rl')
			rls.each do |rl|
				h = rl.scan(/^(.+)\.rl$/).flatten.first + '_parser.h'
				if has_embedded?(rl)
					construct_language(rl)
					sh "ragel #{rl + '.tmp'} -o ../#{h}"
					File.delete(rl + '.tmp')
				else
					sh "ragel #{rl} -o ../#{h}"
				end
			end
		end
		sh 'make'
	end
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

Rake::RDocTask.new do |rdoc|
	rdoc.rdoc_dir = 'doc'
	rdoc.options += RDOC_OPTS
	rdoc.rdoc_files.add ['README' ,'COPYING', 'lib/**/*.rb', 'ext/**/*.rb', 'ext/**/*.c', 'test/test_helper.rb', 'test/unit/detector_test.rb']
end

Rake::TestTask.new :ohcount_unit_tests => ARCH_DL do |t|
	# puts File.dirname(__FILE__) + '/test/unit/*_test.rb'
	t.test_files = FileList[File.dirname(__FILE__) + '/test/unit/*_test.rb']
	# t.verbose = true
end

task :default => :ohcount_unit_tests
