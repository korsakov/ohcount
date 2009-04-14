require File.dirname(__FILE__) + '/../../test_helper'

include Ohcount
include Ohcount::Gestalt

class ToolTest < Test::Unit::TestCase

	def test_vs_1
		assert_tool('vs_1', VisualStudio)
	end

	def test_eclipse
		assert_tool('eclipse', EclipseIDE)
	end

	def test_netbeans
		assert_tool('netbeans', NetBeansIDE)
	end

	protected
	def assert_tool(path, *tools)
		sfl = SourceFileList.new(:path => test_dir(path))
		sfl.analyze(:gestalt)
		assert_equal tools, sfl.gestalt_facts.tools
	end

	def test_dir(d)
		File.expand_path(File.dirname(__FILE__) + "/../../gestalt_files/#{ d }")
	end

end

