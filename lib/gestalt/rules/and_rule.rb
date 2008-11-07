module Ohcount
	module Gestalt
		# Will trigger if all sub-rules do
		class AndRule < LogicalRule
			def triggered?(g_facts)
				rules.each do |r|
					return nil unless r.triggered?(g_facts)
				end
				self
			end
		end
	end
end


