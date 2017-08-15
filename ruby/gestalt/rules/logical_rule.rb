module Ohcount
	module Gestalt
		class LogicalRule < Rule
			attr_reader :rules

			def initialize(*rules, &block)
				@rules = rules
        self.instance_eval(&block) if block
			end

      def each_rule(&block)
        @rules.each { |r| r.each_rule(&block) }
        yield self
      end

      def clone
        cloned_rules = @rules.map { |r|
          r.clone
        }
        self.class.new(*cloned_rules)
      end

			def new_rule(r_class, *args, &block)
				@rules << r_class.new(*args,&block)
			end

			def _or(*args, &block)
				new_rule OrRule, *args, &block
			end

			def _and(*args, &block)
				new_rule AndRule, *args, &block
			end

			def _not(*args, &block)
				new_rule NotRule, *args, &block
			end

			def gestalt(*args)
				new_rule GestaltRule, *args
			end

			def language(*args)
				new_rule LanguageRule, *args
			end

			def csproj_import(*args)
				new_rule CsprojRule, *args
			end

			def maven_dependency(*args)
				new_rule MavenRule, *(['dependency'] + args)
			end

			def maven_plugin(*args)
				new_rule MavenRule, *(['plugin'] + args)
			end

			# file rules
			def c_headers(*args)
				new_rule CHeaderRule, *args
			end

			def filenames(*args)
				new_rule FilenameRule, *args
			end

			def keywords(*args)
				new_rule KeywordRule, *([nil] << args)
			end

			def c_keywords(*args)
				new_rule CKeywordRule, *args
			end

			def java_import(*args)
				new_rule JavaImportRule, *args
			end

			def csharp_using(*args)
				new_rule CSharpUsingRule, *args
			end

      def find_filenames(*args)
        new_rule FindFilenamesRule, *args
      end

			def method_missing(m,*args, &block)
				if m.to_s =~ /^(.*)_keywords$/
					language = $1
					new_args = [language] + args
					new_rule(KeywordRule, *new_args, &block)
				  return
        end
				super
			end

		end
	end
end
