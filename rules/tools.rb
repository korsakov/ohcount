# Tools
include Ohcount::Gestalt

class VisualStudio < Tool
	trigger_libs :visual_studio_files
end

class Eclipse < Tool
	files 'Makefile.conf'
end
