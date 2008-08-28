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
		File.expand_path(File.join(TEST_DIR, "src_dir"))
	end

	def expected_dir
		File.expand_path(File.join(TEST_DIR, "expected_dir"))
	end

	# verify_parse runs a full test against a specified file. Detector is used to determine
	# the correct parser, then the file is parsed and compared against expected results.
	#
	# The file to be parsed must be in directory <tt>test/src_dir</tt>.
	#
	# The expected results must be stored in directory <tt>test/expected_dir</tt>, and
	# must be in the format produced by <tt>bin/ohcount --annotate</tt>. That is, each line
	# of the expected file should be prefixed with the tab-delimited language and semantic.
	#
	# To create a new test case:
	#
	# 1. Create a new source code file in <tt>test/src_dir</tt>.
	#    For example, <tt>test/src_dir/my_file.ext</tt>.
	#
	# 2. Copy your source file to the <tt>test/expected_dir</tt> directory.
	#    Use a text editor to insert the language and semantic at the front of each line.
	#    These must be tab-delimited from the rest of the line.
	#
	# If you've cheated and written your code before your test, then you can simply
	# use ohcount itself to create this file:
	#
	#     <tt>bin/ohcount --annotate src_dir/my_file.ext > expected_dir/myfile.ext</tt>
	#
	# Be sure to carefully confirm this result or your test will be meaningless!
	#
	# There are numerous examples in the test directories to help you out.
	def verify_parse(file, filenames=[])
		sfc = Ohcount::SimpleFileContext.new(File.join(src_dir, file), filenames)
		polyglot = Ohcount::Detector.detect(sfc)
		buffer = ''
		if polyglot
			Ohcount::parse(sfc.contents, polyglot) do |language, semantic, line|
				buffer << "#{language}\t#{semantic}\t#{line}"
			end
		end
		expected = File.read(File.join(expected_dir, file))

		# Uncomment the following lines if you need to see a diff explaining why your test is failing
		#	if expected != buffer
		#		File.open("/tmp/ohcount","w") { |f| f.write buffer }
		#		puts `diff #{File.join(expected_dir, file)} /tmp/ohcount`
		#	end

		puts buffer if expected != buffer
		assert expected == buffer, "Parse result of #{File.join(src_dir, file)} did not match expected #{File.join(expected_dir, file)}."
	end

	def entities_array(src_string, polyglot, *entities)
		arr = Array.new
		Ohcount::parse_entities(src_string, polyglot) do |lang, entity, s, e|
			arr << src_string[s...e] if entities.include?(entity)
		end
		arr
	end
end

