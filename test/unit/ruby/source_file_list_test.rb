require 'test/unit'
require '../../../ruby/gestalt'

class SourceFileListTest < Test::Unit::TestCase
	paths = [File.dirname(__FILE__)]
	assert Ohcount::SourceFileList.new(:paths => paths).size > 0
end
