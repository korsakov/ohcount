require File.dirname(__FILE__) + "/license"
require File.dirname(__FILE__) + "/license_map"

#
# License Sniffer is a tool that searches for any mention of known licenses in files.
# It's pretty dumb in that it only looks for a mention of the license - it doesn't
# distinguish between code or comment, and it will trigger on any mention, including:
#
#		...i find the GNU Public License really dumb...
#
# Otherwise, it strives to be complete...add any new licenses to the license map.
module LicenseSniffer

	def self.sniff(s)
		ranges = []
		# Check each license for a match. With each matching license, store its first and last character index.
		LicenseMap.instance.licenses.each do |l|
			m0 = ( s =~ l.re) # m0 = match start character
			m1 = m0 + $&.length if m0 # m1, first character after end of match

			# exclude terms that may not be exist in the license, useful distinguishing between BSD licenses
			if m0
				match = s[m0...m1]
				m0 = nil if l.exclude && match =~ l.exclude
			end

			if m0
				ranges << [l.symbol, m0, m1]
			end
		end
		# Remove any match whose range is contained completely within another license's range.
		# This prevents matching the same string to two different licenses, such as "Lesser GPL" and "GPL".
		ranges.each do |r1|
			ranges.each do |r2|
				# This comparison is a little complex because we want to catch the two edge cases in which
				# the first letter or the last letter are shared, but we don't want to catch the case
				# in which both the first AND last letter are shared, which would mean they are exactly the same range.
				if (r1[1] < r2[1] and r1[2] >= r2[2]) or (r1[1] <= r2[1] and r1[2] > r2[2])
					# r2 lies completely completely within r1, so ignore it
					r2[0] = nil # mark as nil instead of deleting to avoid breaking the iterators
				end
			end
		end
		LicenseMap.instance.license_overrides.each_pair do |base, specific|
			found_licenses = ranges.collect {|r| r.first}
			if !(found_licenses & specific).empty?
				ranges.delete_if { |r| r.first == base}
			end
		end
		ranges.collect { |r| r[0] }.compact.uniq
	end

	def self.sniff_file(filename)
		File.open(filename) do |io|
			return sniff(io.read)
		end
	end

  def self.licenses_from_source_code(file, files = [])
    sfc = Ohcount::SimpleFileContext.new(file, files)
    polyglot = Ohcount::Detector.detect(sfc)
    return [] unless polyglot
    comments = ''
    Ohcount::parse_entities(sfc.contents, polyglot) do |language, entity, s, e|
      if entity == :comment
        text = sfc.contents[s...e] # e is non-inclusive, so use ...
        text.split(/[\r\n\f]+/).each do |line|
					# Strip leading punctuation.
          comments << ' ' + $1 if line =~ /^[\s[:punct:]]*(.*?)$/
        end
      end
    end
    sniff(comments)
  end

end
