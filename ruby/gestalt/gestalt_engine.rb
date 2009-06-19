module Ohcount
  module Gestalt

    # smells is a general class that aggregates facts required to deduce
    # gestalts
    class GestaltEngine
      attr_reader :gestalts

      def initialize
        @language_facts = LanguageFacts.new
        @gestalts = []
        @source_file_rules = []
        @definitions = Definition.all_definitions.map do |d|
          new_definition = d.clone
          new_definition.top_level_or.each_rule do |r|
            @source_file_rules << r if r.is_a?(FileRule)
          end
          new_definition
        end
      end

      def process_source_file(source_file)
        @source_file_rules.each do |r|
          r.process_source_file(source_file)
        end
        @language_facts.process_source_file(source_file)
      end

      def process_source_files(source_file_list)
        source_file_list.each_source_file do |source_file|
          process_source_file source_file
        end
        self
      end

      def process(what)
        if what.is_a?(SourceFile)
          process_source_file(what)
        elsif what.is_a?(SourceFileList)
          process_source_file_list(what)
        else
          raise ArgumentError.new
        end
      end

      def calc_gestalts(definitions = nil)
        # since gestalts can depend on other gestalts, we perform an
        # iterative process and break when no new gestalts have been
        # detected.
        gestalt_count = 0

        while true do
          
          # collect what we can
          yank_definitions = []
          @definitions.each do |d|

            new_gestalts = d.gestalts(self)
            if new_gestalts.any?
              yank_definitions << d
              @gestalts += new_gestalts
            end
          end
          @definitions -= yank_definitions

          # did we make any progress?
          break if gestalt_count == @gestalts.size

          # nope, keep going
          gestalt_count = @gestalts.size
        end

        gestalts
      end

      def has_gestalt?(type,name)
        @gestalts.find do |g|
          g.type.to_s == type.to_s &&
            g.name == name
        end
      end

      def includes_language?(language, min_percent)
        @language_facts.includes_language?(language,min_percent)
      end
    end


    # keeps track of languages seen
    class LanguageFacts

      def initialize
        @language_counts ||= {}
      end

      def process_source_file(source_file)
        source_file.language_breakdowns.each do |lb|
          @language_counts[lb.name.intern] ||= 0
          @language_counts[lb.name.intern] += lb.code_count
        end
      end

      def includes_language?(language, min_percent = 0)
        return false unless @language_counts[language]
        language_percents[language] >= min_percent
      end

      # ignores markup languages (xml/html)
      def language_percents
        @language_percents ||= begin
          total = 0
          @language_counts.each_pair do |name,code_count|
						language = Ohcount.ohcount_hash_language_from_name(name.to_s)
						STDOUT.puts "Warning: Couldn't find #{name} in ohcount_hash_language_from_name" if language.nil?
						next if language.nil? || language.category == 1
            total += code_count
          end

          l = {}
          @language_counts.each do |k,v|
           l[k] = 100.0 * v.to_i / total
          end
          l

        end
      end
    end

  end
end

