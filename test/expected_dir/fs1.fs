fsharp	comment	(***************************************************************************
fsharp	comment	 * 
fsharp	comment	 *  The Parser is free software: you can redistribute it and/or modify
fsharp	comment	 *  it under the terms of the GNU Lesser General Public License as published by
fsharp	comment	 *  the Free Software Foundation, either version 3 of the License, or
fsharp	comment	 *  (at your option) any later version.
fsharp	comment	 *  
fsharp	comment	 ***************************************************************************)
fsharp	blank	
fsharp	code	namespace Tags
fsharp	blank	
fsharp	code	open System
fsharp	code	open System.Reflection;
fsharp	code	open System.Runtime.CompilerServices;
fsharp	code	open System.Runtime.InteropServices;
fsharp	blank	
fsharp	code	module internal Filter =
fsharp	blank	
fsharp	code	    let FILTER_VARIABLE_NAME = "$filter"
fsharp	blank	
fsharp	code	    type FilterNode(provider, token, filter: FilterExpression, node_list) =
fsharp	code	        inherit TagNode(provider, token)
fsharp	blank	
fsharp	code	        override this.walk manager walker = 
fsharp	code	            let reader = 
fsharp	code	                new NDjango.ASTWalker.Reader (manager, {walker with parent=None; nodes=node_list; context=walker.context}) 
fsharp	code	            match filter.ResolveForOutput manager
fsharp	code	                     {walker with context=walker.context.add(FILTER_VARIABLE_NAME, (reader.ReadToEnd():>obj))}
fsharp	code	                with
fsharp	code	            | Some w -> w
fsharp	code	            | None -> walker
fsharp	blank	
fsharp	comment	    /// Filters the contents of the block through variable filters.
fsharp	comment	    /// 
fsharp	comment	    /// Filters can also be piped through each other, and they can have
fsharp	comment	    /// arguments -- just like in variable syntax.
fsharp	comment	    /// 
fsharp	comment	    /// Sample usage::
fsharp	comment	    /// 
fsharp	comment	    ///     {% filter force_escape|lower %}
fsharp	comment	    ///         This text will be HTML-escaped, and will appear in lowercase.
fsharp	comment	    ///     {% endfilter %}
fsharp	code	    type FilterTag() =
fsharp	code	        interface ITag with
fsharp	code	            member this.Perform token provider tokens =
fsharp	code	                match token.Args with
fsharp	code	                | filter::[] ->
fsharp	code	                    let filter_expr = new FilterExpression(provider, Block token, FILTER_VARIABLE_NAME + "|" + filter)
fsharp	code	                    let node_list, remaining = (provider :?> IParser).Parse (Some token) tokens ["endfilter"]
fsharp	code	                    (new FilterNode(provider, token, filter_expr, node_list) :> INodeImpl), remaining
fsharp	code	                | _ -> raise (SyntaxError ("'filter' tag requires one argument"))
