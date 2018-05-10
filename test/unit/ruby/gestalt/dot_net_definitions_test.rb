require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../../../../ruby/gestalt'
include Ohcount
include Ohcount::Gestalt

class DotNetDefinitionsTest < Ohcount::Test

	def test_wpf
		platforms = get_gestalts('wpf').map { |g| g.name if g.type == :platform }.compact
		assert platforms.include?("dot_net")
		assert platforms.include?("wpf")
	end

	def test_asp_net
		platforms = get_gestalts('asp_net').map { |g| g.name if g.type == :platform }.compact
		assert platforms.include?("dot_net")
		assert platforms.include?("asp_net")
	end


	def test_silverlight_via_asp_keyword
		sf = SourceFile.new('foo.aspx', :contents => <<-CONTENTS
<body>
	<asp:Silverlight runat="server"/>
</body>
CONTENTS
		)
		platforms = sf.gestalts.map { |g| g.name if g.type == :platform }.compact
		assert platforms.include?('dot_net')
		assert platforms.include?('asp_net')
		assert platforms.include?('silverlight')
  end

	def test_silverlight_via_csproj_import
		sf = SourceFile.new('Foo.csproj', :contents => <<-CONTENTS
<Project ToolsVersion="3.5" DefaultTargets="Build" xmlns="http://schemas.microsoft.com/developer/msbuild/2003">
  <Import Project="$(MSBuildExtensionsPath)\\Microsoft\\Silverlight\\v2.0\\Microsoft.Silverlight.CSharp.targets" />
</Project>
		CONTENTS
		)
		platforms = sf.gestalts.map { |g| g.name if g.type == :platform }.compact
		assert platforms.include?('dot_net')
		assert platforms.include?('silverlight')

		tools = sf.gestalts.map { |g| g.name if g.type == :tool }.compact
		assert tools.include?('visualstudio')
  end
end
