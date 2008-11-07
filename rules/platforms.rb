# platforms
include Ohcount::Gestalt

class POSIX < Platform
	trigger_libs :gnu_lib
	trigger_language :autoconf
end

class Win32 < Platform
	trigger_libs :windows_constants, :count => 2
end

class Ruby < Platform
	trigger_language :ruby, :min_percent => 15
end

class Rails < Platform
	t_and(
				trigger_libs(:rails_core),
				trigger_platform(Ruby)
			 )
end

class Java < Platform
	trigger_language :java, :min_percent => 20
end

class CakePHP < Platform
	t_and(
				trigger_language(:php, :min_percent => 15),
				trigger_libs(:cake_php_core)
			 )
end

class Java < Platform
	trigger_language :java, :min_percent => 15
end

class Javascript < Platform
	trigger_language :javascript, :min_percent => 20
end

class JQuery < Platform
	trigger_libs :j_query_library
end

class SpringFramework < Platform
	t_and(
				trigger_platform(Java),
				trigger_libs(:spring_library)
			 )
end

class XWindows < Platform
	trigger_libs :x_windows_lib
end

class Mac < Platform
	trigger_libs(:apple_events, :plist)
end
