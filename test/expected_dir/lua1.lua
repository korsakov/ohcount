lua	comment	-- random code from http://lua-users.org/wiki/TextJustification
lua	comment	-- easy queue implementation ------------------------------------------
lua	blank	
lua	code	function q_create()
lua	code	    local q = {}
lua	code	    q.first = 0
lua	code	    q.last = 0
lua	code	    return q
lua	code	end
lua	blank	
lua	code	function q_insert(q, s)
lua	code	    q[q.last] = s
lua	code	    q.last = q.last + 1
lua	code	end
lua	blank	
lua	code	function q_empty(q)
lua	code	    return q.first >= q.last
lua	code	end
lua	blank	
lua	code	function q_remove(q)
lua	code	    if q_empty(q) then
lua	code	        return nil
lua	code	    end
lua	code	    local s = q[q.first]
lua	code	    q[q.first] = nil
lua	code	    q.first = q.first+1
lua	code	    return s
lua	code	end
lua	blank	
lua	code	function q_card(q)
lua	code	    return q.last - q.first
lua	code	end
lua	blank	
lua	code	function q_length(q, f)
lua	code	    local l, i = 0, q.first
lua	code	    while i < q.last do
lua	code	        l = l + strlen(q[i])
lua	code	        i = i + 1
lua	code	    end
lua	code	    return l
lua	code	end
lua	blank	
lua	comment	-- line creation routines ------------------------------------------
lua	blank	
lua	comment	-- justifies one line to fit into MAX columns 
lua	code	function justify(q)
lua	code	    local blanks = MAX - q_length(q)
lua	code	    local skips = q_card(q) - 1
lua	code	    local line = q_remove(q)
lua	code	    local quotient = floor(blanks/skips)
lua	code	    local reminder = blanks/skips - quotient
lua	code	    local error = 0
lua	code	    while skips > 0 do
lua	code	        error = error + reminder
lua	code	        if error >= 0.5 then
lua	code	            error = error - 1
lua	code	            line = line .. strrep(" ", quotient+1)
lua	code	        else
lua	code	            line = line .. strrep(" ", quotient)
lua	code	        end
lua	code	        line = line .. q_remove(q)
lua	code	        skips = skips - 1
lua	code	    end
lua	code	    return line or ""
lua	code	end
lua	blank	
lua	comment	-- join all words with one space between them
lua	code	function catenate(q)
lua	code	    local line = q_remove(q)
lua	code	    while not q_empty(q) do
lua	code	        line = line .. " " .. q_remove(q)
lua	code	    end
lua	code	    return line or ""
lua	code	end
lua	blank	
lua	comment	-- main program -----------------------------------------------------
lua	code	DEFMAX = 72
lua	comment	-- tries to get MAX from command-line
lua	code	if not arg or getn(arg) < 1 then
lua	code	    MAX = DEFMAX
lua	code	else
lua	code	    MAX = tonumber(arg[1])
lua	code	    if not MAX or MAX < 0 then
lua	code	        MAX = DEFMAX
lua	code	    end
lua	code	end
lua	blank	
lua	comment	-- collects all text from stdin
lua	code	text = q_create()
lua	code	line = read()
lua	code	while line do
lua	code	    _, n = gsub(line, "(%S+)", function (s) q_insert(%text, s) end)
lua	code	    if n == 0 then
lua	code	        q_insert(text, "\n")
lua	code	    end
lua	code	    line = read()
lua	code	end
lua	blank	
lua	comment	-- justify paragraphs
lua	code	line = q_create()
lua	code	word = q_remove(text)
lua	code	size = 0
lua	code	while word do
lua	code	    if word == "\n" then
lua	code	        if not q_empty(line) then
lua	code	            write(catenate(line), "\n\n")
lua	code	        else
lua	code	            write("\n")
lua	code	        end
lua	code	        size = 0
lua	code	    elseif size + strlen(word) > MAX then
lua	code	        write(justify(line), "\n")
lua	code	        size = 0
lua	code	    end
lua	code	    if word ~= "\n" then
lua	code	        q_insert(line, word)
lua	code	        size = size + strlen(word) + 1
lua	code	    end
lua	code	    word = q_remove(text)
lua	code	end
lua	code	write(catenate(line), "\n")
