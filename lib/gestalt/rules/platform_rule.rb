module Ohcount
	module Gestalt

		# states that a platform depends on another platform
		# being true.
		class PlatformRule < Rule
			attr_reader :platform

			def initialize(platform)
				@platform = platform
			end

			def triggered?(g_facts)
				g_facts.platforms.include?(platform)
			end
		end
	end
end
