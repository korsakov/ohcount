# ohcount.rb written by Mitchell Foral. mitchell<att>caladbolg.net.
# See COPYING for license information.
# Ohcount module tweaked for use by Ohloh.

$: << File.expand_path(File.dirname(__FILE__))
$: << "#{File.expand_path(File.dirname(__FILE__))}/#{`#{File.dirname(__FILE__)}/print_arch`.strip}"

require 'ohcount.so'

module Ohcount
  class SourceFile
    def file_location=(value) set_diskpath(value) end
    def file_location() diskpath() end
    def filenames=(value) set_filenames(value) end
    def contents() get_contents().force_encoding(Encoding.default_external) end
    def polyglot() get_language() end

    def language_breakdowns
      list = get_parsed_language_list()
      return array_from_list(list, :pl)
    end

    def language_breakdown(language)
      return language_breakdowns().find { |lb| lb.name == language.to_s }
    end

    def licenses
      list = get_license_list()
      array = array_from_list(list, :lic)
      return array.map! { |l| l.name }
    end

    def languages
      return language_breakdowns().collect { |lb| lb.name }
    end

    def loc_list
      list = get_loc_list()
      return array_from_list(list, :loc)
    end

    def diff(to)
      list = _diff(to)
      ret = array_from_list(list, :delta)
      class << ret
        def loc_deltas() self end
      end
      return ret
    end

    def each
      filenames.each { |f| yield f }
    end

    private

    def array_from_list(list, method)
      array = Array.new
      iter = list.head
      while (iter)
        array << iter.send(method)
        iter = iter.next
      end
      return array
    end
  end

  class SourceFileList
    def each_source_file
      iter = self.head
      while (iter)
        yield iter.sf if iter.sf.polyglot
        iter = iter.next
      end
    end

		# this should yield each filename, not an sf object
		def each
      iter = self.head
      while (iter)
        yield iter.sf.filename if iter.sf
        iter = iter.next
      end
		end

    def size
      count = 0
      iter = self.head
      while (iter)
        count += 1
        iter = iter.next
      end
      return count
    end
  end

  class Detector
    def self.binary_filename?(filename)
      return Ohcount.ohcount_is_binary_filename(filename) == 1
    end
  end
end
