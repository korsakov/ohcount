# Tools
class VisualStudio < Tool
	c_headers 'pthread.h', 'xstrtol.h', 'xreadlink.h', 'fatal-signal.h', 'diacrit.h'
end

class Eclipse < Tool
	files 'Makefile.conf'
end
