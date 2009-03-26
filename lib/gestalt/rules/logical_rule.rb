module Ohcount
	module Gestalt
		class LogicalRule < Rule
			attr_reader :rules

			def initialize(*rules)
				@rules = rules
			end

			def new_rule(r_class, *args)
				# since we might be nesting logical rules, we must remove
				# any 'grandchildren rules' from our list, since we are giving
				args.each do |a|
					next unless a.is_a?(Rule)
					@rules.delete(a)
				end
				r = r_class.new(*args)
				@rules << r
				r
			end

			def _or(*args)
				new_rule OrRule, *args
			end

			def _and(*args)
				new_rule AndRule, *args
			end

			def platform(*args)
				new_rule PlatformRule, *args
			end

			def language(*args)
				new_rule LanguageRule, *args
			end

			# file rules
			def c_headers(*args)
				new_rule CHeaderRule, *args
			end

			def filenames(*args)
				new_rule FilenameRule, *args
			end

			def c_keywords(*args)
				new_rule CKeywordRule, *args
			end

			def java_import(*args)
				new_rule JavaImportRule, *args
			end

			def java_package(*args)
				new_rule JavaPackageRule, *args
			end

			def method_missing(m,*args)
				if /(.*)_keywords$/ =~ m.to_s
					language = $1
					new_args = [language] + args
					return new_rule(KeywordRule, *new_args)
				end
				super
			end

		end
	end
end
