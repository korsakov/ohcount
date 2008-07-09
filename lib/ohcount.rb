module Ohcount
end

require 'rbconfig'

OHCOUNT_ROOT = File.dirname(__FILE__) + "/.."

begin
	require 'ohcount_native'
rescue LoadError
	require OHCOUNT_ROOT + "/lib/#{Config::CONFIG['arch']}/ohcount_native"
end

require OHCOUNT_ROOT + "/lib/ohcount/detector"
require OHCOUNT_ROOT + "/lib/ohcount/parser"
require OHCOUNT_ROOT + "/lib/ohcount/language_breakdown"
require OHCOUNT_ROOT + "/lib/ohcount/sloc_info"
require OHCOUNT_ROOT + "/lib/ohcount/scratch_dir"
require OHCOUNT_ROOT + "/lib/ohcount/diff"
require OHCOUNT_ROOT + "/lib/ohcount/simple_file_context"

require OHCOUNT_ROOT + "/lib/licenses/license_sniffer"
