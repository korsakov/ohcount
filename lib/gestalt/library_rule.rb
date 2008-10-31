module Ohcount
	module Gestalt

		class LibraryRule
			def ==(other)
				return false unless self.class == other.class
				return false unless self.instance_variables == other.instance_variables
				self.instance_variables.each do |v|
					return false unless self.send(v[1..-1]) == other.send(v[1..-1])
				end
				true
			end
		end

		class CHeaderRule < LibraryRule
			attr_reader :headers

			def initialize(*headers)
				@headers = headers
			end

			def trigger?(source_file)
				return false unless ['c','cpp'].include?(source_file.polyglot)
				regexp.match(source_file.c.code) || regexp.match(source_file.cpp.code)
			end

			def regexp
				@regexp ||= begin
					header_term = "(" + headers.join("|") + ")"
					Regexp.new("include\s+['<\"]#{ header_term }[\">']", Regexp::IGNORECASE)
				end
			end
		end

		class FileRule < LibraryRule
			attr_reader :filenames

			def initialize(filenames)
				@filenames = filenames
			end

			def trigger?(source_file)
				filenames.include?(source_file.basename)
			end
		end

		class CKeywordRule < LibraryRule
			attr_reader :keywords

			def initialize(*keywords)
				@keywords = keywords
			end

			def trigger?(source_file)
				return false unless ['c','cpp'].include?(source_file.polyglot)
				regexp.match(source_file.c.code) || regexp.match(source_file.cpp.code)
			end

			def regexp
				@regexp ||= begin
					Regexp.new("(" + keywords.join("|") + ")")
				end
			end
		end
	end
end
