#=== mingw_setup.py by Phillip J. Eby
"""Create pythonNN.def and libpythonNN.a in 'PythonNN/libs' directory

This script makes it possible to use the MinGW compiler tools to
build C extensions that work with the standard Windows Python
distribution.

Before running, you should have installed the MinGW compiler toolset,
and placed its 'bin' directory on your PATH.  An easy way to do this
is to install Cygwin's "binutils", "gcc", and "mingw-*" packages,
then run this script from the Cygwin shell.  (Be sure to use *Windows*
Python, not Cygwin python!)

Once this script has been run, you should be able to build extensions
using distutils in the standard way, as long as you select the
'mingw32' compiler, and the required tools are on your PATH.  See
the "Installing Python Modules" manual for more information on
selecting a compiler.
"""


from distutils.spawn import find_executable
from distutils.sysconfig import get_config_var
from distutils import __file__ as distutils_file
import os, re, sys

if sys.platform=='cygwin':
     print "Please run this script using Windows python,",
     print "not Cygwin python.  E.g, try:"
     print
     print "/cygdrive/c/PythonNN/python", " ".join(sys.argv)
     print
     print "(where NN is the major/minor python version number)"
     sys.exit()

basename = 'python%d%d' % sys.version_info[:2]

libs_dir = os.path.join(get_config_var('prefix'),'libs')
lib_file = os.path.join(libs_dir,basename+'.lib')
def_file = os.path.join(libs_dir,basename+'.def')
ming_lib = os.path.join(libs_dir,'lib%s.a' % basename)

distutils_cfg = os.path.join(os.path.dirname(distutils_file),'distutils.cfg')

export_match = re.compile(r"^_imp__(.*) in python\d+\.dll").match

nm      = find_executable('nm')
dlltool = find_executable('dlltool')

if not nm or not dlltool:
     print "'nm' and/or 'dlltool' were not found;"
     print "Please make sure they're on your PATH."
     sys.exit()

nm_command = '%s -Cs %s' % (nm, lib_file)

print "Building", def_file, "using", nm_command
f = open(def_file,'w')
print >>f, "LIBRARY %s.dll" % basename
print >>f, "EXPORTS"


nm_pipe = os.popen(nm_command)
for line in nm_pipe.readlines():
     m = export_match(line)
     if m:
         print >>f, m.group(1)
f.close()

exit = nm_pipe.close()
if exit:
     print "nm exited with status", exit
     print "Please check that", lib_file, "exists and is valid."
     sys.exit()


print "Building",ming_lib,"using",dlltool
dlltool_pipe = os.popen(
     "%s --dllname %s.dll --def %s --output-lib %s" %
     (dlltool, basename, def_file, ming_lib)
)

dlltool_pipe.readlines()
exit = dlltool_pipe.close()
if exit:
     print "dlltool exited with status", exit
     print "Unable to proceed."
     sys.exit()

print
print "Installation complete.  You may wish to add the following"
print "lines to", distutils_cfg, ':'
print
print "[build]"
print "compiler = mingw32"
print
print "This will make the distutils use MinGW as the default"
print "compiler, so that you don't need to configure this for"
print "every 'setup.py' you run."

