require File.dirname(__FILE__) + '/../../test_helper'
include Ohcount
include Ohcount::Gestalt

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
end
