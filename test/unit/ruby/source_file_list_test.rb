require 'test/unit'
require '../../../ruby/gestalt'

class SourceFileListTest < Test::Unit::TestCase

	def test_source_file_list_initializes
		paths = [File.dirname(__FILE__)]
		assert Ohcount::SourceFileList.new(:paths => paths).size > 0
	end

	def test_source_file_filenames
		filenames = ["x", "y", "z"]
		sf = Ohcount::SourceFile.new("foo", :contents => "bar", :filenames => filenames)
		assert_equal filenames, sf.filenames
	end
end

