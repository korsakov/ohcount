nix	code	{pkgs,config}:
nix	blank	
nix	comment	# one line comment
nix	code	{
nix	comment	/* mulpiple line comment
nix	comment	   foo = 21;
nix	comment	*/
nix	code	  bar = "
shell	comment	    #!/bin/sh
shell	blank	
shell	code	    ls -la
shell	comment	    # comment
shell	code	    echo hello #comment
nix	code	  ";
nix	blank	
nix	code	  baz = ''
shell	comment	    #!/bin/sh
shell	blank	
shell	code	    ls -la
shell	comment	    # comment
shell	code	    echo hello #comment
nix	code	  '';
nix	code	  nixHttp = [ http://nixos.org/ ];
nix	code	}
