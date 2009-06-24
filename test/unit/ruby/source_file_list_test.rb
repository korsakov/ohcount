require 'test/unit'
require '../../../ruby/gestalt'

class SourceFileListTest < Test::Unit::TestCase

	def test_source_file_list_supports_analyze
		paths = [File.dirname(__FILE__)]
		list = Ohcount::SourceFileList.new(:paths => paths)
		assert list.size > 0
		# assume: the paths variable points to the directory containing this and other simple ruby test files
		gestalts = [
			Ohcount::Gestalt::Base.new(:platform, 'Ruby'),
			Ohcount::Gestalt::Base.new(:platform, 'Scripting')
		]
		list.analyze(:gestalt) # this should work
		assert_equal gestalts.sort, list.gestalts.sort # and should produce something similar to the above gestalts list
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

