require 'lib/gestalt/rules/rule'
require 'lib/gestalt/rules/logical_rule'
require 'lib/gestalt/rules/or_rule'
require 'lib/gestalt/rules/and_rule'
require 'lib/gestalt/rules/language_rule'
require 'lib/gestalt/rules/file_rule'
require 'lib/gestalt/rules/filename_rule'
require 'lib/gestalt/rules/find_filenames_rule'
require 'lib/gestalt/rules/c_header_rule'
require 'lib/gestalt/rules/keyword_rule'
require 'lib/gestalt/rules/c_keyword_rule'
require 'lib/gestalt/rules/gestalt_rule'
require 'lib/gestalt/rules/java_import_rule'
require 'lib/gestalt/rules/find_java_imports_rule'

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
