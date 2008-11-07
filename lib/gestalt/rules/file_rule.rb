module Ohcount
	module Gestalt
		# an abstract base class representing a rule based
		# on an individual file's attribute (like
		# code content, or filename, etc..)
		class FileRule < Rule
			attr_reader :min_count

			def initialize(args = {})
				args ||= {}
				@min_count = 1
				args.each do |k,v|
					case k
					when :min then @min_count = v
					else raise ArgumentError.new("Unrecognized option: #{ k.inspect }")
					end
				end
				FileRule.add_instance(self)
			end

			def triggered?(g)
				g.file_rules[self].to_i >= min_count
			end

			def self.rules_triggered_by(source_file)
				rules = instances.find_all do |r|
					r.trigger_file?(source_file)
				end
				rules
			end

			def self.instances
				@instances ||= []
			end
			
			def self.add_instance(r)
				instances << r
			end

		end
	end
end
