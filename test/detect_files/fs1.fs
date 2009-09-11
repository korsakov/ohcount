// a F# file
    type FilterNode(provider, token, filter: FilterExpression, node_list) =
        inherit TagNode(provider, token)
