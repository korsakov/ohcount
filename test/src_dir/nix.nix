{pkgs,config}:

# one line comment
{
/* mulpiple line comment
   foo = 21;
*/
  bar = "
    #!/bin/sh

    ls -la
    # comment
    echo hello #comment
  ";
	
  baz = ''
    #!/bin/sh

    ls -la
    # comment
    echo hello #comment
  '';
  nixHttp = [ http://nixos.org/ ];
}
