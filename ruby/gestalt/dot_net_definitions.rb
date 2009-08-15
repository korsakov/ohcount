module Ohcount
	module Gestalt

    define_platform 'Dot_NET' do
      language :csharp, :min_percent => 10
    end

    define_platform 'ASP_NET' do
      filenames('\.(aspx|ascx|ashx|asax|axd)$')
    end

		define_platform 'NUnit' do
			_and do
				gestalt(:platform, 'Dot_NET')
				csharp_using /^NUnit\b/
			end
		end

		define_platform 'NHibernate' do
			_and do
				gestalt(:platform, 'Dot_NET')
				csharp_using /^NHibernate\b/
			end
		end

		# BizTalk
		define_platform 'Dot_NET_BizTalk' do
			_and do
				gestalt(:platform, 'Dot_NET')
				_or do
					csharp_using /^Microsoft\.Solutions\b/
					csharp_using /^Microsoft\.BizTalk\b/
				end
			end
		end

		# Connected Services Framework
		define_platform 'Dot_NET_Csf' do
			_and do
				gestalt(:platform, 'Dot_NET')
				csharp_using /^Microsoft\.Csf\b/
			end
		end

		# Microsoft Content Management Server
		define_platform 'Dot_NET_CMS' do
			_and do
				gestalt(:platform, 'Dot_NET')
				csharp_using /^Microsoft\.ContentManagement\b/
			end
		end

		# Exchange
		define_platform 'Dot_NET_Exchange' do
			_and do
				gestalt(:platform, 'Dot_NET')
				csharp_using /^Microsoft\.Exchange\b/
			end
		end

		# Microsoft Operations Manager (Mom)
		define_platform 'Dot_NET_Mom' do
			_and do
				gestalt(:platform, 'Dot_NET')
				csharp_using /^Microsoft\.EnterpriseManagement\.Mom\b/
			end
		end

		# A general category of software.
		# Not a particular technology, but it "smells" like middle-tier/enterprise software.
		define_platform 'Dot_NET_Enterprise' do
			_and do
				gestalt(:platform, 'Dot_NET')
				_or do
					gestalt(:platform, 'Dot_NET_BizTalk')
					gestalt(:platform, 'Dot_NET_Exchange')
					gestalt(:platform, 'Dot_NET_Cms')
					gestalt(:platform, 'Dot_NET_Csf')
					gestalt(:platform, 'Dot_NET_Mom')
					csharp_using /^System\.Runtime\.Remoting\b/
					csharp_using /^System\.DirectoryServices\b/
					csharp_using /^System\.ServiceModel\b/
					csharp_using /^System\.(Data\.)?Linq\b/
					csharp_using /^System\.Data\b/
				end
			end
		end

    define_platform 'WPF' do
      filenames '\.xaml$'
    end

		define_platform 'silverlight' do
			_or do
				csharp_using /^System.Web.Silverlight\b/
				html_keywords '\basp:Silverlight\b'
				csproj_import /\bSilverlight\b/
				_and do
					# A combination of ASP.NET with xaml is assumed to mean Silverlight
					gestalt(:platform, 'ASP_NET')
					gestalt(:platform, 'WPF')
				end
			end
		end

	end
end
