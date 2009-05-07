module Ohcount
end

require 'rbconfig'

OHCOUNT_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..'))
$: << OHCOUNT_ROOT
$: << File.join(OHCOUNT_ROOT, 'vendor', 'gems', 'diff-lcs-1.1.2', 'lib')

begin
	require 'ohcount_native'
rescue LoadError
	require "lib/#{Config::CONFIG['arch']}/ohcount_native"
end

require 'lib/ohcount/language'
require 'lib/ohcount/loc'
require 'lib/ohcount/loc_list'
require 'lib/ohcount/loc_delta'
require 'lib/ohcount/loc_delta_list'

require "lib/ohcount/scratch_dir"
require "lib/ohcount/helpers"
require "lib/ohcount/detector"
require "lib/ohcount/language_breakdown"
require "lib/ohcount/source_file"
require "lib/ohcount/source_file_list"
require "lib/ohcount/gestalt_facts"

require "lib/licenses/license_sniffer"

# gestalt
require "lib/gestalt/trigger"
require "lib/gestalt/definition"
require "lib/gestalt/base"
require "lib/gestalt/definitions"
require "lib/gestalt/gestalt_engine"
