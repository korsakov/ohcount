haxe	comment	/*
haxe	comment	# ***** BEGIN LICENSE BLOCK *****
haxe	comment	Copyright the original author or authors.
haxe	comment	Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
haxe	comment	you may not use this file except in compliance with the License.
haxe	comment	You may obtain a copy of the License at
haxe	comment		http://www.mozilla.org/MPL/MPL-1.1.html
haxe	comment	Unless required by applicable law or agreed to in writing, software
haxe	comment	distributed under the License is distributed on an "AS IS" BASIS,
haxe	comment	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
haxe	comment	See the License for the specific language governing permissions and
haxe	comment	limitations under the License.
haxe	blank	
haxe	comment	# ***** END LICENSE BLOCK *****
haxe	comment	*/
haxe	blank	
haxe	code	package sandy.parser;
haxe	blank	
haxe	comment	/**
haxe	comment	 * The Parser factory class creates instances of parser classes.
haxe	comment	 * The specific parser can be specified in the create method's second parameter.
haxe	comment	 *
haxe	comment	 * @author		Thomas Pfeiffer - kiroukou
haxe	comment	 * @author Niel Drummond - haXe port
haxe	comment	 *
haxe	comment	 *
haxe	comment	 *
haxe	comment	 * @example To parse a 3DS file at runtime:
haxe	comment	 *
haxe	comment	 * <listing version="3.0">
haxe	comment	 *     var parser:IParser = Parser.create( "/path/to/my/3dsfile.3ds", Parser.max );
haxe	comment	 * </listing>
haxe	comment	 *
haxe	comment	 */
haxe	blank	
haxe	code	class Parser
haxe	code	{
haxe	comment		/**
haxe	comment		 * Parameter that is used to specify that the ASE (ASCII Scene Export)
haxe	comment		 * Parser should be used
haxe	comment		 */
haxe	code		public static var ASE:String = "ASE";
haxe	comment		/**
haxe	comment		 * Parameter that is used to specify that the 3DS (3D Studio) Parser
haxe	comment		 * should be used
haxe	comment		 */
haxe	code		public static var MAX_3DS:String = "3DS";
haxe	comment		/**
haxe	comment		 * Parameter that is used to specify that the COLLADA (COLLAborative
haxe	comment		 * Design Activity ) Parser should be used
haxe	comment		 */
haxe	code		public static var COLLADA:String = "DAE";
haxe	blank	
haxe	comment		/**
haxe	comment		 * The create method chooses which parser to use. This can be done automatically
haxe	comment		 * by looking at the file extension or by passing the parser type String as the
haxe	comment		 * second parameter.
haxe	comment		 *
haxe	comment		 * @example To parse a 3DS file at runtime:
haxe	comment		 *
haxe	comment		 * <listing version="3.0">
haxe	comment		 *     var parser:IParser = Parser.create( "/path/to/my/3dsfile.3ds", Parser.MAX );
haxe	comment		 * </listing>
haxe	comment		 *
haxe	comment		 * @param p_sFile			Can be either a string pointing to the location of the
haxe	comment		 * 							file or an instance of an embedded file
haxe	comment		 * @param p_sParserType		The parser type string
haxe	comment		 * @param p_nScale			The scale factor
haxe	comment		 * @return					The parser to be used
haxe	comment		 */
haxe	code		public static function create( p_sFile:Dynamic, ?p_sParserType:String, ?p_nScale:Float ):IParser
haxe	code		{
haxe	code	        if ( p_nScale == null ) p_nScale = 1;
haxe	blank	
haxe	code			var l_sExt:String,l_iParser:IParser = null;
haxe	comment			// --
haxe	code			if( Std.is( p_sFile, String ) && p_sParserType == null )
haxe	code			{
haxe	code				l_sExt = (p_sFile.split('.')).reverse()[0];
haxe	code			}
haxe	code			else
haxe	code			{
haxe	code				l_sExt = p_sParserType;
haxe	code			}
haxe	comment			// --
haxe	code			switch( l_sExt.toUpperCase() )
haxe	code			{
haxe	code				case "ASE":
haxe	code					l_iParser = new ASEParser( p_sFile, p_nScale );
haxe	code				case "OBJ":
haxe	code				case "DAE":
haxe	code					l_iParser = new ColladaParser( p_sFile, p_nScale );
haxe	code				case "3DS":
haxe	code					l_iParser = new Parser3DS( p_sFile, p_nScale );
haxe	code				default:
haxe	code			}
haxe	comment			// --
haxe	code			return l_iParser;
haxe	code		}
haxe	code	}
haxe	blank	
