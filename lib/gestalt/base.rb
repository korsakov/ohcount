require "lib/gestalt/library"
require "lib/gestalt/platform"

module Ohcount
	module Gestalt
		class Base
			attr_reader :lib_counts
			attr_reader :language_counts
			attr_reader :platforms
			attr_reader :filenames

			def initialize(args = {})
				if args[:dir]
					@filenames = Dir.glob(File.join(args[:dir] + "/","**", "*"))
				end
				@filenames ||= args[:files]
				@lib_counts = {}
				@platforms = []
				@language_counts = {}
			end

			def process!
				# process files
				filenames.each do |filename|
					s = SourceFile.new(filename)
					Library.detect_libraries(s).collect { |library| library.to_sym }.each do |l|
						@lib_counts[l] ||= 0
						@lib_counts[l] += 1
					end
					s.language_breakdowns.each do |lb|
						@language_counts[lb.name.intern] = lb.code_count
					end
				end

				# since platforms can depend on other platforms,
				# we perform an iterative process and break when
				# no new platforms have been detected.
				while true do
					prev_platforms = self.platforms.clone
					uninfered_platforms.each do |p|
						platforms << p if p.triggered?(self)
					end
					break if prev_platforms == self.platforms
				end
			end

			def uninfered_platforms
				Platform.descendants - @platforms	
			end

			def includes_language?(language, min_percent = 0)
				return false unless language_counts[language]
				language_percents[language] >= min_percent
			end

			def language_percents
				@language_percents ||= begin
					total = language_counts.values.inject(0) { |s,c| s+c }
					l = {}
					language_counts.each do |k,v|
						l[k] = 100.0 * v.to_i / total
					end
					l
			 end
			end

		end
	end
end

