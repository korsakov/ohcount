require 'lib/gestalt/library_rule'

module Ohcount
	module Gestalt

		# A library represents the binding to a specific 'library'. The class methods
		# allow the detection of the library.
		class Library
			attr_reader :triggered_rules

			def initialize(*rules)
				@triggered_rules = rules
			end

			def self.rules
				@rules ||= []
			end

			def self.c_headers(*header_names)
				rules << CHeaderRule.new(header_names)
			end

			def self.files(*filenames)
				rules << FileRule.new(filenames)
			end

			def self.c_keywords(*keywords)
				rules << CKeywordRule.new(keywords)
			end

			def self.php_keywords(*keywords)
				rules << PHPKeywordRule.new(keywords)
			end

			def to_sym
				self.class.to_sym
			end

			# when tallying up libraries, its easier to
			# use symbol names instead of class names
			# to_sym maps FooLib to :foo_lib
			def self.to_sym
				@symbol ||= begin
					to_s =~ /([^:]*)$/
					naked_classname = $1
					chars = naked_classname.scan(/./)
					chars[0] = chars[0].downcase
					ruby_s = chars.collect do |char|
						char.downcase == char ? char : "_" + char.downcase
					end.to_s
					ruby_s.intern
				end
			end

			def self.detect_libraries(source_file)
				descendants.inject([]) do |a, l|
					r = l.triggered_rule(source_file)
					r ? ( a << l.new(r)) : a
				end
			end

			def self.triggered_rule(source_file)
				rules.each do |r|
					return r if r.trigger?(source_file)
				end
				nil
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
