module Ohcount
	module Gestalt

		define_platform 'jaspersoft' do
			_or do
				gestalt(:platform, 'jaspersoft_keyword')
				gestalt(:platform, 'jasper_reports')
				gestalt(:platform, 'jasper_server')
				gestalt(:platform, 'jasper_ireport')
				gestalt(:platform, 'jasper_intelligence')
			end
		end

		define_platform 'jaspersoft_keyword' do
			keywords /jaspersoft/i
		end

		define_platform 'jasper_reports' do
			_or do
				gestalt(:platform, 'jasper_reports_keyword')
				gestalt(:platform, 'jasper_reports_java')
			end
		end

		define_platform 'jasper_reports_keyword' do
			keywords /jasper[ _-]?reports?/i
		end

    define_platform 'jasper_reports_java' do
			_or do
				maven_dependency /jasperreports/
				java_keywords '\bnet\.sf\.jasperreports\b'
			end
    end

		define_platform 'jasper_server' do
			_or do
				gestalt(:platform, 'jasper_server_keyword')
				gestalt(:platform, 'jasper_server_java')
			end
		end

		define_platform 'jasper_server_keyword' do
			keywords /jasper[ _-]?server/i
		end

    define_platform 'jasper_server_java' do
      java_keywords '\bcom\.jaspersoft\.jasperserver\b'
    end

    define_platform 'jasper_intelligence' do
      java_keywords '\bcom\.jaspersoft\.ji'
    end

		define_platform 'jasper_ireport' do
			_and do
				keywords /jasper/i
				keywords /ireport/i
			end
		end
	end
end
