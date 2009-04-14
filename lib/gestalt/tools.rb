# Tools

module Ohcount
  module Gestalt
    class VisualStudio < Tool
      filenames '\.(sln|vcproj|vsproj|csproj|vbproj|vbp)$'
    end

    class EclipseIDE < Tool
      filenames '\.(project|classpath)$'
    end

    class NetBeansIDE < Tool
      filenames '\bnbplatform\b'
      filenames '\.nbm$'
    end
  end
end
