# The Detector determines which Monoglot or Polyglot should be
# used to parse a source file.
#
# The Detector primarily uses filename extensions to identify languages.
#
# The hash EXTENSION_MAP maps a filename extension to the name of a parser.
#
# If a filename extension is not enough to determine the correct parser (for
# instance, the *.m extension can indicate either a Matlab or Objective-C file),
# then the EXTENSION_MAP hash will contain a symbol identifying a Ruby method
# which will be invoked. This Ruby method can examine the file
# contents and return the name of the correct parser.
#
# Many source files do not have an extension. The method +disambiguate_nil+
# is called in these cases. The +file+ command line tool is used to determine
# the type of file and select a parser.
#
# The Detector is covered by DetectorTest.
#
class Ohcount::Detector

	module ContainsM
		# A performance hack -- once we've checked for the presence of *.m files, the result
		# is stored here to avoid checking twice.
		attr_accessor :contains_m
	end

	# The primary entry point for the detector.
	# Given a file context containing the file name, content, and an array of
	# other filenames in the source tree, attempts to detect which
	# language family (Monoglot or Polyglot) is in use for this file.
	#
	# Returns nil if the language is not recognized or if the file does not
	# contain any code.
	#
	# Example:
	#
	#   # List all C/C++ files in the 'src' directory
	#   Dir.entries("src").each do |file|
	#     context = Ohcount::SimpleFileContext.new(file)
	#     polyglot = Ohcount::Detector.detect(context)
	#     puts "#{file}" if polyglot == 'cncpp'
	#   end
	#
	def self.detect(file_context)
		# start with extension
		polyglot = EXTENSION_MAP[File.extname(file_context.filename).downcase]
    case polyglot
    when String
      # simplest case
		  return polyglot if polyglot.is_a?(String)
    when Symbol
		  # extension is ambiguous - requires custom disambiguation
			self.send(polyglot, file_context)
    when NilClass
      return disambiguate_nil(file_context)
    else
      raise RuntimeError.new("Unknown file detection type")
	  end
  end

	# Based solely on the filename, makes a judgment whether a file is a binary format.
	def self.binary_filename?(filename)
		ignore = [
			".svn",
			".jar",
			".tar",
			".gz",
			".tgz",
			".zip",
			".gif",
			".jpg",
			".jpeg",
			".bmp",
			".png",
			".tif",
			".tiff",
			".ogg",
			".aiff",
			".wav",
			".mp3",
			".au",
			".ra",
			".m4a",
			".pdf",
			".mpg",
			".mov",
			".qt",
			".avi"
			]
		ignore.include?(File.extname(filename))
	end

	# If an extension maps to a string, that string must be the name of a glot.
	# If an extension maps to a Ruby symbol, that symbol must be the name of a
	# Ruby method which will return the name of a glot.
	EXTENSION_MAP = {
		'.ada'  => "ada",
		'.adb'  => "ada",
		'.ads'  => "ada",
		'.asm'  => "assembler",
		'.awk'  => "awk",
		'.bas'  => "visualbasic",
		'.bat'  => "bat",
		'.boo'  => "boo",
		'.c'    => "cncpp",
		'.cc'   => "cncpp",
		'.cpp'  => "cncpp",
		'.css'  => "css",
		'.c++'  => "cncpp",
		'.cxx'  => "cncpp",
		'.el'   => "emacslisp",
		#		'.cbl'  => "cobol",
		#		'.cob'  => "cobol",
		'.cs'   => :disambiguate_cs,
		'.dylan'=> "dylan",
		'.erl'  => "erlang",
		'.f'    => :disambiguate_fortran,
		'.ftn'  => :disambiguate_fortran,
		'.f77'  => :disambiguate_fortran,
		'.f90'  => :disambiguate_fortran,
		'.f95'  => :disambiguate_fortran,
		'.f03'  => :disambiguate_fortran,
		'.F'    => :disambiguate_fortran,
		'.F77'  => :disambiguate_fortran,
		'.F90'  => :disambiguate_fortran,
		'.F95'  => :disambiguate_fortran,
		'.F03'  => :disambiguate_fortran,
		'.frx'  => "visualbasic",
		'.groovy'=> "groovy",
		'.h'    => :disambiguate_h_header,
		'.hpp'  => "cncpp",
		'.h++'  => "cncpp",
		'.hs'   => "haskell",
		'.hxx'  => "cncpp",
		'.hh'   => "cncpp",
		'.hrl'  => "erlang",
		'.htm'  => "html",
		'.html' => "html",
		'.in'   => :disambiguate_in,
		'.inc'  => :disambiguate_inc,
		'.java' => "java",
		'.js'   => "javascript",
		'.jsp'  => "jsp",
		'.lua'  => "lua",
		'.lsp'  => "lisp",
		'.lisp' => "lisp",
		'.m'    => :matlab_or_objective_c,
		'.mm'   => "objective_c",
		'.pas'  => "pascal",
		'.pp'   => "pascal",
		'.php'  => "php",
		'.php3' => "php",
		'.php4' => "php",
		'.php5' => "php",
		'.pl'   => "perl",
		'.pm'   => "perl",
		'.perl' => "perl",
		'.ph'   => "perl",
		'.pod'  => "perl",
		'.t'    => "perl",
		'.py'   => "python",
		'.rhtml'=> "rhtml",
		'.rb'   => "ruby",
		'.rex'  => "rexx",
		'.rexx' => "rexx",
		'.s'    => "assembler",
		'.S'    => "assembler",
		'.sc'   => "scheme",
		'.scm'  => "scheme",
		'.sh'   => "shell",
		'.sql'  => "sql",
		'.st'   => "smalltalk",
		'.tcl'  => "tcl",
		'.tpl'  => "html",
		'.vala' => "vala",
		'.vb'   => "visualbasic",
		'.vba'  => "visualbasic",
		'.vbs'  => "visualbasic",
		'.xml'  => "xml",
		'.xsd'  => "xmlschema",
		'.xsl'  => "xslt",
		'.d'		=> 'dmd',
		'.di'		=> 'dmd',
		'.tex'  => 'tex',
		'.ltx'  => 'tex',
		'.latex'=> 'tex'
	}

	protected

	# Returns a count of lines in the buffer matching the given regular expression.
	def self.lines_matching(buffer, re)
		buffer.inject(0) { |total, line| line =~ re ? total+1 : total }
	end

	# For *.m files, differentiates Matlab from Objective-C.
	#
	# This is done with a weighted heuristic that
	# scans the *.m file contents for keywords,
	# and also checks for the presence of matching *.h files.
  def self.matlab_or_objective_c(file_context)
    buffer = file_context.contents

    # if there are .h files in same directory, this probably isn't matlab
    h_headers = 0.0
    h_headers = -0.5 if file_context.filenames.select { |a| a =~ /\.h$/ }.any?

    # if the contents contain 'function (' on a single line - very likely to be matlab
    # if the contents contain lines starting with '%', its probably matlab comments
    matlab_signatures = /(^\s*function\s*)|(^\s*%)/
    matlab_sig_score = 0.1 * lines_matching(buffer, matlab_signatures)

    # if the contents contains '//' or '/*', likely objective_c
    objective_c_signatures = /(^\s*\/\/\s*)|(^\s*\/\*)|(^[+-])/
    obj_c_sig_score = -0.1 * lines_matching(buffer, objective_c_signatures)

    matlab = h_headers + matlab_sig_score + obj_c_sig_score

    matlab > 0 ? 'matlab' : 'objective_c'
  end

	# For *.h files, differentiates C/C++ from Objective-C.
	#
	# This is done with a weighted heuristic that
	# scans the *.h file contents for Objective-C keywords,
	# and also checks for the presence of matching *.m files.
	def self.disambiguate_h_header(file_context)
    buffer = file_context.contents

    objective_c = 0

    # could it be realistically be objective_c ? are there any .m files at all?
    # Speed hack - remember our findings in case we get the same filenames over and over
    unless defined?(file_context.filenames.contains_m)
      file_context.filenames.extend(ContainsM)
      file_context.filenames.contains_m = file_context.filenames.select { |a| a =~ /\.m$/ }.any?
    end
    return 'cncpp' unless file_context.filenames.contains_m

    # if the dir contains a matching *.m file, likely objective_c
    if file_context.filename =~ /\.h$/
      m_counterpart = file_context.filename.gsub(/\.h$/, ".m")
      return 'objective_c' if file_context.filenames.include?(m_counterpart)
    end

    # ok - it just might be objective_c, let's check contents for objective_c signatures
    objective_c_signatures = /(^\s*@interface)|(^\s*@end)/
    objective_c += lines_matching(buffer, objective_c_signatures)

    return objective_c > 1 ? 'objective_c' : 'cncpp'
	end

	# Tests whether the provided buffer contains binary or text content.
	# This is not fool-proof -- we basically just check for zero values
	# in the early bytes of the buffer. If we find a zero, we know it
	# is not (ascii) text.
  def self.binary_buffer?(buffer)
    100.times do |i|
      return true if buffer[i] == 0
    end
    false
  end

	# True if the provided buffer includes a '?php' directive
  def self.php_instruction?(buffer)
    buffer =~ /\?php/
  end

	# For *.in files, checks the prior extension.
	# Typically used for template files (eg Makefile.in, auto.c.in, etc).
  def self.disambiguate_in(file_context)
    # if the filename has an extension prior to the .in
    if file_context.filename =~ /\..*\.in$/
      filename = file_context.filename.gsub(/\.in$/, "")
      context = Ohcount::SimpleFileContext.new(filename, file_context.filenames, file_context.contents, file_context.file_location)
      return detect(context)
    end
    nil
  end

	# For *.inc files, checks for a PHP class.
  def self.disambiguate_inc(file_context)
    buffer = file_context.contents
    return nil if binary_buffer?(buffer)
    return 'php' if php_instruction?(buffer)
    nil
  end

	# For files with extention *.cs, differentiates C# from Clearsilver.
  def self.disambiguate_cs(file_context)
    buffer = file_context.contents
    return 'clearsilver_template' if lines_matching(file_context.contents, /\<\?cs/) > 0
    return 'csharp'
  end

  def self.disambiguate_fortran(file_context)
    buffer = file_context.contents

    definitely_not_f77 = /^ [^0-9 ]{5}/
    return 'fortranfixed' if lines_matching(buffer, definitely_not_f77) > 0

    free_form_continuation = /&\s*\n\s*&/m
    return 'fortranfree' if buffer.match(free_form_continuation)

    possibly_fixed = /^ [0-9 ]{5}/
    contig_number = /^\s*\d+\s*$/
    buffer.scan(possibly_fixed) {|leader|
      return 'fortranfixed' if !(leader =~ contig_number) }
    # Might as well be free-form.
    return 'fortranfree'
  end

	# Attempts to determine the Polyglot for files that do not have a
	# filename extension.
	#
	# Relies on the bash +file+ command line tool as its primary method.
	#
	# There must be a file at <tt>file_context.file_location</tt> for +file+
	# to operate on.
	#
  def self.disambiguate_nil(file_context)
    file_location = file_context.file_location
    output = `file -b #{ file_location }`
    case output
    when /([\w\/]+) script text/, /script text executable for ([\w\/]+)/
      script = $1
      if script =~ /\/(\w*)$/
        script = $1
      end
      known_languages = EXTENSION_MAP.values
      return script.downcase if known_languages.include?(script.downcase)
    when /([\w\-]*) shell script text/
      case $1
      when "Bourne-Again"
        return "shell"
      end
    end

    # dang... no dice
    nil
  end

end
