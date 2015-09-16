module Ohcount
	module Gestalt

		# states that a certain gestalt is required.
		class GestaltRule < Rule
			attr_reader :type, :name

			def initialize(type, name)
        @type = type
        @name = name
      end

			def triggers(gestalt_engine)
        if gestalt_engine.has_gestalt?(type,name)
          [Trigger.new]
        else
          []
        end
			end
		end
	end
end
