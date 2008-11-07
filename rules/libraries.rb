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

		class SpringLibrary < Library
			files 'spring\.jar'
		end

		class JQueryLibrary < Library
			files 'jquery-\d.\d.\d.min.js'
		end

		class AppleEvents < Library
			c_keywords 'AppleEvent', 'AEBuildAppleEvent'
		end

		class Plist < Library
			files '\.plist'
		end
	end
end
