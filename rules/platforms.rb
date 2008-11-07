# platforms
include Ohcount::Gestalt

class POSIX < Platform
	# gnu_lib
	c_headers 'pthread.h', 'xstrtol.h', 'xreadlink.h', 'fatal-signal.h', 'diacrit.h'

	# autoconf means m4 (unix macro processor)
	language :autoconf
end

class Win32 < Platform
	c_headers 'windows.h'
	c_keywords 'WM_PAINT', 'ReleaseDC', 'WndProc', :min => 2
end

class Ruby < Platform
	language :ruby, :min_percent => 15
end

class Rails < Platform
	_and(
			 platform(Ruby),
			 ruby_keywords("RAILS_ROOT")
			)
end

class Java < Platform
	language :java, :min_percent => 15
end

class Javascript < Platform
	language :javascript, :min_percent => 20
end

class JQuery < Platform
	filenames 'jquery-\d.\d.\d.min.js'
end

class SpringFramework < Platform
	_and(
			 platform(Java),
			 filenames('spring\.jar$')
			)
end

class XWindows < Platform
	c_headers 'Xlib.h', 'X11\/xpm.h'
end

class Mac < Platform
	# apple events
	c_keywords 'AppleEvent', 'AEBuildAppleEvent'

	# plist is a mac thing, right?
	filenames '\.plist'
end

class CakePHP < Platform
	_and(
				language(:php, :min_percent => 15),
				php_keywords('CAKE_CORE_INCLUDE_PATH')
			 )
end

class KDE < Platform
	c_headers 'KDEInit.h', 'kdeversion.h'
end
