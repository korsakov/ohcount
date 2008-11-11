# Tools
include Ohcount::Gestalt

class VisualStudio < Tool
	filenames '\.(sln|vcproj|vsproj|csproj|vbproj|vbp)$'
end

class Eclipse < Tool
	filenames '\.(project|classpath)$'
end
