#!/usr/bin/env ruby
require 'rexml/document'
require 'rexml/streamlistener'

class MavenListener
	include REXML::StreamListener

	attr_accessor :group_id, :artifact_id, :text

	attr_accessor :callback
	def initialize(callback)
		@callback = callback
		@is_pom_file = false
	end

	def tag_start(name, attrs)
		case name
		when 'project'
			@is_pom_file = true
			if attrs['xmlns'] and attrs['xmlns'] !~ /^http:\/\/maven\.apache\.org\/POM\//
				# False alarm -- it contains a project element, but of another namespace
				@is_pom_file = false
			end
		when 'plugin', 'dependency'
			@group_id = nil
			@artifact_id = nil
		end
	end

	def tag_end(name)
		case name
		when 'groupId'
			@group_id = clean(@text)
		when 'artifactId'
			@artifact_id = clean(@text)
		when /^(plugin|dependency)$/
			if @is_pom_file && @group_id && @artifact_id
				@callback.call($1, @group_id, @artifact_id)
			end
		end
	end

	# Remove whitespace from text values.
	# Also, clear out variable substitutions, which we are incapable of performing correctly
	def clean(s)
		s.strip.gsub(/\$\{.*\}/, '')
	end

	def text(text)
		@text = text
	end
end
