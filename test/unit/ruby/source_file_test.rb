require 'test/unit'
require File.dirname(__FILE__) + '/../../../ruby/gestalt'

class SourceFileTest < Test::Unit::TestCase
	def test_diff
		c = File.open(File.dirname(__FILE__) + "/../../src_dir/optimer").read
		new = Ohcount::SourceFile.new("optimer", :contents => c, :filenames => nil, :filenames => ["optimer"])
		old = Ohcount::SourceFile.new("optimer", :contents => "", :filenames => ["optimer"])
		assert_equal c, new.contents
		deltas = old.diff(new).loc_deltas
		assert_not_nil deltas
		assert_equal "shell", deltas.first.language
	end
end
