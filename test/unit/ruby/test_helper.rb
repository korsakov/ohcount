require 'test/unit'
require 'fileutils'
require 'find'
require File.dirname(__FILE__) + '/../../../ruby/ohcount.rb' # .rb is to specify the .rb instead of .bundle
require File.dirname(__FILE__) + '/../../../ruby/gestalt' # .rb is to specify the .rb instead of .bundle

unless defined?(TEST_DIR)
	TEST_DIR = File.dirname(__FILE__)
end

module Ohcount
end

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
	def default_test; end

	protected

  def assert_tool(path, *tools)
    gestalts = tools.map do |t|
      Base.new(:tool, t.to_s)
    end
    assert_gestalts path, gestalts
  end

	def assert_platform(path, *platforms)
    gestalts = platforms.map do |p|
      Base.new(:platform, p.to_s)
    end
    assert_gestalts path, gestalts
  end

	def assert_gestalts(path, expected_gestalts)
    assert_equal expected_gestalts.sort, get_gestalts(path)
  end

	def get_gestalts(path)
		sfl = SourceFileList.new(:paths => [test_dir(path)])
		assert sfl.size > 0
		sfl.analyze(:gestalt)
		sfl.gestalts.sort
	end

	def test_dir(d)
		File.expand_path(File.dirname(__FILE__) + "/../../gestalt_files/#{ d }")
	end
end

