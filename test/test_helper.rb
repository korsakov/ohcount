require 'test/unit'
require 'fileutils'
require 'find'

TEST_DIR = File.dirname(__FILE__)
require TEST_DIR + '/../lib/ohcount'

class LingoTest < Test::Unit::TestCase

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
end

