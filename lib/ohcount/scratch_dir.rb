require 'fileutils'
require 'tmpdir'

# A utility class to manage the creation and automatic cleanup of temporary directories.
class ScratchDir
	attr_reader :path

	# Creates a uniquely named directory in the system tmp directory.
	#
	# If a block is passed to the constructor, the path to the created directory
	# will be yielded to the block. The directory will then be deleted
	# when this block returns.
	#
	# Sample usage:
	#
	#   ScratchDir.new do |path|
	#     # Do some work in the new directory
	#     File.new( path + '/foobaz', 'w' ) do
	#       # ...
	#     end
	#   end # Scratch directory is deleted here
	#
	def initialize
		until @path
			@path = File.join(Dir.tmpdir, Time.now.utc.strftime("ohloh_%Y%H%m%S#{rand(900) + 100}"))
			begin
				Dir.mkdir(@path)
			rescue Errno::EEXIST
				@path = nil
			end
		end
		if block_given?
			yield @path
			FileUtils.rm_rf(@path)
		end
	end
end

if $0 == __FILE__
	path = nil
	ScratchDir.new do |d|
		path = d
		STDOUT.puts "Created scratch direcory #{d}"
		File.open(File.join(d, "test"), "w") do |io|
			io.write "test"
		end
	end
	raise RuntimeError.new("Directory wasn't cleaned up") if FileTest.directory?(path)
	STDOUT.puts "Test passed."
end
