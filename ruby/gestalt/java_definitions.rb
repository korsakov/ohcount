module Ohcount
	module Gestalt

		# Java Application Servers

		define_platform 'glassfish' do
			_and do
				gestalt(:platform, 'java')
				_or do
					find_filenames /\b(sun\-web|sun\-ejb\-jar|sun\-application(\-client))\.xml\b/
					maven_dependency /^org.glassfish\b/
				end
			end
		end

		define_platform 'jboss' do
			_and do
				gestalt(:platform, 'java')
				_or do
					find_filenames /\bjboss(\-app|cmp\-jdbc|\-web|\-build|\-client)\.xml\b/
					maven_dependency /^org.jboss\b/
				end
			end
		end

		define_platform 'weblogic' do
			_and do
				gestalt(:platform, 'java')
				_or do
					find_filenames /\bweblogic(\-ejb\-jar|\-ra|\-application|\-cmp\-rdbms\jar)\.xml\b/
					maven_plugin /^org\.codehaus\.mojo\b/, /^weblogic\-maven\-plugin\b/
				end
			end
		end

		define_platform 'jonas' do
			_and do
				gestalt(:platform, 'java')
				find_filenames /\bjonas\-ejb\-jar\.xml\b/
			end
		end

		define_platform 'websphere' do
			_and do
				gestalt(:platform, 'java')
				find_filenames /\bibm\-(application|web|webservices|webservicesclient)\-.+\.xmi$/
			end
		end

		define_platform 'tomcat' do
			_and do
				gestalt(:platform, 'java')
				_or do
					java_import /^org\.apache\.tomcat\b/
					maven_dependency /^org\.apache\.tomcat\b/
				end
			end
		end

		define_platform 'appserver' do
			_or do
				gestalt(:platform, 'glassfish')
				gestalt(:platform, 'jboss')
				gestalt(:platform, 'weblogic')
				gestalt(:platform, 'tomcat')
				gestalt(:platform, 'jonas')
				gestalt(:platform, 'websphere')
			end
		end

		define_platform 'ejb2' do
			_and do
				gestalt(:platform, 'java')
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
		define_platform 'ejb3.1' do
			_and do
				gestalt(:platform, 'java')
				_or do
					java_keywords '@Schedule', '@Singleton', '@Asynchronous'
					java_keywords /@EJB\(.*\bmappedName\s*=\s*"java:(global|app|module)\/.+".*\)/
					java_keywords /\blookup\(\s*"java:(global|app|module)\/.+"\s*\)/
				end
			end
		end
		# Next, look for the basic attributes that can mean either EJB 3.0 or 3.1
		define_platform 'ejb3+' do
			_and do
				gestalt(:platform, 'java')
				_or do
					gestalt(:platform, 'ejb3.1')
					java_keywords '@EJB', '@Stateless', '@Statefull', '@Entity', '@Remote', '@Local', '@BusinessMethod'
					java_import /^javax\.persistence\b/
				end
			end
		end
		# Finally, if we found EJB3+ and not EJB 3.1, then you must be using EJB 3.0 only.
		define_platform 'ejb3.0' do
			_and do
				gestalt(:platform, 'ejb3+')
				_not { gestalt(:platform, 'ejb3.1') }
			end
		end

		define_platform 'servlet' do
			_and do
				gestalt(:platform, 'java')
				_or do
					java_import /^javax\.servlet\b/
					maven_dependency /^javax\.servlet\b/
				end
			end
		end

		define_platform 'struts' do
			_and do
				gestalt(:platform, 'java')
				_or do
					filenames('\bstruts(\-config)?\.xml$', '\bstruts\.jar$')
					java_import /^org\.apache\.struts\b/
					maven_dependency /^org\.apache\.struts\b/
				end
			end
		end

    define_platform 'springframework' do
      _and do
        gestalt(:platform,'java')
				_or do
					filenames('spring\.jar$')
					java_import /^org\.springframework\b/
					maven_dependency /^org\.springframework\b/
				end
      end
    end

		define_platform 'jsf' do
			_and do
				gestalt(:platform, 'java')
				_or do
					java_import /^javax\.faces\b/
					maven_dependency /^javax\.faces\b/
				end
			end
		end

		define_platform 'googlewebtoolkit' do
			_and do
				gestalt(:platform, 'java')
				java_import /^com\.google\.gwt\b/
			end
		end

		# Java Persistence Frameworks

		define_platform 'hibernate' do
			_and do
				gestalt(:platform, 'java')
				_or do
					filenames '\bhibernate\d\.jar$'
					java_import /^org\.hibernate\b/
					maven_dependency 'org.hibernate'
				end
			end
		end

		define_platform 'jpa' do
			_and do
				gestalt(:platform, 'java')
				java_import /^javax\.persistence\b/
			end
		end

		define_platform 'toplink' do
			_and do
				gestalt(:platform, 'java')
				java_import /^oracle\.toplink\b/
			end
		end

		define_platform 'castor' do
			_and do
				gestalt(:platform, 'java')
				java_import /^org\.exolab\.castor\b/
			end
		end

		define_platform 'db4o' do
			_and do
				gestalt(:platform, 'java')
				java_import /^com\.db4o\b/
			end
		end

		# Java Enterprise Service Buses

		define_platform 'openesb' do
			_and do
				gestalt(:platform, 'java')
				java_import /^org\.openesb\b/
			end
		end

		define_platform 'muleesb' do
			_and do
				gestalt(:platform, 'java')
				java_import /^org\.mule\b/
			end
		end

		define_platform 'servicemix' do
			_and do
				gestalt(:platform, 'java')
				_or do
					java_import /^org\.apache\.servicemix\b/
					maven_dependency /^org.apache.servicemix\b/
				end
			end
		end

		define_platform 'jbossesb' do
			_and do
				gestalt(:platform, 'java')
				java_import /^org\.jboss\.soa\.esb\b/
			end
		end

		define_platform 'openesb' do
			_and do
				gestalt(:platform, 'java')
				java_import /^org\.openesb\b/
			end
		end

		# Other Java Technologies

		define_platform 'opensso' do
			_and do
				gestalt(:platform, 'java')
				_or do
					filenames '\bopensso\.war$'
					java_import /^com\.sun\.identity\.(authentication|agents)\b/
				end
			end
		end

		define_platform 'maven' do
			_and do
				gestalt(:platform, 'java')
				find_filenames /\bpom\.xml$/
			end
		end

	end
end
