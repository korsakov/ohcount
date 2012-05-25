class bob::open_ldap {

	define foo::server (
		$argsfile = undef,
		$bdb_cachesize = '',
		$bdb_checkpoint = '',
		$bdb_directory = undef,
		$bdb_idlcachesize = '',
		$bdb_rootdn,
		$bdb_rootpw,
		$bdb_shm_key = '',
		$bdb_suffix,
		$conf_path = undef,
		$conf_dir = undef,
		$enable = false,
		$include = [],
		$includepath = undef,
		$modulepath = '',
		$modules = [], 
		$package = undef,
		$pidfile = undef,
		$sysconf_path = undef
		) {
	
		$resource_name = "bob_openldap_server"
	
		if($name != "params") {
			fail("${resource_name}: This function is a singleton. Make sure the resource name is 'params'.")
		}
	
		case $operatingsystem {
			Fedora: {
				case $operatingsystemrelease {
					/^(12|13)$/: {
						if(!$argsfile) { $_argsfile = "/var/run/openldap/slapd.args" }
						if(!$bdb_directory) { $_bdb_directory = "/var/lib/ldap" }
						if(!$conf_path) { $_conf_path = "/etc/openldap/slapd.conf" }
						if(!$conf_dir) { $_conf_dir = "/etc/openldap/slapd.d" }
						if(!$package) { $_package = ["openldap-servers"] }
						if(!$pidfile) { $_pidfile = "/var/run/openldap/slapd.pid" }
						if(!$service) { $_service = "slapd" }
						if(!$sysconf_path) { $_sysconf_path = "/etc/sysconfig/ldap" }
					}
				}
			}
		}
	
		# Presume the OS did not match and because these args are necessary, just 
		# bail with an error.
		if(!($_argsfile and $_bdb_directory and $_pidfile and $_conf_path and 
				 $_package and $_service and $_sysconf_path and $_conf_dir)) { 
			fail("${resource_name}: Unsupported operating system: ${operatingsystem} version ${operatingsystemrelease} and you have not setup the args for: argsfile, bdb_directory, conf_dir, conf_path, package, pidfile, sysconf_path and service.")
		}
	
		# Fix paths - add forward slashes at the end of strings without them
		$_includepath = regsubst($includepath, '([^/])$', '\1/')
		$_dbconf_path = "${_bdb_directory}/DB_CONFIG"
	
		# ...
		file {
			$_conf_path:
				content => template("bob_openldap/slapd.conf"),
				require => Package[$_package],
				owner => "ldap",
				group => "root",
				mode => "0440",
				notify => Service[$_service];
			$_sysconf_path:
				content => template("bob_openldap/ldap.sysconf"),
				require => Package[$_package],
				owner => "root",
				group => "root",
				mode => "0644";
			$_conf_dir:
				force => true,
				ensure => absent,
				before => Service[$_service];
			$_dbconf_path:
				content => "",
				notify => Service[$_service];
		}
		package {
			$_package:
				ensure => installed;
		}
		service {
			$_service:
				ensure => $enable ? {
					true => "running",
					false => "stopped"
				},
				enable => $enable,
				hasstatus => true,
				require => [ Package[$_package], File[$_conf_path] ];
		}
	}
	
	define client (
		$base,
		$network_timeout = '',
		$path = undef,
		$timeout = '',
		$binddn = '',
		$tls_cacertdir = undef,
		$uri
		) {
	
		$resource_name = "bob_openldap_client"
	
		if($name != "params") {
			fail("${resource_name}: This function is a singleton. Make sure the resource name is 'params'.")
		}
	
		case $operatingsystem {
			Fedora: {
				case $operatingsystemrelease {
					/^(12|13)$/: {
						if(!$tls_cacertdir) { $_tls_cacertdir = "/etc/openldap/cacerts" }
						if(!$path) { $_path = "/etc/openldap/ldap.conf" }
					}
				}
			}
		}
	
		# Presume the OS did not match and because these args are necessary, just 
		# bail with an error.
		if(!($_tls_cacertdir and $_path)) { 
			fail("${resource_name}: Unsupported operating system: ${operatingsystem} version ${operatingsystemrelease} and you have not setup the args for: tls_cacertdir, path.")
		}
	
		# Fix some vars, ready for templating
		$_base = $base
		$_binddn = $binddn
		$_network_timeout = $network_timeout
		$_timeout = $timeout
		$_uri = $uri
	
		file {
			$_path:
				content => template("bob_openldap/ldap.conf")
		}
	
	}

}
