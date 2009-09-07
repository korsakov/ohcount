(***************************************************************************
 * 
 *  The Parser is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Lesser General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *  
 ***************************************************************************)

namespace Tags

open System
open System.Reflection;
open System.Runtime.CompilerServices;
open System.Runtime.InteropServices;

module internal Filter =

    let FILTER_VARIABLE_NAME = "$filter"

    type FilterNode(provider, token, filter: FilterExpression, node_list) =
        inherit TagNode(provider, token)

        override this.walk manager walker = 
            let reader = 
                new NDjango.ASTWalker.Reader (manager, {walker with parent=None; nodes=node_list; context=walker.context}) 
            match filter.ResolveForOutput manager
                     {walker with context=walker.context.add(FILTER_VARIABLE_NAME, (reader.ReadToEnd():>obj))}
                with
            | Some w -> w
            | None -> walker

    /// Filters the contents of the block through variable filters.
    /// 
    /// Filters can also be piped through each other, and they can have
    /// arguments -- just like in variable syntax.
    /// 
    /// Sample usage::
    /// 
    ///     {% filter force_escape|lower %}
    ///         This text will be HTML-escaped, and will appear in lowercase.
    ///     {% endfilter %}
    type FilterTag() =
        interface ITag with
            member this.Perform token provider tokens =
                match token.Args with
                | filter::[] ->
                    let filter_expr = new FilterExpression(provider, Block token, FILTER_VARIABLE_NAME + "|" + filter)
                    let node_list, remaining = (provider :?> IParser).Parse (Some token) tokens ["endfilter"]
                    (new FilterNode(provider, token, filter_expr, node_list) :> INodeImpl), remaining
                | _ -> raise (SyntaxError ("'filter' tag requires one argument"))
