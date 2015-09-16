module Ohcount
	module Gestalt

    define_platform 'dot_net' do
			_or do
      	language :csharp, :min_percent => 10
				gestalt :platform, 'asp_net'
				gestalt :platform, 'wpf'
				gestalt :platform, 'silverlight'
			end
    end

    define_platform 'asp_net' do
      filenames('\.(aspx|ascx|ashx|asax|axd)$')
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
