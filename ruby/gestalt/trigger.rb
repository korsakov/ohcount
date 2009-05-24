module Ohcount
  module Gestalt
    class Trigger
      attr_reader :name, :count

      def initialize(args = {})
        @name = args[:name]
        @count = args[:count] || 1
      end

    end
  end
end
