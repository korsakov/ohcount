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

	end
end
