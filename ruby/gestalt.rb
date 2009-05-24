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
