require File.dirname(__FILE__) + '/../test_helper'
include Ohcount

class LanguageBreakdownTest < Ohcount::Test

	def test_initialize
		lb = LanguageBreakdown.new('c')
		assert 'c', lb.name
	end

end

