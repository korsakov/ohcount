require 'test/unit'
require File.dirname(__FILE__) + '/../../../ruby/gestalt'

class SourceFileTest < Test::Unit::TestCase
	def test_diff
		c = File.open(File.dirname(__FILE__) + "/../../src_dir/optimer").read
		new = Ohcount::SourceFile.new("optimer", :contents => c, :filenames => nil, :filenames => ["optimer"])
		old = Ohcount::SourceFile.new("optimer", :contents => "", :filenames => ["optimer"])
		assert_equal c, new.contents
		deltas = old.diff(new).loc_deltas
		assert_equal c, new.contents # seems odd that new.contents are overwritten by the diff
		STDOUT.puts deltas.inspect
		assert !deltas.nil?
		assert !deltas.empty?
		# last assert should be smarter and actually assert that we see shell language lines of code
	end
end
