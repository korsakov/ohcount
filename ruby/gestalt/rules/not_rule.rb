module Ohcount
	module Gestalt
		class NotRule < LogicalRule
			def triggers(gestalt_engine)
				rules.first && rules.first.triggers(gestalt_engine).any? ? [] : [Trigger.new]
			end

			def new_rule(r_class, *args, &block)
				raise ArgumentError.new("_not() accepts only a single rule") unless rules.empty?
				super(r_class, *args, &block)
			end

		end
	end
end

