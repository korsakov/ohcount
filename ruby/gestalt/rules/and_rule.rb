module Ohcount
	module Gestalt
		# Will trigger if all sub-rules do
		class AndRule < LogicalRule

			def triggers(gestalt_engine)
				rules.each do |r|
					return [] if r.triggers(gestalt_engine).empty?
				end
        [Trigger.new]
			end
		end
	end
end


