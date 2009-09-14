require 'test/unit'
require File.dirname(__FILE__) + '/../../../ruby/gestalt'

class SourceFileListTest < Test::Unit::TestCase

	def test_source_file_list_supports_analyze
		paths = [File.dirname(__FILE__)]
		list = Ohcount::SourceFileList.new(:paths => paths)
		assert list.size > 0
		# assume: the paths variable points to the directory containing this and other simple ruby test files

		ruby = Ohcount::Gestalt::Base.new(:platform, 'ruby')
		scripting = Ohcount::Gestalt::Base.new(:platform, 'scripting')

		list.analyze(:gestalt) # this should work
		assert list.gestalts.include?(ruby)
		assert list.gestalts.include?(scripting)

		list.each do |filename|
			assert_equal String, filename.class
		end
	end
end

class SourceFileTest < Test::Unit::TestCase
	def test_source_file_filenames
		filenames = ["x", "y", "z"]
		sf = Ohcount::SourceFile.new("foo", :contents => "bar", :filenames => filenames)
		assert_equal filenames, sf.filenames
		sf.each do |filename|
			assert filenames.include?(filename)
		end
	end
end
