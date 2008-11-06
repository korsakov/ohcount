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

		class PTrigger
		end

		class LogicalTrigger < PTrigger
			attr_reader :triggers

			def initialize(*triggers)
				@triggers = triggers
			end

			def new_trigger(t_class, *args)
				# since we might be nesting logical triggers, we must do remove
				# any 'grandchildren triggers' from our list, since we are giving
				args.each do |a|
					next unless a.is_a?(PTrigger)
					@triggers.delete(a)
				end
				t = t_class.new(*args)
				triggers << t
				t
			end

			def t_or(*args)
				new_trigger OrTrigger, *args
			end

			def t_and(*args)
				new_trigger AndTrigger, *args
			end

			def trigger_libs(*args)
				new_trigger LibsTrigger, *args
			end

			def trigger_platform(*args)
				new_trigger PlatformTrigger, *args
			end

			def trigger_language(*args)
				new_trigger LanguageTrigger, *args
			end
		end

		# Will trigger if any sub-trigger does
		class OrTrigger < LogicalTrigger
			def triggered?(g_attr)
				triggers.each do |t|
					return t if t.triggered?(g_attr)
				end
				nil
			end
		end

		# Will trigger if all sub-triggers do
		class AndTrigger < LogicalTrigger
			def triggered?(g)
				triggers.each do |t|
					return nil unless t.triggered?(g)
				end
				self
			end
		end

		# will trigger if any libs were detected
		# options:
		#   :count => minimum number of detections (default 1)
		class LibsTrigger < PTrigger
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

		class PlatformTrigger < PTrigger
			attr_reader :platform

			def initialize(platform)
				@platform = platform
			end

			def triggered?(g)
				g.platforms.include?(platform)
			end
		end

		class LanguageTrigger < PTrigger
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

