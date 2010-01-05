#!/usr/bin/env python

import distutils.ccompiler
from distutils.core import setup, Extension
from distutils.command.build import build
from distutils.command.build_ext import build_ext
from distutils.command.install_lib import install_lib
import os, sys
from glob import glob

if not hasattr(sys, 'version_info') or sys.version_info < (2,6,0,'final'):
    raise SystemExit("Ohcount requires Python 2.6 or later.")

class build_ohcount(build):
    """Ohcount already have a script named 'build', from the original package,
    so it conflicts with Python default build path. To solve this, setup.py
    will use the directory 'build-python' instead. The original distutils
    execute 'build_py' before 'build_ext', but we need the wrapper ohcount.py
    created by SWIG to be installed too, so we need to invert this order.
    """

    sub_commands = [('build_ext',     build.has_ext_modules),  # changed
                    ('build_py',      build.has_pure_modules), # changed
                    ('build_clib',    build.has_c_libraries),
                    ('build_scripts', build.has_scripts),
                   ]

    def initialize_options(self):
        build.initialize_options(self)
        self.build_base = 'build-python'

def newer_than(srclist, dstlist):
    for left, right in zip(srclist, dstlist):
        if not os.path.exists(right):
            return True
        left_stat = os.lstat(left)
        right_stat = os.lstat(right)
        if left_stat.st_mtime > right_stat.st_mtime:
            return True
    return False

class build_ohcount_ext(build_ext):
    """This class implements extra steps needed by Ohcount build process."""

    def run(self):
        parsers = glob('src/parsers/*.rl')
        parsers_h = [f.replace('.rl', '.h') for f in parsers]
        if newer_than(parsers, parsers_h):
            os.system('cd src/parsers/ && bash ./compile')
        hash_files = glob('src/hash/*.gperf')
        hash_srcs = []
        for f in hash_files:
            if not f.endswith('languages.gperf'):
                hash_srcs.append(f.replace('s.gperf', '_hash.h'))
            else:
                hash_srcs.append(f.replace('s.gperf', '_hash.c'))
        if newer_than(hash_files, hash_srcs):
            os.system('cd src/hash/ && bash ./generate_headers')
        return build_ext.run(self)

# Overwrite default Mingw32 compiler
(module_name, class_name, long_description) = \
        distutils.ccompiler.compiler_class['mingw32']
module_name = "distutils." + module_name
__import__(module_name)
module = sys.modules[module_name]
Mingw32CCompiler = vars(module)[class_name]

class Mingw32CCompiler_ohcount(Mingw32CCompiler):
    """Ohcount CCompiler version for Mingw32. There is a problem linking
    against msvcrXX for Python 2.6.4: as both DLLs msvcr and msvcr90 are
    loaded, it seems to happen some unexpected segmentation faults in
    several function calls."""

    def __init__(self, *args, **kwargs):
        Mingw32CCompiler.__init__(self, *args, **kwargs)
        self.dll_libraries=[] # empty link libraries list

_new_compiler = distutils.ccompiler.new_compiler

def ohcount_new_compiler(plat=None,compiler=None,verbose=0,dry_run=0,force=0):
    if compiler == 'mingw32':
        inst = Mingw32CCompiler_ohcount(None, dry_run, force)
    else:
        inst = _new_compiler(plat,compiler,verbose,dry_run,force)
    return inst

distutils.ccompiler.new_compiler = ohcount_new_compiler

# Ohcount python extension
ext_modules=[
    Extension(
        name='ohcount._ohcount',
        sources= [
            'ruby/ohcount.i',
            'src/sourcefile.c',
            'src/detector.c',
            'src/licenses.c',
            'src/parser.c',
            'src/loc.c',
            'src/log.c',
            'src/diff.c',
            'src/parsed_language.c',
            'src/hash/language_hash.c',
        ],
        libraries=['pcre'],
        swig_opts=['-outdir', './python/'],
    )
]

setup(
    name='ohcount',
    version = '3.0.0',
    description = 'Ohcount is the source code line counter that powers Ohloh.',
    long_description =
        'Ohcount supports over 70 popular programming languages, and has been '
        'used to count over 6 billion lines of code by 300,000 developers! '
        'Ohcount does more more than just count lines of code. It can also '
        'detect popular open source licenses such as GPL within a large '
        'directory of source code. It can also detect code that targets a '
        'particular programming API, such as Win32 or KDE.',
    author = 'Mitchell Foral',
    author_email = 'mitchell@caladbolg.net',
    license = 'GNU GPL',
    platforms = ['Linux','Mac OSX'],
    keywords = ['ohcount','ohloh','loc','source','code','line','counter'],
    url = 'http://www.ohloh.net/p/ohcount',
    download_url = 'http://sourceforge.net/projects/ohcount/files/',
    packages = ['ohcount'],
    package_dir = {'ohcount': 'python'},
    classifiers = [
        'Development Status :: 5 - Production/Stable',
        'License :: OSI Approved :: GNU General Public License (GPL)'
        'Intended Audience :: Developers',
        'Natural Language :: English',
        'Programming Language :: C',
        'Programming Language :: Python',
        'Topic :: Software Development :: Libraries :: Python Modules',
    ],
    ext_modules=ext_modules,
    cmdclass={
        'build': build_ohcount,
        'build_ext': build_ohcount_ext,
    },
)

