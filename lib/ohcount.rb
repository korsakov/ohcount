module Ohcount
end

require 'rbconfig'

begin
	require 'ohcount_native'
rescue LoadError
	require "#{Config::CONFIG['arch']}/ohcount_native"
end

require "ohcount/detector"
require "ohcount/parser"
require "ohcount/language_breakdown"
require "ohcount/sloc_info"
require "ohcount/scratch_dir"
require "ohcount/diff"
require "ohcount/simple_file_context"
