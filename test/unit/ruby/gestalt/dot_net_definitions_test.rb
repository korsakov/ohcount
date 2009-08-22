require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../../../../ruby/gestalt'
include Ohcount
include Ohcount::Gestalt

class DotNetDefinitionsTest < Test::Unit::TestCase

	def test_nunit
		sf = SourceFile.new('foo.cs', :contents => <<-CONTENTS
using NUnit.Framework;
CONTENTS
											 )
    assert_equal [
			Gestalt::Base.new(:platform, 'Dot_NET'),
			Gestalt::Base.new(:platform, 'NUnit')
		], sf.gestalts.sort
  end

	def test_nhibernate
		sf = SourceFile.new('foo.cs', :contents => <<-CONTENTS
using NHibernate.Connection.DriverConnectionProvider;
CONTENTS
											 )
    assert_equal [
			Gestalt::Base.new(:platform, 'Dot_NET'),
			Gestalt::Base.new(:platform, 'NHibernate')
		], sf.gestalts.sort
  end

	def test_remoting_implies_enterprise
		sf = SourceFile.new('foo.cs', :contents => <<-CONTENTS
using System.Runtime.Remoting;
CONTENTS
											 )
    assert_equal [
			Gestalt::Base.new(:platform, 'Dot_NET'),
			Gestalt::Base.new(:platform, 'Dot_NET_Enterprise')
		], sf.gestalts.sort
  end

	def test_biztalk_implies_enterprise
		sf = SourceFile.new('foo.cs', :contents => <<-CONTENTS
using Microsoft.BizTalk;
CONTENTS
											 )
    assert_equal [
			Gestalt::Base.new(:platform, 'Dot_NET'),
			Gestalt::Base.new(:platform, 'Dot_NET_BizTalk'),
			Gestalt::Base.new(:platform, 'Dot_NET_Enterprise')
		], sf.gestalts.sort
  end

	def test_linq_implies_enterprise
		sf = SourceFile.new('foo.cs', :contents => <<-CONTENTS
using System.Data.Linq;
CONTENTS
											 )
    assert_equal [
			Gestalt::Base.new(:platform, 'Dot_NET'),
			Gestalt::Base.new(:platform, 'Dot_NET_Enterprise')
		], sf.gestalts.sort
  end

	def test_silverlight_via_asp_keyword
		sf = SourceFile.new('foo.aspx', :contents => <<-CONTENTS
<body>
	<asp:Silverlight runat="server"/>
</body>
CONTENTS
		)
    assert_equal [
			Gestalt::Base.new(:platform, 'ASP_NET'),
			Gestalt::Base.new(:platform, 'silverlight')
		], sf.gestalts.sort
  end

	def test_silverlight_via_csproj_import
		sf = SourceFile.new('Foo.csproj', :contents => <<-CONTENTS
<Project ToolsVersion="3.5" DefaultTargets="Build" xmlns="http://schemas.microsoft.com/developer/msbuild/2003">
  <Import Project="$(MSBuildExtensionsPath)\\Microsoft\\Silverlight\\v2.0\\Microsoft.Silverlight.CSharp.targets" />
</Project>
		CONTENTS
		)
    assert_equal([
			Gestalt::Base.new(:platform, 'silverlight'),
			Gestalt::Base.new(:tool, 'VisualStudio')
		], sf.gestalts.sort)
  end
end
