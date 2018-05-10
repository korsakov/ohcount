#comment
  # comment with "string"

class Rest
  def one
    two do |c|
      puts c
    end
  end

  def two(&block : Int32 -> _)
    three { |x| yield x }       # yield is faster than passing blocks.
  end

  def three
    yield 3
  end
end

Rest.new.one
