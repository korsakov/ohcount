module Ohcount
	module Gestalt

		define_java_jar do
      find_filenames /([^\\^\/]*\.(jar|JAR))/, :name_from_match => 1
		end

    define_java_import do
      find_java_imports
    end

		# Java Application Servers

		define_platform 'GlassFish' do
			_and do
				gestalt(:platform, 'Java')
				_or do
					find_filenames /\b(sun\-web|sun\-ejb\-jar|sun\-application(\-client))\.xml\b/
					maven_dependency /^org.glassfish\b/
				end
			end
		end

		define_platform 'JBoss' do
			_and do
				gestalt(:platform, 'Java')
				_or do
					find_filenames /\bjboss(\-app|cmp\-jdbc|\-web|\-build|\-client)\.xml\b/
					maven_dependency /^org.jboss\b/
				end
			end
		end

		define_platform 'WebLogic' do
			_and do
				gestalt(:platform, 'Java')
				_or do
					find_filenames /\bweblogic(\-ejb\-jar|\-ra|\-application|\-cmp\-rdbms\jar)\.xml\b/
					maven_plugin /^org\.codehaus\.mojo\b/, /^weblogic\-maven\-plugin\b/
				end
			end
		end

		define_platform 'Jonas' do
			_and do
				gestalt(:platform, 'Java')
				find_filenames /\bjonas\-ejb\-jar\.xml\b/
			end
		end

		define_platform 'WebSphere' do
			_and do
				gestalt(:platform, 'Java')
				find_filenames /\bibm\-(application|web|webservices|webservicesclient)\-.+\.xmi$/
			end
		end

		define_platform 'Tomcat' do
			_and do
				gestalt(:platform, 'Java')
				_or do
					java_import /^org\.apache\.tomcat\b/
					maven_dependency /^org\.apache\.tomcat\b/
				end
			end
		end

		define_platform 'AppServer' do
			_or do
				gestalt(:platform, 'GlassFish')
				gestalt(:platform, 'JBoss')
				gestalt(:platform, 'WebLogic')
				gestalt(:platform, 'Tomcat')
				gestalt(:platform, 'Jonas')
				gestalt(:platform, 'WebSphere')
			end
		end

		define_platform 'EJB2' do
			_and do
				gestalt(:platform, 'Java')
				_or do
					find_filenames /(.+\-)ejb\-jar\.xml\b/
					java_keywords 'EJBHome', 'EJBRemote', 'SessionBean'
				end
			end
		end

		# Caution! The EJB platform definitions are senstive to their order -- do not reorder!
		# The gestalt engine iterates over definitions in the order they are defined.
		#
		# First, look for the subset of new features that definitely indicate EJB 3.1
		define_platform 'EJB3.1' do
			_and do
				gestalt(:platform, 'Java')
				_or do
					java_keywords '@Schedule', '@Singleton', '@Asynchronous'
					java_keywords /@EJB\(.*\bmappedName\s*=\s*"java:(global|app|module)\/.+".*\)/
					java_keywords /\blookup\(\s*"java:(global|app|module)\/.+"\s*\)/
				end
			end
		end
		# Next, look for the basic attributes that can mean either EJB 3.0 or 3.1
		define_platform 'EJB3+' do
			_and do
				gestalt(:platform, 'Java')
				_or do
					gestalt(:platform, 'EJB3.1')
					java_keywords '@EJB', '@Stateless', '@Statefull', '@Entity', '@Remote', '@Local', '@BusinessMethod'
					java_import /^javax\.persistence\b/
				end
			end
		end
		# Finally, if we found EJB3+ and not EJB 3.1, then you must be using EJB 3.0 only.
		define_platform 'EJB3.0' do
			_and do
				gestalt(:platform, 'EJB3+')
				_not { gestalt(:platform, 'EJB3.1') }
			end
		end

		define_platform 'Servlet' do
			_and do
				gestalt(:platform, 'Java')
				_or do
					java_import /^javax\.servlet\b/
					maven_dependency /^javax\.servlet\b/
				end
			end
		end

		define_platform 'Struts' do
			_and do
				gestalt(:platform, 'Java')
				_or do
					filenames('\bstruts(\-config)?\.xml$', '\bstruts\.jar$')
					java_import /^org\.apache\.struts\b/
					maven_dependency /^org\.apache\.struts\b/
				end
			end
		end

    define_platform 'SpringFramework' do
      _and do
        gestalt(:platform,'Java')
				_or do
					filenames('spring\.jar$')
					java_import /^org\.springframework\b/
					maven_dependency /^org\.springframework\b/
				end
      end
    end

		define_platform 'JSF' do
			_and do
				gestalt(:platform, 'Java')
				_or do
					java_import /^javax\.faces\b/
					maven_dependency /^javax\.faces\b/
				end
			end
		end

		define_platform 'GoogleWebToolkit' do
			_and do
				gestalt(:platform, 'Java')
				java_import /^com\.google\.gwt\b/
			end
		end

		# Java Persistence Frameworks

		define_platform 'Hibernate' do
			_and do
				gestalt(:platform, 'Java')
				_or do
					filenames '\bhibernate\d\.jar$'
					java_import /^org\.hibernate\b/
					maven_dependency 'org.hibernate'
				end
			end
		end

		define_platform 'JPA' do
			_and do
				gestalt(:platform, 'Java')
				java_import /^javax\.persistence\b/
			end
		end

		define_platform 'TopLink' do
			_and do
				gestalt(:platform, 'Java')
				java_import /^oracle\.toplink\b/
			end
		end

		define_platform 'Castor' do
			_and do
				gestalt(:platform, 'Java')
				java_import /^org\.exolab\.castor\b/
			end
		end

		define_platform 'db4o' do
			_and do
				gestalt(:platform, 'Java')
				java_import /^com\.db4o\b/
			end
		end

		# Java Enterprise Service Buses

		define_platform 'OpenESB' do
			_and do
				gestalt(:platform, 'Java')
				java_import /^org\.openesb\b/
			end
		end

		define_platform 'MuleESB' do
			_and do
				gestalt(:platform, 'Java')
				java_import /^org\.mule\b/
			end
		end

		define_platform 'ServiceMIX' do
			_and do
				gestalt(:platform, 'Java')
				_or do
					java_import /^org\.apache\.servicemix\b/
					maven_dependency /^org.apache.servicemix\b/
				end
			end
		end

		define_platform 'JBossESB' do
			_and do
				gestalt(:platform, 'Java')
				java_import /^org\.jboss\.soa\.esb\b/
			end
		end

		define_platform 'OpenESB' do
			_and do
				gestalt(:platform, 'Java')
				java_import /^org\.openesb\b/
			end
		end

		# Other Java Technologies

		define_platform 'OpenSSO' do
			_and do
				gestalt(:platform, 'Java')
				_or do
					filenames '\bopensso\.war$'
					java_import /^com\.sun\.identity\.(authentication|agents)\b/
				end
			end
		end

		define_platform 'Maven' do
			_and do
				gestalt(:platform, 'Java')
				find_filenames /\bpom\.xml$/
			end
		end

		############################ Jasper ################################

    define_platform 'jasper_jr' do
			maven_dependency /jasperreports/
      java_keywords '\bnet\.sf\.jasperreports\b'
    end

    define_platform 'jasper_jsce' do
      java_keywords '\bcom\.jaspersoft\.jasperserver\b'
    end

    define_platform 'jasper_ji' do
      java_keywords '\bcom\.jaspersoft\.ji'
    end

	end
end
