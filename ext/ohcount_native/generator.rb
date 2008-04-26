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
			actionscript = CMonoglot.new("actionscript",   '//',             [e('/*'), e('*/')], true,  true)
			ada = CMonoglot.new("ada",                 '--',             nil,                true,  false)
			assembler = CMonoglot.new("assembler",     [';', '!', '//'], [e('/*'), e('*/')], false, false)
			autoconf = LineCommentMonoglot.new("autoconf", 'dnl')
			automake = LineCommentMonoglot.new("automake", '#')
			awk = CMonoglot.new("awk",                 '#',              nil,                true,  false, {:no_escape_dquote => true})
			bat = LineCommentMonoglot.new("bat",        '^\\\\s*(?i)REM(?-i)')
			boo = PythonMonoglot.new("boo")
			clearsilver = CMonoglot.new("clearsilver", '#',              nil,                true,  true)
			c = CMonoglot.new("c",                     '//',             [e('/*'), e('*/')], true,  true)
			cpp = CMonoglot.new("cpp",                 '//',             [e('/*'), e('*/')], true,  true)
			csharp = CMonoglot.new("csharp",           '//',             [e('/*'), e('*/')], true,  false)
			css = CMonoglot.new("css",                  nil,             [e('/*'), e('*/')], false,  false)
			dcl = DclMonoglot.new("dcl")
			dylan = CMonoglot.new("dylan",             '//',             nil,                true,  false)
			ebuild = CMonoglot.new("ebuild",           '#',              nil,                false, false)
			erlang = CMonoglot.new("erlang",           '%%',             nil,                true,  true)
			java = CMonoglot.new("java",               '//',             [e('/*'), e('*/')], true,  false)
			javascript = CMonoglot.new("javascript",   '//',             [e('/*'), e('*/')], true,  true)
			emacslisp = LineCommentMonoglot.new("emacslisp", ";")
			fortranfixed = CMonoglot.new("fortranfixed", '^[^ \n]',          nil,                true,  true, {:no_escape_dquote => true, :no_escape_squote => true})
			fortranfree  = CMonoglot.new("fortranfree",  '!',            nil,                true,  true, {:no_escape_dquote => true, :no_escape_squote => true})
			haskell = CMonoglot.new("haskell",         '--',             [e('{-'), e('-}')], true, false)
			lisp = LineCommentMonoglot.new("lisp", ";")
			lua = CMonoglot.new("lua",                 '--',             nil,                true,  true)
			make = LineCommentMonoglot.new("make",     '#')
			matlab = CMonoglot.new("matlab",           '#|%',            ['{%', '%}'], false,true)
			metafont = LineCommentMonoglot.new("metafont", "%");
			metapost = LineCommentMonoglot.new("metapost", "%");
			objective_c = CMonoglot.new("objective_c", '//',             [e('/*'), e('*/')], true,  false)
			pascal = CMonoglot.new("pascal",           '//',             ['{','}'],          true,  true, {:no_escape_dquote => true, :no_escape_squote => true})
			perl = CMonoglot.new("perl",               '#',              ['^=\\\\w+', '^=cut[ \t]*\\\\n'],  true,  true)
			phplanguage = CMonoglot.new("php",         '//',             [e('/*'), e('*/')], true,  true, {:polyglot_name => 'phplanguage'})
			pike = CMonoglot.new("pike",             '//',             [e('/*'), e('*/')], true,  false)
			python = PythonMonoglot.new("python")
			ruby = CMonoglot.new("ruby",               '#',              nil,                true,  true)
			rexx = CMonoglot.new("rexx",               nil,              [e('/*'), e('*/')], true,  true)
			scheme = LineCommentMonoglot.new("scheme", ";")
			shell = CMonoglot.new("shell",             '#',              nil,                false, false)
			smalltalk = CMonoglot.new("smalltalk",            nil,             [e('"'), e('"')], false,  true, options = {:no_escape_squote => true})
			sql = CMonoglot.new("sql",                 ['--','//'],      [['{','}'], [e('/*'), e('*/')]], true, true)
			tcl = CMonoglot.new("tcl",                 '#',              nil,                true,  false)
			vala = CMonoglot.new("vala",               '//',             [e('/*'), e('*/')], true,  false)
			vim = CMonoglot.new("vim",                 '\"',             nil,                false, false)
			visualbasic = CMonoglot.new("visualbasic", '\'',             nil,                true,  false)
			xml = XmlMonoglot.new("xml")
			xslt = XmlMonoglot.new("xslt")
			xmlschema = XmlMonoglot.new("xmlschema")
			mxml = MxmlPolyglot.new("mxml", actionscript, css)
			html = HtmlPolyglot.new("html", javascript, css)
			php = HtmlWithPhpPolyglot.new("php", html, phplanguage)
			rhtml = RhtmlPolyglot.new("rhtml", html, ruby)
			jsp = JspPolyglot.new("jsp", html, java)
			groovy = CMonoglot.new("groovy",           '//',             [e('/*'), e('*/')], true,  false)
			clearsilver_template = ClearsilverTemplate.new("clearsilver_template", html, clearsilver)
			dmd = DMonoglot.new('dmd')
			tex = CMonoglot.new("tex",             '%',              nil,                false, false)
			metapost_with_tex = Biglot.new('metapost_with_tex', metapost, tex, [], [
				["verbatimtex", :metapost_code, :tex_code, :from, false, 'verbatim'],
				["btex", :metapost_code, :tex_code, :from, false, 'btex'],
				["etex", :tex_code, :return, :to, false, 'etex']
			]);
			polyglots = [
			  actionscript ,
				ada ,
				assembler ,
				autoconf ,
				automake ,
				awk ,
				bat ,
				boo ,
				clearsilver ,
				c ,
				cpp ,
				csharp ,
				css ,
        dcl,
				dylan ,
				ebuild ,
				erlang ,
				groovy ,
				java ,
				javascript ,
				emacslisp ,
				fortranfixed ,
				fortranfree ,
				haskell,
				lisp ,
				lua ,
				make ,
				matlab,
				metafont,
				metapost,
				objective_c,
				pascal ,
				perl ,
				pike ,
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
				vim ,
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
				tex,
				metapost_with_tex,
				mxml
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
