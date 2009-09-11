module Ohcount
	module Gestalt

    define_platform 'dot_net' do
      language :csharp, :min_percent => 10
    end

    define_platform 'asp_net' do
      filenames('\.(aspx|ascx|ashx|asax|axd)$')
    end

		define_platform 'nunit' do
			_and do
				gestalt(:platform, 'dot_net')
				csharp_using /^NUnit\b/
			end
		end

		define_platform 'nhibernate' do
			_and do
				gestalt(:platform, 'dot_net')
				csharp_using /^NHibernate\b/
			end
		end

		# BizTalk
		define_platform 'dot_net_biztalk' do
			_and do
				gestalt(:platform, 'dot_net')
				_or do
					csharp_using /^Microsoft\.Solutions\b/
					csharp_using /^Microsoft\.BizTalk\b/
				end
			end
		end

		# Connected Services Framework
		define_platform 'dot_net_csf' do
			_and do
				gestalt(:platform, 'dot_net')
				csharp_using /^Microsoft\.Csf\b/
			end
		end

		# Microsoft Content Management Server
		define_platform 'dot_net_cms' do
			_and do
				gestalt(:platform, 'dot_net')
				csharp_using /^Microsoft\.ContentManagement\b/
			end
		end

		# Exchange
		define_platform 'dot_net_exchange' do
			_and do
				gestalt(:platform, 'dot_net')
				csharp_using /^Microsoft\.Exchange\b/
			end
		end

		# Microsoft Operations Manager (Mom)
		define_platform 'dot_net_mom' do
			_and do
				gestalt(:platform, 'dot_net')
				csharp_using /^Microsoft\.EnterpriseManagement\.Mom\b/
			end
		end

		# A general category of software.
		# Not a particular technology, but it "smells" like middle-tier/enterprise software.
		define_platform 'dot_net_enterprise' do
			_and do
				gestalt(:platform, 'dot_net')
				_or do
					gestalt(:platform, 'dot_net_biztalk')
					gestalt(:platform, 'dot_net_exchange')
					gestalt(:platform, 'dot_net_cms')
					gestalt(:platform, 'dot_net_csf')
					gestalt(:platform, 'dot_net_mom')
					csharp_using /^System\.Runtime\.Remoting\b/
					csharp_using /^System\.DirectoryServices\b/
					csharp_using /^System\.ServiceModel\b/
					csharp_using /^System\.(Data\.)?Linq\b/
					csharp_using /^System\.Data\b/
				end
			end
		end

    define_platform 'wpf' do
      filenames '\.xaml$'
    end

		define_platform 'silverlight' do
			_or do
				csharp_using /^System.Web.Silverlight\b/
				html_keywords '\basp:Silverlight\b'
				csproj_import /\bSilverlight\b/
				_and do
					# A combination of ASP.NET with xaml is assumed to mean Silverlight
					gestalt(:platform, 'asp_net')
					gestalt(:platform, 'wpf')
				end
			end
		end

	end
end
