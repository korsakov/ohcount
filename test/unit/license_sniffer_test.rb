require File.dirname(__FILE__) + '/../test_helper'

class Ohcount::LicensesSnifferTest < Ohcount::Test

  # To make test creation easy & straighforward, we use a
  # file-based convention, as follows:
  #
  # test/src_licenses/<license_name>_t1.c   <-- a 'C' file
  #                                             containing <license_name>
  #
  # test/expected_licences/<license_name>_t1  <-- a text file containg
  #                                               space-delimited list of
  #                                               expected licenses
  #
  # This test loops over every file in the src_licenses directory ensuring
  # the expected results are achieved.
  #
  def test_expected_licenses
    src_dir = File.dirname(__FILE__) + "/../src_licenses"
    expected_dir = File.dirname(__FILE__) + "/../expected_licenses"

    Dir.entries(src_dir).each do |f|
      filename = src_dir + "/" + f
      next if File.directory?(filename)
      next if f[0..0] == "."

			sfc = SimpleFileContext.new(filename)
      detected_licenses = LicenseSniffer.parse(sfc.contents, Detector.detect(sfc))

      # expected_licenses
      begin
        f =~ /^([^\.]*)/
        expected_filename = $1
        expected_licenses = File.new(expected_dir + "/" + expected_filename).read.split.collect { |l| l.intern }
      rescue
        case $!
        when Errno::ENOENT
          assert false, "Missing expected_licenses file for #{ f }"
        end
      end

      # match?
      assert_equal expected_licenses, detected_licenses, "Mismatch in file #{ f }"
    end
  end

end
