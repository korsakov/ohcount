include Ohcount
include Ohcount::Gestalt
require File.dirname(__FILE__) + '/../../../../ruby/gestalt'

class JavaDefinitionsTest < Ohcount::Test

	def test_weblogic_via_maven
		assert_gestalts 'weblogic_maven', [
			Base.new(:platform, 'AppServer'),
			Base.new(:platform, 'Java'),
			Base.new(:platform, 'Maven'),
			Base.new(:platform, 'WebLogic')
		]
  end

	def test_weblogic_via_descriptor
		assert_gestalts 'weblogic_descriptor', [
			Base.new(:platform, 'AppServer'),
			Base.new(:platform, 'Java'),
			Base.new(:platform, 'WebLogic')
		]
  end

	def test_webshpere_via_descriptor
		assert_gestalts 'websphere', [
			Base.new(:platform, 'AppServer'),
			Base.new(:platform, 'Java'),
			Base.new(:platform, 'WebSphere')
		]
  end

	def test_ejb30_by_default
		sf = SourceFile.new('hello.java', :contents => <<-JAVA
				@Stateless
				public class HelloBean { }
			JAVA
		)
		assert_equal [
			Base.new(:platform, 'Java'),
			Base.new(:platform, 'EJB3+'),
			Base.new(:platform, 'EJB3.0')
		].sort, sf.gestalts.sort
	end


	def test_ejb31_through_annotation
		sf = SourceFile.new('hello.java', :contents => <<-JAVA
				@Stateless
				public class HelloBean {
					@Asynchronous public Future<int> getHelloValue() {}
				}
			JAVA
		)
		assert_equal [
			Base.new(:platform, 'Java'),
			Base.new(:platform, 'EJB3+'),
			Base.new(:platform, 'EJB3.1')
		].sort, sf.gestalts.sort
	end

	def test_ejb31_through_global_jndi
		sf = SourceFile.new('hello.java', :contents => <<-JAVA
			public class PlaceBidClient {
				context.lookup("java:global/action-bazaar/PlaceBid");
			}
			JAVA
		)
		assert_equal [
			Base.new(:platform, 'Java'),
			Base.new(:platform, 'EJB3+'),
			Base.new(:platform, 'EJB3.1')
		].sort, sf.gestalts.sort
	end

end
