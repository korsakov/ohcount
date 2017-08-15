perl	code	package PAR::Dist;
perl	code	require Exporter;
perl	code	use vars qw/$VERSION @ISA @EXPORT @EXPORT_OK/;
perl	blank	
perl	code	$VERSION    = '0.29';
perl	code	@ISA	    = 'Exporter';
perl	code	@EXPORT	    = qw/
perl	code	  blib_to_par
perl	code	  install_par
perl	code	  uninstall_par
perl	code	  sign_par
perl	code	  verify_par
perl	code	  merge_par
perl	code	  remove_man
perl	code	  get_meta
perl	code	  generate_blib_stub
perl	code	/;
perl	blank	
perl	code	@EXPORT_OK = qw/
perl	code	  parse_dist_name
perl	code	  contains_binaries
perl	code	/;
perl	blank	
perl	code	use strict;
perl	code	use Carp qw/carp croak/;
perl	code	use File::Spec;
perl	blank	
perl	comment	=head1 NAME
perl	blank	
perl	comment	PAR::Dist - Create and manipulate PAR distributions
perl	blank	
perl	comment	=head1 VERSION
perl	blank	
perl	comment	This document describes version 0.29 of PAR::Dist, released Feb  6, 2008.
perl	blank	
perl	comment	=head1 SYNOPSIS
perl	blank	
perl	comment	As a shell command:
perl	blank	
perl	comment	    % perl -MPAR::Dist -eblib_to_par
perl	blank	
perl	comment	In programs:
perl	blank	
perl	comment	    use PAR::Dist;
perl	blank	
perl	comment	    my $dist = blib_to_par();	# make a PAR file using ./blib/
perl	comment	    install_par($dist);		# install it into the system
perl	comment	    uninstall_par($dist);	# uninstall it from the system
perl	comment	    sign_par($dist);		# sign it using Module::Signature
perl	comment	    verify_par($dist);		# verify it using Module::Signature
perl	blank	
perl	comment	    install_par("http://foo.com/DBI-1.37-MSWin32-5.8.0.par"); # works too
perl	comment	    install_par("http://foo.com/DBI-1.37"); # auto-appends archname + perlver
perl	comment	    install_par("cpan://SMUELLER/PAR-Packer-0.975"); # uses CPAN author directory
perl	blank	
perl	comment	=head1 DESCRIPTION
perl	blank	
perl	comment	This module creates and manipulates I<PAR distributions>.  They are
perl	comment	architecture-specific B<PAR> files, containing everything under F<blib/>
perl	comment	of CPAN distributions after their C<make> or C<Build> stage, a
perl	comment	F<META.yml> describing metadata of the original CPAN distribution, 
perl	comment	and a F<MANIFEST> detailing all files within it.  Digitally signed PAR
perl	comment	distributions will also contain a F<SIGNATURE> file.
perl	blank	
perl	comment	The naming convention for such distributions is:
perl	blank	
perl	comment	    $NAME-$VERSION-$ARCH-$PERL_VERSION.par
perl	blank	
perl	comment	For example, C<PAR-Dist-0.01-i386-freebsd-5.8.0.par> corresponds to the
perl	comment	0.01 release of C<PAR-Dist> on CPAN, built for perl 5.8.0 running on
perl	comment	C<i386-freebsd>.
perl	blank	
perl	comment	=head1 FUNCTIONS
perl	blank	
perl	comment	Several functions are exported by default.  Unless otherwise noted,
perl	comment	they can take either a hash of
perl	comment	named arguments, a single argument (taken as C<$path> by C<blib_to_par>
perl	comment	and C<$dist> by other functions), or no arguments (in which case
perl	comment	the first PAR file in the current directory is used).
perl	blank	
perl	comment	Therefore, under a directory containing only a single F<test.par>, all
perl	comment	invocations below are equivalent:
perl	blank	
perl	comment	    % perl -MPAR::Dist -e"install_par( dist => 'test.par' )"
perl	comment	    % perl -MPAR::Dist -e"install_par( 'test.par' )"
perl	comment	    % perl -MPAR::Dist -einstall_par;
perl	blank	
perl	comment	If C<$dist> resembles a URL, C<LWP::Simple::mirror> is called to mirror it
perl	comment	locally under C<$ENV{PAR_TEMP}> (or C<$TEMP/par/> if unspecified), and the
perl	comment	function will act on the fetched local file instead.  If the URL begins
perl	comment	with C<cpan://AUTHOR/>, it will be expanded automatically to the author's CPAN
perl	comment	directory (e.g. C<http://www.cpan.org/modules/by-authors/id/A/AU/AUTHOR/>).
perl	blank	
perl	comment	If C<$dist> does not have a file extension beginning with a letter or
perl	comment	underscore, a dash and C<$suffix> ($ARCH-$PERL_VERSION.par by default)
perl	comment	will be appended to it.
perl	blank	
perl	comment	=head2 blib_to_par
perl	blank	
perl	comment	Takes key/value pairs as parameters or a single parameter indicating the
perl	comment	path that contains the F<blib/> subdirectory.
perl	blank	
perl	comment	Builds a PAR distribution from the F<blib/> subdirectory under C<path>, or
perl	comment	under the current directory if unspecified.  If F<blib/> does not exist,
perl	comment	it automatically runs F<Build>, F<make>, F<Build.PL> or F<Makefile.PL> to
perl	comment	create it.
perl	blank	
perl	comment	Returns the filename or the generated PAR distribution.
perl	blank	
perl	comment	Valid parameters are:
perl	blank	
perl	comment	=over 2
perl	blank	
perl	comment	=item path
perl	blank	
perl	comment	Sets the path which contains the F<blib/> subdirectory from which the PAR
perl	comment	distribution will be generated.
perl	blank	
perl	comment	=item name, version, suffix
perl	blank	
perl	comment	These attributes set the name, version and platform specific suffix
perl	comment	of the distribution. Name and version can be automatically
perl	comment	determined from the distributions F<META.yml> or F<Makefile.PL> files.
perl	blank	
perl	comment	The suffix is generated from your architecture name and your version of
perl	comment	perl by default.
perl	blank	
perl	comment	=item dist
perl	blank	
perl	comment	The output filename for the PAR distribution.
perl	blank	
perl	comment	=back
perl	blank	
perl	comment	=cut
perl	blank	
perl	code	sub blib_to_par {
perl	code	    @_ = (path => @_) if @_ == 1;
perl	blank	
perl	code	    my %args = @_;
perl	code	    require Config;
perl	blank	
perl	blank	
perl	comment	    # don't use 'my $foo ... if ...' it creates a static variable!
perl	code	    my $dist;
perl	code	    my $path	= $args{path};
perl	code	    $dist	= File::Spec->rel2abs($args{dist}) if $args{dist};
perl	code	    my $name	= $args{name};
perl	code	    my $version	= $args{version};
perl	code	    my $suffix	= $args{suffix} || "$Config::Config{archname}-$Config::Config{version}.par";
perl	code	    my $cwd;
perl	blank	
perl	code	    if (defined $path) {
perl	code	        require Cwd;
perl	code	        $cwd = Cwd::cwd();
perl	code	        chdir $path;
perl	code	    }
perl	blank	
perl	code	    _build_blib() unless -d "blib";
perl	blank	
perl	code	    my @files;
perl	code	    open MANIFEST, ">", File::Spec->catfile("blib", "MANIFEST") or die $!;
perl	code	    open META, ">", File::Spec->catfile("blib", "META.yml") or die $!;
perl	blank	
perl	code	    require File::Find;
perl	code	    File::Find::find( sub {
perl	code	        next unless $File::Find::name;
perl	code	        (-r && !-d) and push ( @files, substr($File::Find::name, 5) );
perl	code	    } , 'blib' );
perl	blank	
perl	code	    print MANIFEST join(
perl	code		"\n",
perl	code		'    <!-- accessible as jar:file:///NAME.par!/MANIFEST in compliant browsers -->',
perl	code		(sort @files),
perl	code		q(    # <html><body onload="var X=document.body.innerHTML.split(/\n/);var Y='<iframe src=&quot;META.yml&quot; style=&quot;float:right;height:40%;width:40%&quot;></iframe><ul>';for(var x in X){if(!X[x].match(/^\s*#/)&&X[x].length)Y+='<li><a href=&quot;'+X[x]+'&quot;>'+X[x]+'</a>'}document.body.innerHTML=Y">)
perl	code	    );
perl	code	    close MANIFEST;
perl	blank	
perl	code	    if (open(OLD_META, "META.yml")) {
perl	code	        while (<OLD_META>) {
perl	code	            if (/^distribution_type:/) {
perl	code	                print META "distribution_type: par\n";
perl	code	            }
perl	code	            else {
perl	code	                print META $_;
perl	code	            }
perl	blank	
perl	code	            if (/^name:\s+(.*)/) {
perl	code	                $name ||= $1;
perl	code	                $name =~ s/::/-/g;
perl	code	            }
perl	code	            elsif (/^version:\s+.*Module::Build::Version/) {
perl	code	                while (<OLD_META>) {
perl	code	                    /^\s+original:\s+(.*)/ or next;
perl	code	                    $version ||= $1;
perl	code	                    last;
perl	code	                }
perl	code	            }
perl	code	            elsif (/^version:\s+(.*)/) {
perl	code	                $version ||= $1;
perl	code	            }
perl	code	        }
perl	code	        close OLD_META;
perl	code	        close META;
perl	code	    }
perl	blank	
perl	code	    if ((!$name or !$version) and open(MAKEFILE, "Makefile")) {
perl	code	        while (<MAKEFILE>) {
perl	code	            if (/^DISTNAME\s+=\s+(.*)$/) {
perl	code	                $name ||= $1;
perl	code	            }
perl	code	            elsif (/^VERSION\s+=\s+(.*)$/) {
perl	code	                $version ||= $1;
perl	code	            }
perl	code	        }
perl	code	    }
perl	blank	
perl	code	    if (not defined($name) or not defined($version)) {
perl	comment	        # could not determine name or version. Error.
perl	code	        my $what;
perl	code	        if (not defined $name) {
perl	code	            $what = 'name';
perl	code	            $what .= ' and version' if not defined $version;
perl	code	        }
perl	code	        elsif (not defined $version) {
perl	code	            $what = 'version';
perl	code	        }
perl	blank	
perl	code	        carp("I was unable to determine the $what of the PAR distribution. Please create a Makefile or META.yml file from which we can infer the information or just specify the missing information as an option to blib_to_par.");
perl	code	        return();
perl	code	    }
perl	blank	
perl	code	    $name =~ s/\s+$//;
perl	code	    $version =~ s/\s+$//;
perl	blank	
perl	code	    my $file = "$name-$version-$suffix";
perl	code	    unlink $file if -f $file;
perl	blank	
perl	code	    print META << "YAML" if fileno(META);
perl	code	name: $name
perl	code	version: $version
perl	code	build_requires: {}
perl	code	conflicts: {}
perl	code	dist_name: $file
perl	code	distribution_type: par
perl	code	dynamic_config: 0
perl	code	generated_by: 'PAR::Dist version $PAR::Dist::VERSION'
perl	code	license: unknown
perl	code	YAML
perl	code	    close META;
perl	blank	
perl	code	    mkdir('blib', 0777);
perl	code	    chdir('blib');
perl	code	    _zip(dist => File::Spec->catfile(File::Spec->updir, $file)) or die $!;
perl	code	    chdir(File::Spec->updir);
perl	blank	
perl	code	    unlink File::Spec->catfile("blib", "MANIFEST");
perl	code	    unlink File::Spec->catfile("blib", "META.yml");
perl	blank	
perl	code	    $dist ||= File::Spec->catfile($cwd, $file) if $cwd;
perl	blank	
perl	code	    if ($dist and $file ne $dist) {
perl	code	        rename( $file => $dist );
perl	code	        $file = $dist;
perl	code	    }
perl	blank	
perl	code	    my $pathname = File::Spec->rel2abs($file);
perl	code	    if ($^O eq 'MSWin32') {
perl	code	        $pathname =~ s!\\!/!g;
perl	code	        $pathname =~ s!:!|!g;
perl	code	    };
perl	code	    print << ".";
perl	code	Successfully created binary distribution '$file'.
perl	code	Its contents are accessible in compliant browsers as:
perl	code	    jar:file://$pathname!/MANIFEST
perl	code	.
perl	blank	
perl	code	    chdir $cwd if $cwd;
perl	code	    return $file;
perl	code	}
perl	blank	
perl	code	sub _build_blib {
perl	code	    if (-e 'Build') {
perl	code	        system($^X, "Build");
perl	code	    }
perl	code	    elsif (-e 'Makefile') {
perl	code	        system($Config::Config{make});
perl	code	    }
perl	code	    elsif (-e 'Build.PL') {
perl	code	        system($^X, "Build.PL");
perl	code	        system($^X, "Build");
perl	code	    }
perl	code	    elsif (-e 'Makefile.PL') {
perl	code	        system($^X, "Makefile.PL");
perl	code	        system($Config::Config{make});
perl	code	    }
perl	code	}
perl	blank	
perl	comment	=head2 install_par
perl	blank	
perl	comment	Installs a PAR distribution into the system, using
perl	comment	C<ExtUtils::Install::install_default>.
perl	blank	
perl	comment	Valid parameters are:
perl	blank	
perl	comment	=over 2
perl	blank	
perl	comment	=item dist
perl	blank	
perl	comment	The .par file to install. The heuristics outlined in the B<FUNCTIONS>
perl	comment	section above apply.
perl	blank	
perl	comment	=item prefix
perl	blank	
perl	comment	This string will be prepended to all installation paths.
perl	comment	If it isn't specified, the environment variable
perl	comment	C<PERL_INSTALL_ROOT> is used as a prefix.
perl	blank	
perl	comment	=back
perl	blank	
perl	comment	Additionally, you can use several parameters to change the default
perl	comment	installation destinations. You don't usually have to worry about this
perl	comment	unless you are installing into a user-local directory.
perl	comment	The following section outlines the parameter names and default settings:
perl	blank	
perl	comment	  Parameter         From          To
perl	comment	  inst_lib          blib/lib      $Config{installsitelib} (*)
perl	comment	  inst_archlib      blib/arch     $Config{installsitearch}
perl	comment	  inst_script       blib/script   $Config{installscript}
perl	comment	  inst_bin          blib/bin      $Config{installbin}
perl	comment	  inst_man1dir      blib/man1     $Config{installman1dir}
perl	comment	  inst_man3dir      blib/man3     $Config{installman3dir}
perl	comment	  packlist_read                   $Config{sitearchexp}/auto/$name/.packlist
perl	comment	  packlist_write                  $Config{installsitearch}/auto/$name/.packlist
perl	blank	
perl	comment	The C<packlist_write> parameter is used to control where the F<.packlist>
perl	comment	file is written to. (Necessary for uninstallation.)
perl	comment	The C<packlist_read> parameter specifies a .packlist file to merge in if
perl	comment	it exists. By setting any of the above installation targets to C<undef>,
perl	comment	you can remove that target altogether. For example, passing
perl	comment	C<inst_man1dir => undef, inst_man3dir => undef> means that the contained
perl	comment	manual pages won't be installed. This is not available for the packlists.
perl	blank	
perl	comment	Finally, you may specify a C<custom_targets> parameter. Its value should be
perl	comment	a reference to a hash of custom installation targets such as
perl	blank	
perl	comment	  custom_targets => { 'blib/my_data' => '/some/path/my_data' }
perl	blank	
perl	comment	You can use this to install the F<.par> archives contents to arbitrary
perl	comment	locations.
perl	blank	
perl	comment	If only a single parameter is given, it is treated as the C<dist>
perl	comment	parameter.
perl	blank	
perl	comment	=cut
perl	blank	
perl	code	sub install_par {
perl	code	    my %args = &_args;
perl	code	    _install_or_uninstall(%args, action => 'install');
perl	code	}
perl	blank	
perl	comment	=head2 uninstall_par
perl	blank	
perl	comment	Uninstalls all previously installed contents of a PAR distribution,
perl	comment	using C<ExtUtils::Install::uninstall>.
perl	blank	
perl	comment	Takes almost the same parameters as C<install_par>, but naturally,
perl	comment	the installation target parameters do not apply. The only exception
perl	comment	to this is the C<packlist_read> parameter which specifies the
perl	comment	F<.packlist> file to read the list of installed files from.
perl	comment	It defaults to C<$Config::Config{installsitearch}/auto/$name/.packlist>.
perl	blank	
perl	comment	=cut
perl	blank	
perl	code	sub uninstall_par {
perl	code	    my %args = &_args;
perl	code	    _install_or_uninstall(%args, action => 'uninstall');
perl	code	}
perl	blank	
perl	code	sub _install_or_uninstall {
perl	code	    my %args = &_args;
perl	code	    my $name = $args{name};
perl	code	    my $action = $args{action};
perl	blank	
perl	code	    my %ENV_copy = %ENV;
perl	code	    $ENV{PERL_INSTALL_ROOT} = $args{prefix} if defined $args{prefix};
perl	blank	
perl	code	    require Cwd;
perl	code	    my $old_dir = Cwd::cwd();
perl	blank	
perl	code	    my ($dist, $tmpdir) = _unzip_to_tmpdir( dist => $args{dist}, subdir => 'blib' );
perl	blank	
perl	code	    if ( open (META, File::Spec->catfile('blib', 'META.yml')) ) {
perl	code	        while (<META>) {
perl	code	            next unless /^name:\s+(.*)/;
perl	code	            $name = $1;
perl	code	            $name =~ s/\s+$//;
perl	code	            last;
perl	code	        }
perl	code	        close META;
perl	code	    }
perl	code	    return if not defined $name or $name eq '';
perl	blank	
perl	code	    if (-d 'script') {
perl	code	        require ExtUtils::MY;
perl	code	        foreach my $file (glob("script/*")) {
perl	code	            next unless -T $file;
perl	code	            ExtUtils::MY->fixin($file);
perl	code	            chmod(0555, $file);
perl	code	        }
perl	code	    }
perl	blank	
perl	code	    $name =~ s{::|-}{/}g;
perl	code	    require ExtUtils::Install;
perl	blank	
perl	code	    my $rv;
perl	code	    if ($action eq 'install') {
perl	code	        my $target = _installation_target( File::Spec->curdir, $name, \%args );
perl	code	        my $custom_targets = $args{custom_targets} || {};
perl	code	        $target->{$_} = $custom_targets->{$_} foreach keys %{$custom_targets};
perl	blank	
perl	code	        $rv = ExtUtils::Install::install($target, 1, 0, 0);
perl	code	    }
perl	code	    elsif ($action eq 'uninstall') {
perl	code	        require Config;
perl	code	        $rv = ExtUtils::Install::uninstall(
perl	code	            $args{packlist_read}||"$Config::Config{installsitearch}/auto/$name/.packlist"
perl	code	        );
perl	code	    }
perl	blank	
perl	code	    %ENV = %ENV_copy;
perl	blank	
perl	code	    chdir($old_dir);
perl	code	    File::Path::rmtree([$tmpdir]);
perl	code	    return $rv;
perl	code	}
perl	blank	
perl	comment	# Returns the default installation target as used by
perl	comment	# ExtUtils::Install::install(). First parameter should be the base
perl	comment	# directory containing the blib/ we're installing from.
perl	comment	# Second parameter should be the name of the distribution for the packlist
perl	comment	# paths. Third parameter may be a hash reference with user defined keys for
perl	comment	# the target hash. In fact, any contents that do not start with 'inst_' are
perl	comment	# skipped.
perl	code	sub _installation_target {
perl	code	    require Config;
perl	code	    my $dir = shift;
perl	code	    my $name = shift;
perl	code	    my $user = shift || {};
perl	blank	
perl	comment	    # accepted sources (and user overrides)
perl	code	    my %sources = (
perl	code	      inst_lib => File::Spec->catdir($dir,"blib","lib"),
perl	code	      inst_archlib => File::Spec->catdir($dir,"blib","arch"),
perl	code	      inst_bin => File::Spec->catdir($dir,'blib','bin'),
perl	code	      inst_script => File::Spec->catdir($dir,'blib','script'),
perl	code	      inst_man1dir => File::Spec->catdir($dir,'blib','man1'),
perl	code	      inst_man3dir => File::Spec->catdir($dir,'blib','man3'),
perl	code	      packlist_read => 'read',
perl	code	      packlist_write => 'write',
perl	code	    );
perl	blank	
perl	blank	
perl	comment	    # default targets
perl	code	    my $target = {
perl	code	       read => $Config::Config{sitearchexp}."/auto/$name/.packlist",
perl	code	       write => $Config::Config{installsitearch}."/auto/$name/.packlist",
perl	code	       $sources{inst_lib}
perl	code	            => (_directory_not_empty($sources{inst_archlib}))
perl	code	            ? $Config::Config{installsitearch}
perl	code	            : $Config::Config{installsitelib},
perl	code	       $sources{inst_archlib}   => $Config::Config{installsitearch},
perl	code	       $sources{inst_bin}       => $Config::Config{installbin} ,
perl	code	       $sources{inst_script}    => $Config::Config{installscript},
perl	code	       $sources{inst_man1dir}   => $Config::Config{installman1dir},
perl	code	       $sources{inst_man3dir}   => $Config::Config{installman3dir},
perl	code	    };
perl	blank	
perl	comment	    # Included for future support for ${flavour}perl external lib installation
perl	comment	#    if ($Config::Config{flavour_perl}) {
perl	comment	#        my $ext = File::Spec->catdir($dir, 'blib', 'ext');
perl	comment	#        # from => to
perl	comment	#        $sources{inst_external_lib}    = File::Spec->catdir($ext, 'lib');
perl	comment	#        $sources{inst_external_bin}    = File::Spec->catdir($ext, 'bin');
perl	comment	#        $sources{inst_external_include} = File::Spec->catdir($ext, 'include');
perl	comment	#        $sources{inst_external_src}    = File::Spec->catdir($ext, 'src');
perl	comment	#        $target->{ $sources{inst_external_lib} }     = $Config::Config{flavour_install_lib};
perl	comment	#        $target->{ $sources{inst_external_bin} }     = $Config::Config{flavour_install_bin};
perl	comment	#        $target->{ $sources{inst_external_include} } = $Config::Config{flavour_install_include};
perl	comment	#        $target->{ $sources{inst_external_src} }     = $Config::Config{flavour_install_src};
perl	comment	#    }
perl	blank	
perl	comment	    # insert user overrides
perl	code	    foreach my $key (keys %$user) {
perl	code	        my $value = $user->{$key};
perl	code	        if (not defined $value and $key ne 'packlist_read' and $key ne 'packlist_write') {
perl	comment	          # undef means "remove"
perl	code	          delete $target->{ $sources{$key} };
perl	code	        }
perl	code	        elsif (exists $sources{$key}) {
perl	comment	          # overwrite stuff, don't let the user create new entries
perl	code	          $target->{ $sources{$key} } = $value;
perl	code	        }
perl	code	    }
perl	blank	
perl	code	    return $target;
perl	code	}
perl	blank	
perl	code	sub _directory_not_empty {
perl	code	    require File::Find;
perl	code	    my($dir) = @_;
perl	code	    my $files = 0;
perl	code	    File::Find::find(sub {
perl	code		    return if $_ eq ".exists";
perl	code	        if (-f) {
perl	code	            $File::Find::prune++;
perl	code	            $files = 1;
perl	code	            }
perl	code	    }, $dir);
perl	code	    return $files;
perl	code	}
perl	blank	
perl	comment	=head2 sign_par
perl	blank	
perl	comment	Digitally sign a PAR distribution using C<gpg> or B<Crypt::OpenPGP>,
perl	comment	via B<Module::Signature>.
perl	blank	
perl	comment	=cut
perl	blank	
perl	code	sub sign_par {
perl	code	    my %args = &_args;
perl	code	    _verify_or_sign(%args, action => 'sign');
perl	code	}
perl	blank	
perl	comment	=head2 verify_par
perl	blank	
perl	comment	Verify the digital signature of a PAR distribution using C<gpg> or
perl	comment	B<Crypt::OpenPGP>, via B<Module::Signature>.
perl	blank	
perl	comment	Returns a boolean value indicating whether verification passed; C<$!>
perl	comment	is set to the return code of C<Module::Signature::verify>.
perl	blank	
perl	comment	=cut
perl	blank	
perl	code	sub verify_par {
perl	code	    my %args = &_args;
perl	code	    $! = _verify_or_sign(%args, action => 'verify');
perl	code	    return ( $! == Module::Signature::SIGNATURE_OK() );
perl	code	}
perl	blank	
perl	comment	=head2 merge_par
perl	blank	
perl	comment	Merge two or more PAR distributions into one. First argument must
perl	comment	be the name of the distribution you want to merge all others into.
perl	comment	Any following arguments will be interpreted as the file names of
perl	comment	further PAR distributions to merge into the first one.
perl	blank	
perl	comment	  merge_par('foo.par', 'bar.par', 'baz.par')
perl	blank	
perl	comment	This will merge the distributions C<foo.par>, C<bar.par> and C<baz.par>
perl	comment	into the distribution C<foo.par>. C<foo.par> will be overwritten!
perl	comment	The original META.yml of C<foo.par> is retained.
perl	blank	
perl	comment	=cut
perl	blank	
perl	code	sub merge_par {
perl	code	    my $base_par = shift;
perl	code	    my @additional_pars = @_;
perl	code	    require Cwd;
perl	code	    require File::Copy;
perl	code	    require File::Path;
perl	code	    require File::Find;
perl	blank	
perl	comment	    # parameter checking
perl	code	    if (not defined $base_par) {
perl	code	        croak "First argument to merge_par() must be the .par archive to modify.";
perl	code	    }
perl	blank	
perl	code	    if (not -f $base_par or not -r _ or not -w _) {
perl	code	        croak "'$base_par' is not a file or you do not have enough permissions to read and modify it.";
perl	code	    }
perl	blank	
perl	code	    foreach (@additional_pars) {
perl	code	        if (not -f $_ or not -r _) {
perl	code	            croak "'$_' is not a file or you do not have enough permissions to read it.";
perl	code	        }
perl	code	    }
perl	blank	
perl	comment	    # The unzipping will change directories. Remember old dir.
perl	code	    my $old_cwd = Cwd::cwd();
perl	blank	
perl	comment	    # Unzip the base par to a temp. dir.
perl	code	    (undef, my $base_dir) = _unzip_to_tmpdir(
perl	code	        dist => $base_par, subdir => 'blib'
perl	code	    );
perl	code	    my $blibdir = File::Spec->catdir($base_dir, 'blib');
perl	blank	
perl	comment	    # move the META.yml to the (main) temp. dir.
perl	code	    File::Copy::move(
perl	code	        File::Spec->catfile($blibdir, 'META.yml'),
perl	code	        File::Spec->catfile($base_dir, 'META.yml')
perl	code	    );
perl	comment	    # delete (incorrect) MANIFEST
perl	code	    unlink File::Spec->catfile($blibdir, 'MANIFEST');
perl	blank	
perl	comment	    # extract additional pars and merge    
perl	code	    foreach my $par (@additional_pars) {
perl	comment	        # restore original directory because the par path
perl	comment	        # might have been relative!
perl	code	        chdir($old_cwd);
perl	code	        (undef, my $add_dir) = _unzip_to_tmpdir(
perl	code	            dist => $par
perl	code	        );
perl	code	        my @files;
perl	code	        my @dirs;
perl	comment	        # I hate File::Find
perl	comment	        # And I hate writing portable code, too.
perl	code	        File::Find::find(
perl	code	            {wanted =>sub {
perl	code	                my $file = $File::Find::name;
perl	code	                push @files, $file if -f $file;
perl	code	                push @dirs, $file if -d _;
perl	code	            }},
perl	code	            $add_dir
perl	code	        );
perl	code	        my ($vol, $subdir, undef) = File::Spec->splitpath( $add_dir, 1);
perl	code	        my @dir = File::Spec->splitdir( $subdir );
perl	blank	
perl	comment	        # merge directory structure
perl	code	        foreach my $dir (@dirs) {
perl	code	            my ($v, $d, undef) = File::Spec->splitpath( $dir, 1 );
perl	code	            my @d = File::Spec->splitdir( $d );
perl	code	            shift @d foreach @dir; # remove tmp dir from path
perl	code	            my $target = File::Spec->catdir( $blibdir, @d );
perl	code	            mkdir($target);
perl	code	        }
perl	blank	
perl	comment	        # merge files
perl	code	        foreach my $file (@files) {
perl	code	            my ($v, $d, $f) = File::Spec->splitpath( $file );
perl	code	            my @d = File::Spec->splitdir( $d );
perl	code	            shift @d foreach @dir; # remove tmp dir from path
perl	code	            my $target = File::Spec->catfile(
perl	code	                File::Spec->catdir( $blibdir, @d ),
perl	code	                $f
perl	code	            );
perl	code	            File::Copy::copy($file, $target)
perl	code	              or die "Could not copy '$file' to '$target': $!";
perl	blank	
perl	code	        }
perl	code	        chdir($old_cwd);
perl	code	        File::Path::rmtree([$add_dir]);
perl	code	    }
perl	blank	
perl	comment	    # delete (copied) MANIFEST and META.yml
perl	code	    unlink File::Spec->catfile($blibdir, 'MANIFEST');
perl	code	    unlink File::Spec->catfile($blibdir, 'META.yml');
perl	blank	
perl	code	    chdir($base_dir);
perl	code	    my $resulting_par_file = Cwd::abs_path(blib_to_par());
perl	code	    chdir($old_cwd);
perl	code	    File::Copy::move($resulting_par_file, $base_par);
perl	blank	
perl	code	    File::Path::rmtree([$base_dir]);
perl	code	}
perl	blank	
perl	blank	
perl	comment	=head2 remove_man
perl	blank	
perl	comment	Remove the man pages from a PAR distribution. Takes one named
perl	comment	parameter: I<dist> which should be the name (and path) of the
perl	comment	PAR distribution file. The calling conventions outlined in
perl	comment	the C<FUNCTIONS> section above apply.
perl	blank	
perl	comment	The PAR archive will be
perl	comment	extracted, stripped of all C<man\d?> and C<html> subdirectories
perl	comment	and then repackaged into the original file.
perl	blank	
perl	comment	=cut
perl	blank	
perl	code	sub remove_man {
perl	code	    my %args = &_args;
perl	code	    my $par = $args{dist};
perl	code	    require Cwd;
perl	code	    require File::Copy;
perl	code	    require File::Path;
perl	code	    require File::Find;
perl	blank	
perl	comment	    # parameter checking
perl	code	    if (not defined $par) {
perl	code	        croak "First argument to remove_man() must be the .par archive to modify.";
perl	code	    }
perl	blank	
perl	code	    if (not -f $par or not -r _ or not -w _) {
perl	code	        croak "'$par' is not a file or you do not have enough permissions to read and modify it.";
perl	code	    }
perl	blank	
perl	comment	    # The unzipping will change directories. Remember old dir.
perl	code	    my $old_cwd = Cwd::cwd();
perl	blank	
perl	comment	    # Unzip the base par to a temp. dir.
perl	code	    (undef, my $base_dir) = _unzip_to_tmpdir(
perl	code	        dist => $par, subdir => 'blib'
perl	code	    );
perl	code	    my $blibdir = File::Spec->catdir($base_dir, 'blib');
perl	blank	
perl	comment	    # move the META.yml to the (main) temp. dir.
perl	code	    File::Copy::move(
perl	code	        File::Spec->catfile($blibdir, 'META.yml'),
perl	code	        File::Spec->catfile($base_dir, 'META.yml')
perl	code	    );
perl	comment	    # delete (incorrect) MANIFEST
perl	code	    unlink File::Spec->catfile($blibdir, 'MANIFEST');
perl	blank	
perl	code	    opendir DIRECTORY, 'blib' or die $!;
perl	code	    my @dirs = grep { /^blib\/(?:man\d*|html)$/ }
perl	code	               grep { -d $_ }
perl	code	               map  { File::Spec->catfile('blib', $_) }
perl	code	               readdir DIRECTORY;
perl	code	    close DIRECTORY;
perl	blank	
perl	code	    File::Path::rmtree(\@dirs);
perl	blank	
perl	code	    chdir($base_dir);
perl	code	    my $resulting_par_file = Cwd::abs_path(blib_to_par());
perl	code	    chdir($old_cwd);
perl	code	    File::Copy::move($resulting_par_file, $par);
perl	blank	
perl	code	    File::Path::rmtree([$base_dir]);
perl	code	}
perl	blank	
perl	blank	
perl	comment	=head2 get_meta
perl	blank	
perl	comment	Opens a PAR archive and extracts the contained META.yml file.
perl	comment	Returns the META.yml file as a string.
perl	blank	
perl	comment	Takes one named parameter: I<dist>. If only one parameter is
perl	comment	passed, it is treated as the I<dist> parameter. (Have a look
perl	comment	at the description in the C<FUNCTIONS> section above.)
perl	blank	
perl	comment	Returns undef if no PAR archive or no META.yml within the
perl	comment	archive were found.
perl	blank	
perl	comment	=cut
perl	blank	
perl	code	sub get_meta {
perl	code	    my %args = &_args;
perl	code	    my $dist = $args{dist};
perl	code	    return undef if not defined $dist or not -r $dist;
perl	code	    require Cwd;
perl	code	    require File::Path;
perl	blank	
perl	comment	    # The unzipping will change directories. Remember old dir.
perl	code	    my $old_cwd = Cwd::cwd();
perl	blank	
perl	comment	    # Unzip the base par to a temp. dir.
perl	code	    (undef, my $base_dir) = _unzip_to_tmpdir(
perl	code	        dist => $dist, subdir => 'blib'
perl	code	    );
perl	code	    my $blibdir = File::Spec->catdir($base_dir, 'blib');
perl	blank	
perl	code	    my $meta = File::Spec->catfile($blibdir, 'META.yml');
perl	blank	
perl	code	    if (not -r $meta) {
perl	code	        return undef;
perl	code	    }
perl	blank	
perl	code	    open FH, '<', $meta
perl	code	      or die "Could not open file '$meta' for reading: $!";
perl	blank	
perl	code	    local $/ = undef;
perl	code	    my $meta_text = <FH>;
perl	code	    close FH;
perl	blank	
perl	code	    chdir($old_cwd);
perl	blank	
perl	code	    File::Path::rmtree([$base_dir]);
perl	blank	
perl	code	    return $meta_text;
perl	code	}
perl	blank	
perl	blank	
perl	blank	
perl	code	sub _unzip {
perl	code	    my %args = &_args;
perl	code	    my $dist = $args{dist};
perl	code	    my $path = $args{path} || File::Spec->curdir;
perl	code	    return unless -f $dist;
perl	blank	
perl	comment	    # Try fast unzipping first
perl	code	    if (eval { require Archive::Unzip::Burst; 1 }) {
perl	code	        my $return = Archive::Unzip::Burst::unzip($dist, $path);
perl	code	        return if $return; # true return value == error (a la system call)
perl	code	    }
perl	comment	    # Then slow unzipping
perl	code	    if (eval { require Archive::Zip; 1 }) {
perl	code	        my $zip = Archive::Zip->new;
perl	code	        local %SIG;
perl	code	        $SIG{__WARN__} = sub { print STDERR $_[0] unless $_[0] =~ /\bstat\b/ };
perl	code	        return unless $zip->read($dist) == Archive::Zip::AZ_OK()
perl	code	                  and $zip->extractTree('', "$path/") == Archive::Zip::AZ_OK();
perl	code	    }
perl	comment	    # Then fall back to the system
perl	code	    else {
perl	code	        return if system(unzip => $dist, '-d', $path);
perl	code	    }
perl	blank	
perl	code	    return 1;
perl	code	}
perl	blank	
perl	code	sub _zip {
perl	code	    my %args = &_args;
perl	code	    my $dist = $args{dist};
perl	blank	
perl	code	    if (eval { require Archive::Zip; 1 }) {
perl	code	        my $zip = Archive::Zip->new;
perl	code	        $zip->addTree( File::Spec->curdir, '' );
perl	code	        $zip->writeToFileNamed( $dist ) == Archive::Zip::AZ_OK() or die $!;
perl	code	    }
perl	code	    else {
perl	code	        system(qw(zip -r), $dist, File::Spec->curdir) and die $!;
perl	code	    }
perl	code	}
perl	blank	
perl	blank	
perl	comment	# This sub munges the arguments to most of the PAR::Dist functions
perl	comment	# into a hash. On the way, it downloads PAR archives as necessary, etc.
perl	code	sub _args {
perl	comment	    # default to the first .par in the CWD
perl	code	    if (not @_) {
perl	code	        @_ = (glob('*.par'))[0];
perl	code	    }
perl	blank	
perl	comment	    # single argument => it's a distribution file name or URL
perl	code	    @_ = (dist => @_) if @_ == 1;
perl	blank	
perl	code	    my %args = @_;
perl	code	    $args{name} ||= $args{dist};
perl	blank	
perl	comment	    # If we are installing from an URL, we want to munge the
perl	comment	    # distribution name so that it is in form "Module-Name"
perl	code	    if (defined $args{name}) {
perl	code	        $args{name} =~ s/^\w+:\/\///;
perl	code	        my @elems = parse_dist_name($args{name});
perl	comment	        # @elems is name, version, arch, perlversion
perl	code	        if (defined $elems[0]) {
perl	code	            $args{name} = $elems[0];
perl	code	        }
perl	code	        else {
perl	code	            $args{name} =~ s/^.*\/([^\/]+)$/$1/;
perl	code	            $args{name} =~ s/^([0-9A-Za-z_-]+)-\d+\..+$/$1/;
perl	code	        }
perl	code	    }
perl	blank	
perl	comment	    # append suffix if there is none
perl	code	    if ($args{dist} and not $args{dist} =~ /\.[a-zA-Z_][^.]*$/) {
perl	code	        require Config;
perl	code	        my $suffix = $args{suffix};
perl	code	        $suffix ||= "$Config::Config{archname}-$Config::Config{version}.par";
perl	code	        $args{dist} .= "-$suffix";
perl	code	    }
perl	blank	
perl	comment	    # download if it's an URL
perl	code	    if ($args{dist} and $args{dist} =~ m!^\w+://!) {
perl	code	        $args{dist} = _fetch(dist => $args{dist})
perl	code	    }
perl	blank	
perl	code	    return %args;
perl	code	}
perl	blank	
perl	blank	
perl	comment	# Download PAR archive, but only if necessary (mirror!)
perl	code	my %escapes;
perl	code	sub _fetch {
perl	code	    my %args = @_;
perl	blank	
perl	code	    if ($args{dist} =~ s/^file:\/\///) {
perl	code	      return $args{dist} if -e $args{dist};
perl	code	      return;
perl	code	    }
perl	code	    require LWP::Simple;
perl	blank	
perl	code	    $ENV{PAR_TEMP} ||= File::Spec->catdir(File::Spec->tmpdir, 'par');
perl	code	    mkdir $ENV{PAR_TEMP}, 0777;
perl	code	    %escapes = map { chr($_) => sprintf("%%%02X", $_) } 0..255 unless %escapes;
perl	blank	
perl	code	    $args{dist} =~ s{^cpan://((([a-zA-Z])[a-zA-Z])[-_a-zA-Z]+)/}
perl	code			    {http://www.cpan.org/modules/by-authors/id/\U$3/$2/$1\E/};
perl	blank	
perl	code	    my $file = $args{dist};
perl	code	    $file =~ s/([^\w\.])/$escapes{$1}/g;
perl	code	    $file = File::Spec->catfile( $ENV{PAR_TEMP}, $file);
perl	code	    my $rc = LWP::Simple::mirror( $args{dist}, $file );
perl	blank	
perl	code	    if (!LWP::Simple::is_success($rc) and $rc != 304) {
perl	code	        die "Error $rc: ", LWP::Simple::status_message($rc), " ($args{dist})\n";
perl	code	    }
perl	blank	
perl	code	    return $file if -e $file;
perl	code	    return;
perl	code	}
perl	blank	
perl	code	sub _verify_or_sign {
perl	code	    my %args = &_args;
perl	blank	
perl	code	    require File::Path;
perl	code	    require Module::Signature;
perl	code	    die "Module::Signature version 0.25 required"
perl	code	      unless Module::Signature->VERSION >= 0.25;
perl	blank	
perl	code	    require Cwd;
perl	code	    my $cwd = Cwd::cwd();
perl	code	    my $action = $args{action};
perl	code	    my ($dist, $tmpdir) = _unzip_to_tmpdir($args{dist});
perl	code	    $action ||= (-e 'SIGNATURE' ? 'verify' : 'sign');
perl	blank	
perl	code	    if ($action eq 'sign') {
perl	code	        open FH, '>SIGNATURE' unless -e 'SIGNATURE';
perl	code	        open FH, 'MANIFEST' or die $!;
perl	blank	
perl	code	        local $/;
perl	code	        my $out = <FH>;
perl	code	        if ($out !~ /^SIGNATURE(?:\s|$)/m) {
perl	code	            $out =~ s/^(?!\s)/SIGNATURE\n/m;
perl	code	            open FH, '>MANIFEST' or die $!;
perl	code	            print FH $out;
perl	code	        }
perl	code	        close FH;
perl	blank	
perl	code	        $args{overwrite} = 1 unless exists $args{overwrite};
perl	code	        $args{skip}      = 0 unless exists $args{skip};
perl	code	    }
perl	blank	
perl	code	    my $rv = Module::Signature->can($action)->(%args);
perl	code	    _zip(dist => $dist) if $action eq 'sign';
perl	code	    File::Path::rmtree([$tmpdir]);
perl	blank	
perl	code	    chdir($cwd);
perl	code	    return $rv;
perl	code	}
perl	blank	
perl	code	sub _unzip_to_tmpdir {
perl	code	    my %args = &_args;
perl	blank	
perl	code	    require File::Temp;
perl	blank	
perl	code	    my $dist   = File::Spec->rel2abs($args{dist});
perl	code	    my $tmpdirname = File::Spec->catdir(File::Spec->tmpdir, "parXXXXX");
perl	code	    my $tmpdir = File::Temp::mkdtemp($tmpdirname)        
perl	code	      or die "Could not create temporary directory from template '$tmpdirname': $!";
perl	code	    my $path = $tmpdir;
perl	code	    $path = File::Spec->catdir($tmpdir, $args{subdir}) if defined $args{subdir};
perl	code	    _unzip(dist => $dist, path => $path);
perl	blank	
perl	code	    chdir $tmpdir;
perl	code	    return ($dist, $tmpdir);
perl	code	}
perl	blank	
perl	blank	
perl	blank	
perl	comment	=head2 parse_dist_name
perl	blank	
perl	comment	First argument must be a distribution file name. The file name
perl	comment	is parsed into I<distribution name>, I<distribution version>,
perl	comment	I<architecture name>, and I<perl version>.
perl	blank	
perl	comment	Returns the results as a list in the above order.
perl	comment	If any or all of the above cannot be determined, returns undef instead
perl	comment	of the undetermined elements.
perl	blank	
perl	comment	Supported formats are:
perl	blank	
perl	comment	Math-Symbolic-0.502-x86_64-linux-gnu-thread-multi-5.8.7
perl	blank	
perl	comment	Math-Symbolic-0.502
perl	blank	
perl	comment	The ".tar.gz" or ".par" extensions as well as any
perl	comment	preceding paths are stripped before parsing. Starting with C<PAR::Dist>
perl	comment	0.22, versions containing a preceding C<v> are parsed correctly.
perl	blank	
perl	comment	This function is not exported by default.
perl	blank	
perl	comment	=cut
perl	blank	
perl	code	sub parse_dist_name {
perl	code		my $file = shift;
perl	code		return(undef, undef, undef, undef) if not defined $file;
perl	blank	
perl	code		(undef, undef, $file) = File::Spec->splitpath($file);
perl	blank	
perl	code		my $version = qr/v?(?:\d+(?:_\d+)?|\d*(?:\.\d+(?:_\d+)?)+)/;
perl	code		$file =~ s/\.(?:par|tar\.gz|tar)$//i;
perl	code		my @elem = split /-/, $file;
perl	code		my (@dn, $dv, @arch, $pv);
perl	code		while (@elem) {
perl	code			my $e = shift @elem;
perl	code			if (
perl	code	            $e =~ /^$version$/o
perl	code	            and not(# if not next token also a version
perl	comment	                    # (assumes an arch string doesnt start with a version...)
perl	code	                @elem and $elem[0] =~ /^$version$/o
perl	code	            )
perl	code	        ) {
perl	blank	
perl	code				$dv = $e;
perl	code				last;
perl	code			}
perl	code			push @dn, $e;
perl	code		}
perl	blank	
perl	code		my $dn;
perl	code		$dn = join('-', @dn) if @dn;
perl	blank	
perl	code		if (not @elem) {
perl	code			return( $dn, $dv, undef, undef);
perl	code		}
perl	blank	
perl	code		while (@elem) {
perl	code			my $e = shift @elem;
perl	code			if ($e =~ /^$version|any_version$/) {
perl	code				$pv = $e;
perl	code				last;
perl	code			}
perl	code			push @arch, $e;
perl	code		}
perl	blank	
perl	code		my $arch;
perl	code		$arch = join('-', @arch) if @arch;
perl	blank	
perl	code		return($dn, $dv, $arch, $pv);
perl	code	}
perl	blank	
perl	comment	=head2 generate_blib_stub
perl	blank	
perl	comment	Creates a F<blib/lib> subdirectory in the current directory
perl	comment	and prepares a F<META.yml> with meta information for a
perl	comment	new PAR distribution. First argument should be the name of the
perl	comment	PAR distribution in a format understood by C<parse_dist_name()>.
perl	comment	Alternatively, named arguments resembling those of
perl	comment	C<blib_to_par> are accepted.
perl	blank	
perl	comment	After running C<generate_blib_stub> and injecting files into
perl	comment	the F<blib> directory, you can create a PAR distribution
perl	comment	using C<blib_to_par>.
perl	comment	This function is useful for creating custom PAR distributions
perl	comment	from scratch. (I.e. not from an unpacked CPAN distribution)
perl	comment	Example:
perl	blank	
perl	comment	  use PAR::Dist;
perl	comment	  use File::Copy 'copy';
perl	blank	  
perl	comment	  generate_blib_stub(
perl	comment	    name => 'MyApp', version => '1.00'
perl	comment	  );
perl	comment	  copy('MyApp.pm', 'blib/lib/MyApp.pm');
perl	comment	  blib_to_par(); # generates the .par file!
perl	blank	
perl	comment	C<generate_blib_stub> will not overwrite existing files.
perl	blank	
perl	comment	=cut
perl	blank	
perl	code	sub generate_blib_stub {
perl	code	    my %args = &_args;
perl	code	    my $dist = $args{dist};
perl	code	    require Config;
perl	blank	
perl	code	    my $name	= $args{name};
perl	code	    my $version	= $args{version};
perl	code	    my $suffix	= $args{suffix};
perl	blank	
perl	code	    my ($parse_name, $parse_version, $archname, $perlversion)
perl	code	      = parse_dist_name($dist);
perl	blank	
perl	code	    $name ||= $parse_name;
perl	code	    $version ||= $parse_version;
perl	code	    $suffix = "$archname-$perlversion"
perl	code	      if (not defined $suffix or $suffix eq '')
perl	code	         and $archname and $perlversion;
perl	blank	
perl	code	    $suffix ||= "$Config::Config{archname}-$Config::Config{version}";
perl	code	    if ( grep { not defined $_ } ($name, $version, $suffix) ) {
perl	code	        warn "Could not determine distribution meta information from distribution name '$dist'";
perl	code	        return();
perl	code	    }
perl	code	    $suffix =~ s/\.par$//;
perl	blank	
perl	code	    if (not -f 'META.yml') {
perl	code	        open META, '>', 'META.yml'
perl	code	          or die "Could not open META.yml file for writing: $!";
perl	code	        print META << "YAML" if fileno(META);
perl	code	name: $name
perl	code	version: $version
perl	code	build_requires: {}
perl	code	conflicts: {}
perl	code	dist_name: $name-$version-$suffix.par
perl	code	distribution_type: par
perl	code	dynamic_config: 0
perl	code	generated_by: 'PAR::Dist version $PAR::Dist::VERSION'
perl	code	license: unknown
perl	code	YAML
perl	code	        close META;
perl	code	    }
perl	blank	
perl	code	    mkdir('blib');
perl	code	    mkdir(File::Spec->catdir('blib', 'lib'));
perl	code	    mkdir(File::Spec->catdir('blib', 'script'));
perl	blank	
perl	code	    return 1;
perl	code	}
perl	blank	
perl	blank	
perl	comment	=head2 contains_binaries
perl	blank	
perl	comment	This function is not exported by default.
perl	blank	
perl	comment	Opens a PAR archive tries to determine whether that archive
perl	comment	contains platform-specific binary code.
perl	blank	
perl	comment	Takes one named parameter: I<dist>. If only one parameter is
perl	comment	passed, it is treated as the I<dist> parameter. (Have a look
perl	comment	at the description in the C<FUNCTIONS> section above.)
perl	blank	
perl	comment	Throws a fatal error if the PAR archive could not be found.
perl	blank	
perl	comment	Returns one if the PAR was found to contain binary code
perl	comment	and zero otherwise.
perl	blank	
perl	comment	=cut
perl	blank	
perl	code	sub contains_binaries {
perl	code	    require File::Find;
perl	code	    my %args = &_args;
perl	code	    my $dist = $args{dist};
perl	code	    return undef if not defined $dist or not -r $dist;
perl	code	    require Cwd;
perl	code	    require File::Path;
perl	blank	
perl	comment	    # The unzipping will change directories. Remember old dir.
perl	code	    my $old_cwd = Cwd::cwd();
perl	blank	
perl	comment	    # Unzip the base par to a temp. dir.
perl	code	    (undef, my $base_dir) = _unzip_to_tmpdir(
perl	code	        dist => $dist, subdir => 'blib'
perl	code	    );
perl	code	    my $blibdir = File::Spec->catdir($base_dir, 'blib');
perl	code	    my $archdir = File::Spec->catdir($blibdir, 'arch');
perl	blank	
perl	code	    my $found = 0;
perl	blank	
perl	code	    File::Find::find(
perl	code	      sub {
perl	code	        $found++ if -f $_ and not /^\.exists$/;
perl	code	      },
perl	code	      $archdir
perl	code	    );
perl	blank	
perl	code	    chdir($old_cwd);
perl	blank	
perl	code	    File::Path::rmtree([$base_dir]);
perl	blank	
perl	code	    return $found ? 1 : 0;
perl	code	}
perl	blank	
perl	code	1;
perl	blank	
perl	comment	=head1 SEE ALSO
perl	blank	
perl	comment	L<PAR>, L<ExtUtils::Install>, L<Module::Signature>, L<LWP::Simple>
perl	blank	
perl	comment	=head1 AUTHORS
perl	blank	
perl	comment	Audrey Tang E<lt>cpan@audreyt.orgE<gt> 2003-2007
perl	blank	
perl	comment	Steffen Mueller E<lt>smueller@cpan.orgE<gt> 2005-2007
perl	blank	
perl	comment	PAR has a mailing list, E<lt>par@perl.orgE<gt>, that you can write to;
perl	comment	send an empty mail to E<lt>par-subscribe@perl.orgE<gt> to join the list
perl	comment	and participate in the discussion.
perl	blank	
perl	comment	Please send bug reports to E<lt>bug-par@rt.cpan.orgE<gt>.
perl	blank	
perl	comment	=head1 COPYRIGHT
perl	blank	
perl	comment	Copyright 2003-2007 by Audrey Tang E<lt>autrijus@autrijus.orgE<gt>.
perl	blank	
perl	comment	This program is free software; you can redistribute it and/or modify it
perl	comment	under the same terms as Perl itself.
perl	blank	
perl	comment	See L<http://www.perl.com/perl/misc/Artistic.html>
perl	blank	
perl	comment	=cut
