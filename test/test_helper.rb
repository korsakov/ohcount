require 'test/unit'
require 'fileutils'
require 'find'

TEST_DIR = File.dirname(__FILE__)
require TEST_DIR + '/../lib/ohcount'

# Ohcount::Test is a base class which includes several helper methods for parser testing.
# All unit tests in Ohcount should derive from this class.
#
# ==== Manual Testing
#
# To manually test a parser, rebuild ohcount and run it against your test file:
#
#   rake
#   bin/ohcount --annotate test/src_dir/my_file.ext
#
# The +annotate+ option will emit your test file to the console, and each line will be
# labeled as code, comment, or blank.
#
class Ohcount::Test < Test::Unit::TestCase

	# For reasons unknown, the base class defines a default_test method to throw a failure.
	# We override it with a no-op to prevent this 'helpful' feature.
	def default_test
	end

	def src_dir
		TEST_DIR + "/src_dir"
	end

	def scratch_dir
		TEST_DIR + "/scratch_dir"
	end

	def expected_dir
		TEST_DIR + "/expected_dir"
	end

	# verify_parse runs a full test against a specified file. Detector is used to determine
	# the correct parser, then the file is parsed and compared against expected results.
	#
	# The file to be parsed must be in directory <tt>test/src_dir</tt>.
	#
	# The expected results must be stored on disk in directory <tt>test/expected_dir</tt>. The format
	# of the expected results on disk is a bit cumbersome. To create new test case, you must:
	#
	# 1. Create a new source code file in <tt>test/src_dir</tt>.
	#    For example, <tt>test/src_dir/my_file.ext</tt>
	#
	# 2. Next, create a new directory in <tt>test/expected_dir</tt> with
	#    the same name as your test source code file. For example,
	#    <tt>test/expected_dir/my_file.ext/</tt>
	#
	# 3. Within this directory, create directories for each language used in the test source code
	#    file. For example, <tt>test/expected_dir/my_file.ext/my_language/</tt>
	#
	# 4. In this language subdirectory, create three files called +code+, +comment+, and +blanks+.
	#    The +code+ file should contain all of the lines from <tt>my_file.ext</tt> which are code lines.
	#    The +comment+ file should contain all comment lines.
	#    The +blanks+ file is a bit different: it should contain a single line with an integer
	#    which is the count of blank lines in the original file.
	#
	# There are numerous examples in the test directories to help you out.
	#
	def verify_parse(src_filename, filenames = [])
		# re-make the output directory
		Dir.mkdir scratch_dir unless File.exists? scratch_dir
		output_dir = scratch_dir + "/#{ File.basename(src_filename) }"
		FileUtils.rm_r(output_dir) if FileTest.directory?(output_dir)
		Dir.mkdir output_dir

		complete_src_filename = src_dir + "/#{ src_filename }"
    sfc = Ohcount::SimpleFileContext.new(complete_src_filename, filenames)
		polyglot = Ohcount::Detector.detect(sfc)

		# parse
		buffer = File.new(complete_src_filename).read
		Ohcount::Parser.parse_to_dir(:dir => output_dir,
																:buffer => buffer,
																:polyglot => polyglot)

		# now compare
		answer_dir = expected_dir + "/#{ File.basename(src_filename) }"
		compare_dir(answer_dir, output_dir)

		# just to be sure, lets compare the total number of lines from the source file and the processed breakdown
		compare_line_count(complete_src_filename, output_dir)
	end


	def compare_dir(expected, actual)
		# make sure entries are identical
		expected_entries = expected.entries.collect { |e| e[expected.size..-1] }
		actual_entries = actual.entries.collect { |a| a[actual.size..-1] }
		assert_equal expected_entries, actual_entries

		Dir.foreach(expected) do |entry|
			next if [".", "..", ".svn"].include?(entry)
			case File.ftype(expected+ "/" + entry)
			when 'file'
				File.open(expected + "/" + entry) do |e|
					File.open(actual + "/" + entry) do |a|
						assert_equal e.read, a.read, "file #{actual + "/" + entry} differs from expected"
					end
				end
			when 'directory'
				compare_dir(expected + "/" + entry, actual + "/" + entry)
			else
				assert false, "weird ftype"
			end
		end
	end


	def compare_line_count(src_file, scratch_dir)
		code_lines = comment_lines = blanks = 0

		Find.find(scratch_dir) do |path|
			if FileTest.file?(path)
				`wc -l #{ path }` =~ /^\s*(\d*)\b/
				case File.basename(path)
				when 'code'
					code_lines += $1.to_i
				when 'comment'
					comment_lines += $1.to_i
				when 'blanks'
					blanks += File.new(path).read.to_i
				end
			end
		end

		# src file lines
		`wc -l #{ src_file }` =~ /^\s*(\d*)\b/
		src_file_lines = $1.to_i

		# compare
		assert_equal src_file_lines, (code_lines + comment_lines + blanks), "wc -l of output (code, comment, blanks) doesn't match the 'wc -l' of original"
	end

	def entities_array(src_string, polyglot, *entities)
		arr = Array.new
		Ohcount::parse_entities(src_string, polyglot) do |lang, entity, s, e|
			arr << src_string[s...e] if entities.include?(entity)
		end
		arr
	end
end

