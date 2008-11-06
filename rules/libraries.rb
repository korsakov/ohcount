# Libraries
#
module Ohcount
	module Gestalt

		class GnuLib < Library
			c_headers 'pthread.h', 'xstrtol.h', 'xreadlink.h', 'fatal-signal.h', 'diacrit.h'
		end

		class WindowsConstants < Library
			c_headers 'windows.h'
			c_keywords 'WM_PAINT', 'ReleaseDC', 'WndProc'
		end

		class CakePhpCore < Library
			php_keywords "CAKE_CORE_INCLUDE_PATH"
		end

		class RailsCore < Library
			ruby_keywords "RAILS_ROOT"
		end

		class BSDLib < Library
			c_keywords 'FTS_PHYSICAL'
		end

	end
end
