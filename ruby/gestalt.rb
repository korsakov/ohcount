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
require "gestalt/dot_net_definitions"
require "gestalt/java_definitions"
require "gestalt/jasper_definitions"
require "gestalt/gestalt_engine"
require "gestalt/gestalt_facts"


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

		# call analyze to generate facts from a collection of files (typically a
		# project directory). Because deducing different facts often requires doing
		# similar work, this function allows multiple facts to be extracted in one
		# single pass
		#
		# *Fact* *Types*
		#
		# :gestalt:: platform dependencies and tools usage
		# :languages:: detailed programming languages facts
		# :java:: java-related dependencies (jars & imports)
		#
		# Examples
		#
		#  sfl = SourceFileList.new(:dir => '/foo/bar')
		#  sfl.analyze(:languages)
		#  puts sfl.ruby.code.count
		#
		def analyze(what = [:*])
			what = [what] unless what.is_a?(Array)

			do_gestalt   = what.include?(:gestalt)   || what.include?(:*)
			do_languages = what.include?(:language)  || what.include?(:*)

			analyze_languages() if do_languages
			analyze_gestalt() if do_gestalt
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
	STDOUT.puts "Examining #{sourcefile_list.size} file(s) for gestalts."
  sourcefile_list.analyze_gestalt()
  sourcefile_list.gestalts.sort.each do |gestalt|
    puts "#{gestalt.type}\t#{gestalt.count.to_s.rjust(8)}\t#{gestalt.name}"
  end
end
