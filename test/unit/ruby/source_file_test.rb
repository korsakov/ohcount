require 'test/unit'
require_relative '../../../ruby/gestalt'

class SourceFileTest < Test::Unit::TestCase
	def test_diff
		optimer = File.open(File.dirname(__FILE__) + "/../../src_dir/optimer").read
		new = Ohcount::SourceFile.new("optimer", :contents => optimer, :filenames => nil, :filenames => ["optimer"])
		old = Ohcount::SourceFile.new("optimer", :contents => "", :filenames => ["optimer"])
		assert_equal optimer, new.contents
		deltas = old.diff(new).loc_deltas
		assert_not_nil deltas
		assert_equal "shell", deltas.first.language
	end

	def test_empty_diff
		filename = "mysql-stale-table-sniper"
		c = File.open(File.dirname(__FILE__) + "/../../src_dir/#{filename}").read
		new = Ohcount::SourceFile.new(filename, :contents => c, :filenames => nil, :filenames => [filename])
		old = Ohcount::SourceFile.new(filename, :contents => "", :filenames => nil, :filenames => [filename])
		assert_equal c, new.contents
		deltas = old.diff(new).loc_deltas
		assert_not_nil deltas
		assert_equal "perl", deltas.first.language
	end
end
