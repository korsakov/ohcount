require File.dirname(__FILE__) + '/../test_helper'
include Ohcount

class SourceFileTest < Ohcount::Test

	def test_initialize
		assert SourceFile.new("foo.rb")
	end

	def test_contents
		contents = "foobar"
		f = SourceFile.new("foo.rb", :contents => contents)
		assert_equal contents, f.contents
	end

	def test_language_breakdowns
		contents = "x = 5"
		f = SourceFile.new("foo.rb", :contents => contents)
		assert_equal 'ruby', f.language_breakdowns[0].name
		assert_equal contents, f.language_breakdowns('ruby').code
	end

	def test_parse
		ruby_code = ''
		contents = "x = 5"
		f = SourceFile.new("foo.rb", :contents => contents)
		f.parse do |l, s, line|
			ruby_code << line if l == :ruby && s == :code
		end
		assert_equal contents, ruby_code
	end

	def test_realize_file
		s = SourceFile.new('foo.c', :contents => 'i')
		s.realize_file do |f|
			assert_equal 'i', File.new(f).read
		end
	end
end

