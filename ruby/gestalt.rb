# gestalt.rb written by Mitchell Foral. mitchell<att>caladbolg.net.
# See COPYING for license information.
# Ohcount module tweaked for use by Gestalts.

$: << File.expand_path(File.dirname(__FILE__))
require "ohcount"

# gestalt
require "gestalt/trigger"
require "gestalt/definition"
require "gestalt/base"
require "gestalt/definitions"
require "gestalt/gestalt_engine"

module Ohcount
  class SourceFile
    def gestalts
      gestalt_engine = Gestalt::GestaltEngine.new
      gestalt_engine.process(self)
      gestalt_engine.calc_gestalts
      gestalt_engine.gestalts
    end
  end

  class SourceFileList
    def analyze_gestalt
      @gestalt_engine = Gestalt::GestaltEngine.new
      iter = self.head
      while (iter)
        @gestalt_engine.process(iter.sf)
        iter = iter.next
      end
      @gestalt_engine.calc_gestalts
    end

    def gestalts
      @gestalt_engine.gestalts if @gestalt_engine
    end
  end
end

if __FILE__ == $0
  sourcefile_list = Ohcount::SourceFileList.new()
  sourcefile_list.add_directory('.') if ARGV.size == 0
  ARGV.each do |file_or_path|
    if File.directory?(file_or_path)
      sourcefile_list.add_directory(file_or_path)
    else
      sourcefile_list.add_file(file_or_path)
    end
  end
  sourcefile_list.analyze_gestalt()
  sourcefile_list.gestalts.sort.each do |gestalt|
    puts "#{gestalt.type}\t#{gestalt.count.to_s.rjust(8)}\t#{gestalt.name}"
  end
end
