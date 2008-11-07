module Ohcount
	module Gestalt
		class Rule
			def ==(other)
				return false unless self.class == other.class
				return false unless self.instance_variables == other.instance_variables
				self.instance_variables.each do |v|
					return false unless self.send(v[1..-1]) == other.send(v[1..-1])
				end
				true
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

			def self.method_missing(m,*args)
				if /(.*)_keywords$/ =~ m.to_s
					language = $1
					return rules << KeywordLibraryRule.new(language,args)
				end
				super
			end

		end
	end
end
