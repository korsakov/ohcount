# platforms

module Ohcount
  module Gestalt

    class POSIX < Platform
      # gnu_lib && generic
      c_headers 'pthread.h', 'xstrtol.h', 'xreadlink.h', 'fatal-signal.h', 'diacrit.h', 'syslog.h', 'sys/stat.h'

      # autoconf means m4 (unix macro processor)
      language :autoconf
    end

    class Win32 < Platform
      c_headers 'windows.h'
      c_keywords 'WM_PAINT', 'ReleaseDC', 'WndProc', :min => 2
    end

    class WPF < Platform
      filenames '\.xaml$'
    end

    class Dot_NET < Platform
      language :csharp, :min_percent => 10
    end

    class VisualBasic < Platform
      language :visualbasic, :min_percent => 5
    end

    class ASP_NET < Platform
      filenames('\.(aspx|ascx|ashx|asax|axd)$')
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
      c_headers 'Xlib.h', 'X11\/xpm.h', 'X11/Xlib.h'
    end

    class Mac < Platform
      # apple events
      c_keywords 'AppleEvent', 'AEBuildAppleEvent'

      # plist is a mac thing, right?
      filenames '\.plist'
    end

    class PHP < Platform
      language :php, :min_percent => 15
    end

    class WxWidgets < Platform
      c_headers 'wx/window.h'
    end

		class Symfony < Platform
			_and(
						platform(PHP),
						php_keywords('sfCore', 'sfConfig')
					)
		end

    class CakePHP < Platform
      _and(
            platform(PHP),
            php_keywords('CAKE_CORE_INCLUDE_PATH')
           )
    end

		class Pear < Platform
			_and(
						platform(PHP),
						_or(
								filenames('\bpackage\.xml(\.tpl)?$'),
								xml_keywords('pear.php.net/dtd/package-2.0')
						)
			)
		end

		class Moodle < Platform
			_and(
				platform(PHP),
				php_keywords("moodle")
			)
		end

    class KDE < Platform
      c_headers 'KDEInit.h', 'kdeversion.h'
    end

    class SQL < Platform
      language :sql
    end

    class MySQL < Platform
      php_keywords('mysql_connect')
    end

    class PostgreSQL < Platform
      php_keywords('pg_connect')
    end

    class MSDos < Platform
      c_keywords '__MSDOS__', 'MSDOS', :min => 2
    end

    class EclipsePlatform < Platform
      java_import 'org.eclipse.'
    end
  end
end
