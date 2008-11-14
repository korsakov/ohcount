module Ohcount
  module LicenseSniffer
    class SoftwareLicense
      attr_reader :symbol, :url, :nice_name, :re, :exclude

      def initialize(symbol, url, nice_name, re, exclude = nil)
        @symbol = symbol
        @url = url
        @nice_name = nice_name
        @re = re
        @exclude = exclude
      end
    end
  end
end
