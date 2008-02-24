# A generic data object for returning parsing results from Ohcount to Ohloh.
#
# This class has the additional job of declaring a "nice" (human readable) name
# for each language, as well as the category (procedural code vs. markup) for each
# language. These features should probably live elsewhere, and are currently
# not covered by unit tests.
class Ohcount::SlocInfo
	attr_reader :language
	attr_accessor :code_added, :code_removed, :comments_added, :comments_removed, :blanks_added, :blanks_removed

	def initialize(language)
		raise ArgumentError.new('language can not be nil') unless language
		@language = language
		@code_added       = 0
		@code_removed     = 0
		@comments_added   = 0
		@comments_removed = 0
		@blanks_added     = 0
		@blanks_removed   = 0
	end

	def ==(b)
		@language         == b.language &&
		@code_added       == b.code_added &&
		@code_removed     == b.code_removed &&
		@comments_added   == b.comments_added &&
		@comments_removed == b.comments_removed &&
		@blanks_added     == b.blanks_added &&
		@blanks_removed   == b.blanks_removed
	end

	def empty?
		if (@code_added       == 0 && @code_removed     == 0 &&
			  @comments_added   == 0 && @comments_removed == 0 &&
			  @blanks_added     == 0 && @blanks_removed   == 0)
			return true
		end
		return false
	end

	@@lang_map = {
			'ada'           => {:nice_name => 'Ada'              , :category => 0},
			'assembler'     => {:nice_name => 'Assembler'        , :category => 0},
			'awk'           => {:nice_name => 'AWK'              , :category => 0},
			'bat'           => {:nice_name => 'DOS batch script' , :category => 0},
			'boo'           => {:nice_name => 'Boo'              , :category => 0},
			'cncpp'         => {:nice_name => 'C/C++'            , :category => 0},
			'clearsilver'   => {:nice_name => 'ClearSilver'      , :category => 0},
			'csharp'        => {:nice_name => 'C#'               , :category => 0},
			'css'           => {:nice_name => 'CSS'              , :category => 1},
			'dylan'         => {:nice_name => 'Dylan'            , :category => 0},
			'emacslisp'     => {:nice_name => 'Emacs Lisp'       , :category => 0},
			'erlang'        => {:nice_name => 'Erlang'           , :category => 0},
			'fortranfixed'  => {:nice_name => 'Fixed-format Fortran', :category => 0},
			'fortranfree'   => {:nice_name => 'Free-format Fortran',  :category => 0},
			'groovy'        => {:nice_name => 'Groovy'           , :category => 0},
			'html'          => {:nice_name => 'HTML'             , :category => 1},
			'java'          => {:nice_name => 'Java'             , :category => 0},
			'javascript'    => {:nice_name => 'JavaScript'       , :category => 0},
			'lisp'          => {:nice_name => 'Lisp'             , :category => 0},
			'lua'           => {:nice_name => 'Lua'              , :category => 0},
			'matlab'        => {:nice_name => 'Matlab'           , :category => 0},
			'objective_c'   => {:nice_name => 'Objective C'      , :category => 0},
			'pascal'        => {:nice_name => 'Pascal'           , :category => 0},
			'perl'          => {:nice_name => 'Perl'             , :category => 0},
			'php'           => {:nice_name => 'PHP'              , :category => 0},
			'python'        => {:nice_name => 'Python'           , :category => 0},
			'rexx'          => {:nice_name => 'rexx'             , :category => 0},
			'ruby'          => {:nice_name => 'Ruby'             , :category => 0},
			'scheme'        => {:nice_name => 'Scheme'           , :category => 0},
			'shell'         => {:nice_name => 'shell script'     , :category => 0},
			'sql'           => {:nice_name => 'SQL'              , :category => 0},
			'tcl'           => {:nice_name => 'Tcl'              , :category => 0},
			'vala'          => {:nice_name => 'Vala'             , :category => 0},
			'visualbasic'   => {:nice_name => 'Visual Basic'     , :category => 0},
			'xml'           => {:nice_name => 'XML'              , :category => 1},
			'xmlschema'     => {:nice_name => 'XML Schema'       , :category => 1},
			'xslt'          => {:nice_name => 'XSL Transformation',:category => 0},
			'dmd'           => {:nice_name => 'D'                , :category => 0},
			'tex'           => {:nice_name => 'TeX/LaTeX'        , :category => 1},
			'haskell'       => {:nice_name => 'Haskell'          , :category => 0}
	}

	# Returns the human readable name for a language.
	def language_nice_name
		@@lang_map[self.language][:nice_name]
	end

	# Returns the category (procedural code vs. markup) for a language.
	#
	# Category 0 indicates procedural code (most languages).
	# Category 1 indicates a markup file, such as XML.
	def language_category
		@@lang_map[self.language][:category]
	end

end
