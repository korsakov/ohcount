require 'test/unit'
require File.dirname(__FILE__) + '/../test_helper.rb'

include Ohcount
include Ohcount::Gestalt

class DefinitionsTest < Ohcount::Test

  def test_jasper_reports_java
		java = SourceFile.new("foo.java", :contents => <<-INLINE_JAVA
      public class Employee implements Serializable {
        private net.sf.jasperreports.report myReport;
      }
		INLINE_JAVA
    )
		assert platform_names(java.gestalts).include?('jaspersoft')
		assert platform_names(java.gestalts).include?('jasper_reports')
		assert platform_names(java.gestalts).include?('jasper_reports_java')
  end

  def test_jasper_reports_via_maven
		java = SourceFile.new("pom.xml", :contents => <<-INLINE_POM
        <project>
          <groupId>dzrealms</groupId>
          <artifactId>HelloWorld</artifactId>
          <version>1.0</version>
          <dependencies>
            <dependency>
              <groupId>jasperreports</groupId>
              <artifactId>jasperreports</artifactId>
              <version>2.0.5</version>
            </dependency>
          </dependencies>
        </project>
    INLINE_POM
    )
		assert platform_names(java.gestalts).include?('jaspersoft')
		assert platform_names(java.gestalts).include?('jasper_reports')
		assert platform_names(java.gestalts).include?('jasper_reports_java')
  end

  def test_jasper_server_java
		java = SourceFile.new("foo.java", :contents => <<-INLINE_JAVA
      public class Employee implements Serializable {
        private com.jaspersoft.jasperserver;
      }
		INLINE_JAVA
    )
		assert platform_names(java.gestalts).include?('jaspersoft')
		assert platform_names(java.gestalts).include?('jasper_server')
		assert platform_names(java.gestalts).include?('jasper_server_java')
  end

  def test_jasper_intelligence
		java = SourceFile.new("foo.java", :contents => <<-INLINE_JAVA
      public class Employee implements Serializable {
        private com.jaspersoft.ji;
      }
		INLINE_JAVA
    )
		assert platform_names(java.gestalts).include?('jaspersoft')
		assert platform_names(java.gestalts).include?('jasper_intelligence')
  end

	def test_jasper_server
		expected = ['scripting', 'ruby', 'jaspersoft', 'jasper_server', 'jasper_server_keyword']

		rb = SourceFile.new('jasper.rb', :contents => 'def jasper_server; nil ; end')
		assert_platforms(expected, rb.gestalts)

		rb = SourceFile.new('jasper.rb', :contents => 'def jasperserver; nil ; end')
		assert_platforms(expected, rb.gestalts)

		rb = SourceFile.new('jasper.rb', :contents => 'js = JasperServer.new()')
		assert_platforms(expected, rb.gestalts)

		rb = SourceFile.new('jasper.rb', :contents => 'jasper-server')
		assert_platforms(expected, rb.gestalts)
	end

	def test_jasper_reports
		expected = ['scripting', 'ruby', 'jaspersoft', 'jasper_reports', 'jasper_reports_keyword']

		rb = SourceFile.new('jasper.rb', :contents => 'def jasper_reports; nil ; end')
		assert_platforms(expected, rb.gestalts)

		rb = SourceFile.new('jasper.rb', :contents => 'def jasperreports; nil ; end')
		assert_platforms(expected, rb.gestalts)

		rb = SourceFile.new('jasper.rb', :contents => 'def JasperReport; nil ; end')
		assert_platforms(expected, rb.gestalts)

		rb = SourceFile.new('jasper.rb', :contents => 'jasper-report')
		assert_platforms(expected, rb.gestalts)
	end

	def test_jasper_ireport
		rb = SourceFile.new('jasper.rb', :contents => 'ireport = nil')
		assert !platform_names(rb.gestalts).include?('jasper_ireport')

		rb = SourceFile.new('jasper.rb', :contents => 'jasper = nil')
		assert !platform_names(rb.gestalts).include?('jasper_ireport')

		rb = SourceFile.new('jasper.rb', :contents => 'jasper_ireport = nil')
		assert platform_names(rb.gestalts).include?('jasper_ireport')
	end

	protected

	def assert_platforms(expected_names, actual)
		assert_equal(expected_names.sort, platform_names(actual).sort)
	end

	def platform_names(gestalts)
		gestalts.map { |g| g.type == :platform && g.name }.compact
	end
end
