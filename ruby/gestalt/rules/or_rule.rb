module Ohcount
	module Gestalt
		# Will trigger if any sub-rule does
		class OrRule < LogicalRule
			def triggers(gestalt_engine)
				rules.each do |r|
          triggers = r.triggers(gestalt_engine)
          return triggers if triggers.any?
				end
				[]
			end
		end
	end
end
