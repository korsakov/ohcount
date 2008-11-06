module Ohcount

	# Represents language statistics for a collection of files
	class GestaltFacts
		attr_accessor :platforms, :lib_counts, :language_counts

		def initialize
			@platforms = []
			@lib_counts = {}
			@language_counts = {}
		end

		def process(source_file)
			Library.detect_libraries(source_file).collect { |library| library.to_sym }.each do |l|
				@lib_counts[l] ||= 0
				@lib_counts[l] += 1
			end
			source_file.language_breakdowns.each do |lb|
				@language_counts[lb.name.intern] ||= 0
				@language_counts[lb.name.intern] += lb.code_count
			end
		end

		def post_process
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

		def uninfered_platforms #:nodoc:
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
