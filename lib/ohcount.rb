module Ohcount
end

require 'rbconfig'

OHCOUNT_ROOT = File.dirname(__FILE__) + "/.."
$: << OHCOUNT_ROOT

begin
	require 'ohcount_native'
rescue LoadError
	require "lib/#{Config::CONFIG['arch']}/ohcount_native"
end

require "lib/ohcount/helpers"
require "lib/ohcount/detector"
require "lib/ohcount/language_breakdown"
require "lib/ohcount/sloc_info"
require "lib/ohcount/scratch_dir"
require "lib/ohcount/source_file"
require "lib/ohcount/language_facts"
require "lib/ohcount/gestalt_facts"
require "lib/ohcount/source_file_list"

require "lib/licenses/license_sniffer"
require "lib/gestalt/platform"
require "lib/gestalt/tool"

# require the dynamic rules
require 'rules/platforms'
require 'rules/tools'

