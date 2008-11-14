# Tools

module Ohcount
  module Gestalt
    class VisualStudio < Tool
      filenames '\.(sln|vcproj|vsproj|csproj|vbproj|vbp)$'
    end

    class Eclipse < Tool
      filenames '\.(project|classpath)$'
    end

    class NetBeans < Tool
      filenames '\bnbplatform\b'
      filenames '\.nbm$'
    end
  end
end
