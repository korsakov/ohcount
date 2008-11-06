# platforms

include Ohcount::Gestalt

class POSIX < Platform
	trigger_libs :gnu_lib
	trigger_language :autoconf
end

class Win32 < Platform
	trigger_libs :windows_constants, :count => 2
end

class Linux < Platform
	trigger_platform POSIX
end

class Ruby < Platform
	trigger_language :ruby, :min_percent => 15
end

class CakePHP < Platform
	t_and(
				trigger_language(:php, :min_percent => 15),
				trigger_libs(:cake_php_core)
			 )
end
