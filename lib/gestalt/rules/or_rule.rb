module Ohcount
	module Gestalt
		# Will trigger if any sub-rule does
		class OrRule < LogicalRule
			def triggered?(g_facts)
				rules.each do |r|
					return r if r.triggered?(g_facts)
				end
				nil
			end
		end
	end
end
