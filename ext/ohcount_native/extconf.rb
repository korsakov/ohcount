# A ruby script to generate the C Makefile.
require 'mkmf'

dir_config('ohcount_native')

# FLAGS: enable logging (or not)
if $*.include?("debug")
	puts "BUILD_TYPE: DEBUG"
else
	puts "BUILD_TYPE: RELEASE"
	$CFLAGS << " -Wall -DNDEBUG"
end

create_makefile('ohcount_native')
