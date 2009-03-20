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
		assert_equal contents, f.language_breakdown('ruby').code
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

  def test_diff
    old = SourceFile.new("foo.c", :contents => 'int i;')
    new = SourceFile.new("foo.c", :contents => 'int j;')

    delta = LocDelta.new('c', :code_added => 1, :code_removed => 1)
    assert_equal delta, old.calc_loc_delta('c', new)
    assert_equal LocDeltaList.new([delta]), old.diff(new)
  end

  def test_calc_diff_2
    old = SourceFile.new("foo.html", :contents => <<-INLINE_HTML
      <html>
        <script type='text/javascript'>
          var i = 1;
        </script>
        <style type="text/css">
          new_css_code
          /* css_comment */
        </style>
     </html>
    INLINE_HTML
    )
    new = SourceFile.new("foo.html", :contents => <<-INLINE_HTML
      <html>
        <script type='text/javascript'>
          var i = 2;
        </script>
        <style type="text/css">
          new_css_code
          /* different css_comment */
        </style>
     </html>
    INLINE_HTML
    )
		loc_delta_list = old.diff(new)
		assert_equal ['css', 'javascript'], loc_delta_list.languages
    assert_equal LocDelta.new('css', :comments_added => 1, :comments_removed => 1), loc_delta_list.loc_delta('css')
    assert_equal LocDelta.new('javascript', :code_added => 1, :code_removed => 1), loc_delta_list.loc_delta('javascript')
  end

  def test_calc_diff_longer
    old = SourceFile.new("foo.c", :contents => <<-INLINE_C
      int = 1;
      int = 2;
      int = 3;
      int = 4;
      INLINE_C
    )
    new = SourceFile.new("foo.c", :contents => <<-INLINE_C
      int = 1;
      int = 5;
      int = 6;
      int = 4;
      INLINE_C
    )
    assert_equal LocDelta.new('c', :code_added => 2, :code_removed => 2), old.diff(new).loc_delta('c')
  end

	def test_calc_small_diff
		assert_equal [0,0], SourceFile.new.calc_small_diff("","")
		assert_equal [0,0], SourceFile.new.calc_small_diff("a","a")
		assert_equal [0,0], SourceFile.new.calc_small_diff("a\n","a\n")
		assert_equal [1,0], SourceFile.new.calc_small_diff("","a\n")
		assert_equal [0,1], SourceFile.new.calc_small_diff("a\n","")
		assert_equal [1,1], SourceFile.new.calc_small_diff("a\n","b\n")
		assert_equal [1,1], SourceFile.new.calc_small_diff("a\nb\nc\n","a\nc\nd\n")
	end

	def test_calc_large_diff
		assert_equal [0,0], SourceFile.new.calc_large_diff("","")
		assert_equal [0,0], SourceFile.new.calc_large_diff("a","a")
		assert_equal [0,0], SourceFile.new.calc_large_diff("a\n","a\n")
		assert_equal [1,0], SourceFile.new.calc_large_diff("","a\n")
		assert_equal [0,1], SourceFile.new.calc_large_diff("a\n","")
		assert_equal [1,1], SourceFile.new.calc_large_diff("a\n","b\n")
		assert_equal [1,1], SourceFile.new.calc_large_diff("a\nb\nc\n","a\nc\nd\n")
	end

	def test_calc_diff
		assert_equal [1,0], SourceFile.new.calc_diff("Hello, World!\n" * 10, "Hello, World!\n" * 11)
		assert_equal [1,0], SourceFile.new.calc_diff("Hello, World!\n" * 10000, "Hello, World!\n" * 10001)
	end
end
