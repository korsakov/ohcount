require 'state'
require 'transition'
require 'escape_helper'

# So that monoglot and polyglot source files can easily require eachother
$LOAD_PATH << File.join(File.dirname(__FILE__), 'glots')

# Load all monoglots and polyglots
Dir.glob(File.join(File.dirname(__FILE__), 'glots/*.rb')).each {|f| require f }

module Ohcount
	class Generator
		include EscapeHelper

		# This script loads all of the Monoglot and Polyglot files found in
		# <tt>ext/ohcount_native/glots</tt>.
		#
		# These glots are used to generate the C file polyglots.c, which will define
		# all of the languages parsers used by ohcount. Do not edit polyglots.c directly.
		def generate

			# Defines all of the monoglots and polyglots known to the parser.
			ada = CMonoglot.new("ada",                 '--',             nil,                true,  false)
			assembler = CMonoglot.new("assembler",     [';', '!', '//'], [e('/*'), e('*/')], false, false)
			awk = CMonoglot.new("awk",                 '#',              nil,                true,  false, {:no_escape_dquote => true})
			bat = LineCommentMonoglot.new("bat",        '^\\\\s*(?i)REM(?-i)')
			boo = PythonMonoglot.new("boo")
			clearsilver = CMonoglot.new("clearsilver", '#',              nil,                true,  true)
			cncpp = CMonoglot.new("cncpp",             '//',             [e('/*'), e('*/')], true,  false)
			csharp = CMonoglot.new("csharp",           '//',             [e('/*'), e('*/')], true,  false)
			css = CMonoglot.new("css",                  nil,             [e('/*'), e('*/')], false,  false)
			dylan = CMonoglot.new("dylan",             '//',             nil,                true,  false)
			erlang = CMonoglot.new("erlang",           '%%',             nil,                true,  true)
			java = CMonoglot.new("java",               '//',             [e('/*'), e('*/')], true,  false)
			javascript = CMonoglot.new("javascript",   '//',             [e('/*'), e('*/')], true,  true)
			emacslisp = LineCommentMonoglot.new("emacslisp", ";")
			haskell = CMonoglot.new("haskell",         '--',             [e('{-'), e('-}')], true, false)
			lisp = LineCommentMonoglot.new("lisp", ";")
			lua = CMonoglot.new("lua",                 '--',             nil,                true,  true)
			matlab = CMonoglot.new("matlab",           '#|%',            ['{%', '%}'], false,true)
			objective_c = CMonoglot.new("objective_c", '//',             [e('/*'), e('*/')], true,  false)
			pascal = CMonoglot.new("pascal",           '//',             ['{','}'],          true,  false)
			perl = CMonoglot.new("perl",               '#',              ['^=\\\\w+', '^=cut[ \t]*\\\\n'],  true,  true)
			phplanguage = CMonoglot.new("php",         '//',             [e('/*'), e('*/')], true,  true, {:polyglot_name => 'phplanguage'})
			python = PythonMonoglot.new("python")
			ruby = CMonoglot.new("ruby",               '#',              nil,                true,  true)
			rexx = CMonoglot.new("rexx",               nil,              [e('/*'), e('*/')], true,  true)
			scheme = LineCommentMonoglot.new("scheme", ";")
			shell = CMonoglot.new("shell",             '#',              nil,                false, false)
			smalltalk = CMonoglot.new("smalltalk",            nil,             [e('"'), e('"')], false,  true, options = {:no_escape_squote => true})
			sql = CMonoglot.new("sql",                 ['--','//'],      [['{','}'], [e('/*'), e('*/')]], true, true)
			tcl = CMonoglot.new("tcl",                 '#',              nil,                true,  false)
			vala = CMonoglot.new("vala",               '//',             [e('/*'), e('*/')], true,  false)
			visualbasic = CMonoglot.new("visualbasic", '\'',             nil,                true,  false)
			xml = XmlMonoglot.new("xml")
			xslt = XmlMonoglot.new("xslt")
			xmlschema = XmlMonoglot.new("xmlschema")
			html = HtmlPolyglot.new("html", javascript, css)
			php = HtmlWithPhpPolyglot.new("php", html, phplanguage)
			rhtml = RhtmlPolyglot.new("rhtml", html, ruby)
			jsp = JspPolyglot.new("jsp", html, java)
			groovy = CMonoglot.new("groovy",           '//',             [e('/*'), e('*/')], true,  false)
			clearsilver_template = ClearsilverTemplate.new("clearsilver_template", html, clearsilver)
			dmd = DMonoglot.new('dmd')
			tex = CMonoglot.new("tex",             '%',              nil,                false, false)
			polyglots = [
				ada ,
				assembler ,
				awk ,
				bat ,
				boo ,
				clearsilver ,
				cncpp ,
				csharp ,
				css ,
				dylan ,
				erlang ,
				groovy ,
				java ,
				javascript ,
				emacslisp ,
				haskell,
				lisp ,
				lua ,
				matlab,
				objective_c,
				pascal ,
				perl ,
				phplanguage ,
				python ,
				ruby ,
				rexx ,
				scheme ,
				shell ,
				smalltalk ,
				sql ,
				tcl ,
				vala ,
				visualbasic ,
				xml ,
				xmlschema ,
				xslt ,
				dmd ,

				# poly
				html,
				php,
				rhtml,
				jsp,
				clearsilver_template,
				tex
			]
			File.open("polyglots.c", "w") do |io|

				# spit out the preamble to our source code
				io.puts <<PREAMBLE
/*
 * polyglots.c
 * Ohcount
 *
 * GENERATED FILE **DO NOT EDIT**
 *
 */

#define __polyglots_c__
#include "common.h"

#define RETURN (State *)NULL
PREAMBLE

				# spits out the actual POLYGLOTS array, which contains a reference to all the polyglots we define in our library
				polyglots.each do |p|
					p.print(io)
				end
				io.puts "\n"
				Monoglot::print_banner(io, "POLYGLOTS")
				io.puts "Polyglot *POLYGLOTS[] = {"
				polyglots.each do |p|
					io.puts "	&#{ p.definition },"
				end
				io.puts "	NULL\n};"
			end
		end
	end
end

Ohcount::Generator.new.generate
