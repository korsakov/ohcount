require 'lib/gestalt/library'
#require 'lib/gestalt/platforms/platform'

module Ohcount
	module Gestalt
		class Platform

			# platform triggers are assumed to be, at the top level,
			# OR-ed. In other words, any one rule will trigger that platform.
			# That's why we keep a top-level OrTrigger around.
			def self.top_level_or
				@top_level_or ||= OrTrigger.new
			end

			# we delegate to the top_level_or trigger
			def self.method_missing(method, *args)
				top_level_or.send(method, *args)
			end

			# tricky code to let us track the descendants...
			class << self
				def children() @children ||= [] end
				def inherited(other) children << other and super end
				def descendants() children.inject([]){|d,c| d.push(c, *c.descendants)} end
			end
		end

		# Will trigger if any sub-trigger does
		class OrTrigger
			attr_reader :triggers

			def initialize(*triggers)
				@triggers = triggers
			end

			def triggered?(g_attr)
				triggers.each do |t|
					return t if t.triggered?(g_attr)
				end
				nil
			end

			def trigger_libs(*args)
				triggers << LibsTrigger.new(*args)
			end

			def trigger_platform(platform)
				triggers << PlatformTrigger.new(platform)
			end

			def trigger_language(language, options = {})
				triggers << LanguageTrigger.new(language, options)
			end
		end

		# will trigger if any libs were detected
		# options:
		#   :count => minimum number of detections (default 1)
		class LibsTrigger
			attr_reader :lib_symbols
			attr_reader :count

			def initialize(*args)
				options = args.last.is_a?(::Hash) ? args.pop : {}
				@count = options.delete(:count) || 1
				raise "Unrecognized LibsTrigger options '#{ options.keys.inspect }'" if options.any?
				@lib_symbols = args
			end

			def triggered?(g)
				c = count
				lib_symbols.each do |ls|
					c -= g.lib_counts[ls].to_i
					return self if c <= 0
				end
				nil
			end
		end

		class PlatformTrigger
			attr_reader :platform

			def initialize(platform)
				@platform = platform
			end

			def triggered?(g)
				g.platforms.include?(platform)
			end
		end

		class LanguageTrigger
			attr_reader :language
			attr_reader :min_percent

			def initialize(language, options= {})
				@min_percent = options.delete(:min_percent) || 0
				raise "Unrecognized LanguageTrigger options '#{ options.keys.inspect }'" if options.any?
				@language = language
			end

			def triggered?(g)
				return self if g.includes_language?(language, min_percent)
			end

		end
	end
end

# require the dynamic rules
require OHCOUNT_ROOT + '/rules/libraries'
require OHCOUNT_ROOT + '/rules/platforms'

