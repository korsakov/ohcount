module Ohcount
  module Gestalt

    class Base
      attr_reader :type, :name, :count

      def initialize(type, name, count = 1)
        @type = type
        @name = name
        @count = count
      end

      def ==(other)
        other.type.to_s == self.type.to_s &&
          other.name == self.name &&
          other.count == self.count
      end

      def <=>(other)
        me = self.type.to_s + self.name.to_s + self.count.to_s
        you = other.type.to_s + other.name.to_s + other.count.to_s
        me <=> you
      end

      # will return an array of detected gestalts from a source_file_list
      def self.find_gestalts(source_file_list)
        GestaltEngine.new.process(source_file_list).gestalts
      end

    end
  end
end
