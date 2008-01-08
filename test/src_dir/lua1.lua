-- random code from http://lua-users.org/wiki/TextJustification
-- easy queue implementation ------------------------------------------

function q_create()
    local q = {}
    q.first = 0
    q.last = 0
    return q
end

function q_insert(q, s)
    q[q.last] = s
    q.last = q.last + 1
end

function q_empty(q)
    return q.first >= q.last
end

function q_remove(q)
    if q_empty(q) then
        return nil
    end
    local s = q[q.first]
    q[q.first] = nil
    q.first = q.first+1
    return s
end

function q_card(q)
    return q.last - q.first
end

function q_length(q, f)
    local l, i = 0, q.first
    while i < q.last do
        l = l + strlen(q[i])
        i = i + 1
    end
    return l
end

-- line creation routines ------------------------------------------

-- justifies one line to fit into MAX columns 
function justify(q)
    local blanks = MAX - q_length(q)
    local skips = q_card(q) - 1
    local line = q_remove(q)
    local quotient = floor(blanks/skips)
    local reminder = blanks/skips - quotient
    local error = 0
    while skips > 0 do
        error = error + reminder
        if error >= 0.5 then
            error = error - 1
            line = line .. strrep(" ", quotient+1)
        else
            line = line .. strrep(" ", quotient)
        end
        line = line .. q_remove(q)
        skips = skips - 1
    end
    return line or ""
end

-- join all words with one space between them
function catenate(q)
    local line = q_remove(q)
    while not q_empty(q) do
        line = line .. " " .. q_remove(q)
    end
    return line or ""
end

-- main program -----------------------------------------------------
DEFMAX = 72
-- tries to get MAX from command-line
if not arg or getn(arg) < 1 then
    MAX = DEFMAX
else
    MAX = tonumber(arg[1])
    if not MAX or MAX < 0 then
        MAX = DEFMAX
    end
end

-- collects all text from stdin
text = q_create()
line = read()
while line do
    _, n = gsub(line, "(%S+)", function (s) q_insert(%text, s) end)
    if n == 0 then
        q_insert(text, "\n")
    end
    line = read()
end

-- justify paragraphs
line = q_create()
word = q_remove(text)
size = 0
while word do
    if word == "\n" then
        if not q_empty(line) then
            write(catenate(line), "\n\n")
        else
            write("\n")
        end
        size = 0
    elseif size + strlen(word) > MAX then
        write(justify(line), "\n")
        size = 0
    end
    if word ~= "\n" then
        q_insert(line, word)
        size = size + strlen(word) + 1
    end
    word = q_remove(text)
end
write(catenate(line), "\n")
