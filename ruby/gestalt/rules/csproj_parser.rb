#!/usr/bin/env ruby
require 'rexml/document'
require 'rexml/streamlistener'

class CsprojListener
	include REXML::StreamListener

	attr_accessor :callback
	def initialize(callback)
		@callback = callback
		@is_csproj_file = false
	end

	def tag_start(name, attrs)
		case name
		when 'Project'
			@is_csproj_file = true
			if attrs['xmlns'] and attrs['xmlns'] !~ /^http:\/\/schemas\.microsoft\.com\/developer\//
				# False alarm -- it contains a project element, but of another namespace
				@is_csproj_file = false
			end
		when 'Import'
			if @is_csproj_file && attrs['Project']
				@callback.call(attrs['Project'])
			end
		end
	end
end
