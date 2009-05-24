module Ohcount
	module Gestalt


    ############################# Platforms #############################
    #                                                                   #
    # Platforms is used in the most general sense of the word. We don't #
    # discriminate between OS-platforms and a lightweight framework -   #
    # any type of dependency is fair game.                              #
    #                                                                   #
    # What guides what we add here is mostly for internal Ohloh         #
    # purposes.                                                         #
    #                                                                   #
    #####################################################################

    define_platform 'POSIX' do
      # gnu_lib && generic
      c_headers 'pthread.h', 'xstrtol.h', 'xreadlink.h', 'fatal-signal.h', 'diacrit.h', 'syslog.h', 'sys/stat.h'

      # autoconf means m4 (unix macro processor)
      language :autoconf
    end

    define_platform 'Win32' do
      c_headers 'windows.h'
      c_keywords 'WM_PAINT', 'ReleaseDC', 'WndProc', :min => 2
    end

    define_platform 'WPF' do
      filenames '\.xaml$'
    end

    define_platform 'Dot_NET' do
      language :csharp, :min_percent => 10
    end

    define_platform 'VisualBasic' do
      language :visualbasic, :min_percent => 5
    end

    define_platform 'ASP_NET' do
      filenames('\.(aspx|ascx|ashx|asax|axd)$')
    end

    define_platform 'Ruby' do
      language :ruby, :min_percent => 15
    end

    define_platform 'Rails' do
      _and do
        gestalt(:platform, 'Ruby')
        ruby_keywords("RAILS_ROOT")
      end
    end

    define_platform 'Java' do
      language :java, :min_percent => 15
    end

    define_platform 'Javascript' do
      language :javascript, :min_percent => 20
    end

    define_platform 'JQuery' do
      filenames 'jquery-\d.\d.\d.min.js'
    end

    define_platform 'SpringFramework' do
      _and do
        gestalt(:platform,'Java')
        filenames('spring\.jar$')
      end
    end

    define_platform 'XWindows' do
      c_headers 'Xlib.h', 'X11\/xpm.h', 'X11/Xlib.h'
    end

    define_platform 'Mac' do
      # apple events
      c_keywords 'AppleEvent', 'AEBuildAppleEvent'

      # plist is a mac thing, right?
      filenames '\.plist'
    end

    define_platform 'PHP' do
      language :php, :min_percent => 15
    end

    define_platform 'WxWidgets' do
      c_headers 'wx/window.h'
    end

		define_platform 'ZendFramework' do
      _and do
        gestalt(:platform, 'PHP')
        php_keywords('Zend_Controller_Action')
      end
		end

		define_platform 'Symfony' do
			_and do
        gestalt(:platform, 'PHP')
        php_keywords('sfCore', 'sfConfig')
      end
    end

		define_platform 'Pear' do
      _and do
        gestalt(:platform, 'PHP')
        _or do
          filenames('\bpackage\.xml(\.tpl)?$')
          xml_keywords('pear.php.net/dtd/package-2.0')
        end
      end
		end

		define_platform 'Moodle' do
			_and do
				gestalt(:platform, 'PHP')
				php_keywords("moodle")
      end
		end

    define_platform 'SQL' do
      language :sql
    end

    define_platform 'MySQL' do
      php_keywords('mysql_connect')
    end

    define_platform 'PostgreSQL' do
      php_keywords('pg_connect')
    end

		define_platform 'Python' do
			language :python, :min_percent => 15
		end

		define_platform 'Perl' do
			language :perl, :min_percent => 20
		end

		define_platform 'Scripting' do
			gestalt(:platform, 'Javascript')
			gestalt(:platform, 'Perl')
			gestalt(:platform, 'PHP')
			gestalt(:platform, 'Python')
			gestalt(:platform, 'Ruby')
		end

		define_platform 'CakePHP' do
			_and do
        gestalt(:platform, 'PHP')
				php_keywords('CAKE_CORE_INCLUDE_PATH')
      end
		end

		define_platform 'KDE' do
			c_headers 'KDEInit.h', 'kdeversion.h'
		end

		define_platform 'GTK' do
			c_keywords 'gtk_init', 'gtk_main', 'gtk_window_new', 'GtkWidget'
		end

		define_platform 'Drupal' do
			_and do
				gestalt(:platform, 'PHP')
				_or do
					php_keywords('drupal_set_message')
					php_keywords('drupal_render')
					php_keywords('Drupal', :min => 3)
        end
      end
		end

		define_platform 'MSDos' do
			c_keywords '__MSDOS__', 'MSDOS', :min => 2
    end

    define_platform 'EclipsePlatform' do
      java_import /org\.eclipse\./
    end


    ############################### Tools ###############################

    define_tool 'VisualStudio' do
      filenames '\.(sln|vcproj|vsproj|csproj|vbproj|vbp)$'
    end

    define_tool 'Eclipse' do
      filenames '\.(project|classpath)$'
    end

    define_tool 'NetBeans' do
      filenames '\bnbplatform\b'
      filenames '\.nbm$'
    end


    ########################## Java Jars ###############################

		define_java_jar do
      find_filenames /([^\\^\/]*\.(jar|JAR))/, :name_from_match => 1
		end


    ######################## Java Imports ##############################

    define_java_import do
      find_java_imports
    end


    ############################ ARM ###################################

    define_platform 'arm' do
      makefile_keywords '\b-mabi\b','\barmcc\b'
      assembler_keywords '\bsmlal\b', '\bsmulw\b', '\borrs\b'
      gestalt(:platform, 'arm_neon')
    end

    ########################## ARM NEON ################################

    define_platform 'arm_neon' do
      assembler_keywords '\bvld1.\d\d\b', '\bvld1.\d\d\b','\bvmov\b','\bvmov.u8\b'
      makefile_keywords '\bneon\b','\bNEON\b'
    end

	end
end
