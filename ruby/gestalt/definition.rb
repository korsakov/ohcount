require 'gestalt/rules/rule'
require 'gestalt/rules/logical_rule'
require 'gestalt/rules/or_rule'
require 'gestalt/rules/and_rule'
require 'gestalt/rules/not_rule'
require 'gestalt/rules/language_rule'
require 'gestalt/rules/file_rule'
require 'gestalt/rules/filename_rule'
require 'gestalt/rules/find_filenames_rule'
require 'gestalt/rules/c_header_rule'
require 'gestalt/rules/keyword_rule'
require 'gestalt/rules/c_keyword_rule'
require 'gestalt/rules/gestalt_rule'
require 'gestalt/rules/java_import_rule'
require 'gestalt/rules/csharp_using_rule'
require 'gestalt/rules/maven_parser'
require 'gestalt/rules/maven_rule'
require 'gestalt/rules/csproj_parser'
require 'gestalt/rules/csproj_rule'

module Ohcount
  module Gestalt

    class Definition
      attr_reader :type, :fixed_name

      def initialize(type, fixed_name = nil, options = {}, &block)
        @type = type
        @fixed_name = fixed_name
        if options[:rule]
          @top_level_or = options[:rule]
        else
          @top_level_or = OrRule.new(&block)
        end
      end

      def gestalts(gestalt_engine)
        @top_level_or.triggers(gestalt_engine).map do |trigger|
          Gestalt::Base.new(type, trigger.name || self.fixed_name, trigger.count)
        end
      end

      def top_level_or
        @top_level_or ||= OrRule.new
      end

      def self.add_definition(definition)
        @definitions ||= []
        @definitions << definition
      end

      def self.all_definitions
        @definitions || []
      end

      def clone
        rule = top_level_or.clone
        Definition.new(type,fixed_name,:rule => rule)
      end
    end


    # DSL language to allow people to define gestalt definitions like this:\
    #
    # define_xxx 'Foobar' do
    #   filenames 'foobar'
    # end
    #
    def self.method_missing(method, *args, &block)
      if method.to_s =~ /define_(.*)$/
        Definition.add_definition(Definition.new($1.intern,*args,&block))
      else
        super
      end
    end
  end
end
