require 'lib/gestalt/rules/rule'
require 'lib/gestalt/rules/logical_rule'
require 'lib/gestalt/rules/or_rule'
require 'lib/gestalt/rules/and_rule'
require 'lib/gestalt/rules/language_rule'
require 'lib/gestalt/rules/file_rule'
require 'lib/gestalt/rules/filename_rule'
require 'lib/gestalt/rules/c_header_rule'
require 'lib/gestalt/rules/keyword_rule'
require 'lib/gestalt/rules/c_keyword_rule'
require 'lib/gestalt/rules/platform_rule'

module Ohcount
	module Gestalt
		class Platform

			# platform rules are assumed to be, at the top level,
			# OR-ed. In other words, any one rule will trigger that platform.
			# That's why we keep a top-level OrRule around.
			def self.top_level_or
				@top_level_or ||= OrRule.new
			end

			# we delegate to the top_level_or trigger
			def self.method_missing(method, *args)
				top_level_or.send(method, *args)
			end

			def self.triggered?(g)
				top_level_or.triggered?(g)

			end

			# tricky code to let us track the descendants...
			class << self
				def children() @children ||= [] end
				def inherited(other) children << other and super end
				def descendants() children.inject([]){|d,c| d.push(c, *c.descendants)} end
			end

		end
	end
end

