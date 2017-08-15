puppet	code	class bob::open_ldap {
puppet	blank	
puppet	code		define foo::server (
puppet	code			$argsfile = undef,
puppet	code			$bdb_cachesize = '',
puppet	code			$bdb_checkpoint = '',
puppet	code			$bdb_directory = undef,
puppet	code			$bdb_idlcachesize = '',
puppet	code			$bdb_rootdn,
puppet	code			$bdb_rootpw,
puppet	code			$bdb_shm_key = '',
puppet	code			$bdb_suffix,
puppet	code			$conf_path = undef,
puppet	code			$conf_dir = undef,
puppet	code			$enable = false,
puppet	code			$include = [],
puppet	code			$includepath = undef,
puppet	code			$modulepath = '',
puppet	code			$modules = [], 
puppet	code			$package = undef,
puppet	code			$pidfile = undef,
puppet	code			$sysconf_path = undef
puppet	code			) {
puppet	blank	
puppet	code			$resource_name = "bob_openldap_server"
puppet	blank	
puppet	code			if($name != "params") {
puppet	code				fail("${resource_name}: This function is a singleton. Make sure the resource name is 'params'.")
puppet	code			}
puppet	blank	
puppet	code			case $operatingsystem {
puppet	code				Fedora: {
puppet	code					case $operatingsystemrelease {
puppet	code						/^(12|13)$/: {
puppet	code							if(!$argsfile) { $_argsfile = "/var/run/openldap/slapd.args" }
puppet	code							if(!$bdb_directory) { $_bdb_directory = "/var/lib/ldap" }
puppet	code							if(!$conf_path) { $_conf_path = "/etc/openldap/slapd.conf" }
puppet	code							if(!$conf_dir) { $_conf_dir = "/etc/openldap/slapd.d" }
puppet	code							if(!$package) { $_package = ["openldap-servers"] }
puppet	code							if(!$pidfile) { $_pidfile = "/var/run/openldap/slapd.pid" }
puppet	code							if(!$service) { $_service = "slapd" }
puppet	code							if(!$sysconf_path) { $_sysconf_path = "/etc/sysconfig/ldap" }
puppet	code						}
puppet	code					}
puppet	code				}
puppet	code			}
puppet	blank	
puppet	comment			# Presume the OS did not match and because these args are necessary, just 
puppet	comment			# bail with an error.
puppet	code			if(!($_argsfile and $_bdb_directory and $_pidfile and $_conf_path and 
puppet	code					 $_package and $_service and $_sysconf_path and $_conf_dir)) { 
puppet	code				fail("${resource_name}: Unsupported operating system: ${operatingsystem} version ${operatingsystemrelease} and you have not setup the args for: argsfile, bdb_directory, conf_dir, conf_path, package, pidfile, sysconf_path and service.")
puppet	code			}
puppet	blank	
puppet	comment			# Fix paths - add forward slashes at the end of strings without them
puppet	code			$_includepath = regsubst($includepath, '([^/])$', '\1/')
puppet	code			$_dbconf_path = "${_bdb_directory}/DB_CONFIG"
puppet	blank	
puppet	comment			# ...
puppet	code			file {
puppet	code				$_conf_path:
puppet	code					content => template("bob_openldap/slapd.conf"),
puppet	code					require => Package[$_package],
puppet	code					owner => "ldap",
puppet	code					group => "root",
puppet	code					mode => "0440",
puppet	code					notify => Service[$_service];
puppet	code				$_sysconf_path:
puppet	code					content => template("bob_openldap/ldap.sysconf"),
puppet	code					require => Package[$_package],
puppet	code					owner => "root",
puppet	code					group => "root",
puppet	code					mode => "0644";
puppet	code				$_conf_dir:
puppet	code					force => true,
puppet	code					ensure => absent,
puppet	code					before => Service[$_service];
puppet	code				$_dbconf_path:
puppet	code					content => "",
puppet	code					notify => Service[$_service];
puppet	code			}
puppet	code			package {
puppet	code				$_package:
puppet	code					ensure => installed;
puppet	code			}
puppet	code			service {
puppet	code				$_service:
puppet	code					ensure => $enable ? {
puppet	code						true => "running",
puppet	code						false => "stopped"
puppet	code					},
puppet	code					enable => $enable,
puppet	code					hasstatus => true,
puppet	code					require => [ Package[$_package], File[$_conf_path] ];
puppet	code			}
puppet	code		}
puppet	blank	
puppet	code		define client (
puppet	code			$base,
puppet	code			$network_timeout = '',
puppet	code			$path = undef,
puppet	code			$timeout = '',
puppet	code			$binddn = '',
puppet	code			$tls_cacertdir = undef,
puppet	code			$uri
puppet	code			) {
puppet	blank	
puppet	code			$resource_name = "bob_openldap_client"
puppet	blank	
puppet	code			if($name != "params") {
puppet	code				fail("${resource_name}: This function is a singleton. Make sure the resource name is 'params'.")
puppet	code			}
puppet	blank	
puppet	code			case $operatingsystem {
puppet	code				Fedora: {
puppet	code					case $operatingsystemrelease {
puppet	code						/^(12|13)$/: {
puppet	code							if(!$tls_cacertdir) { $_tls_cacertdir = "/etc/openldap/cacerts" }
puppet	code							if(!$path) { $_path = "/etc/openldap/ldap.conf" }
puppet	code						}
puppet	code					}
puppet	code				}
puppet	code			}
puppet	blank	
puppet	comment			# Presume the OS did not match and because these args are necessary, just 
puppet	comment			# bail with an error.
puppet	code			if(!($_tls_cacertdir and $_path)) { 
puppet	code				fail("${resource_name}: Unsupported operating system: ${operatingsystem} version ${operatingsystemrelease} and you have not setup the args for: tls_cacertdir, path.")
puppet	code			}
puppet	blank	
puppet	comment			# Fix some vars, ready for templating
puppet	code			$_base = $base
puppet	code			$_binddn = $binddn
puppet	code			$_network_timeout = $network_timeout
puppet	code			$_timeout = $timeout
puppet	code			$_uri = $uri
puppet	blank	
puppet	code			file {
puppet	code				$_path:
puppet	code					content => template("bob_openldap/ldap.conf")
puppet	code			}
puppet	blank	
puppet	code		}
puppet	blank	
puppet	code	}
