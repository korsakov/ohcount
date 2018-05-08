crystal	comment	#comment
crystal	comment	  # comment with "string"
crystal	blank	
crystal	code	class Rest
crystal	code	  def one
crystal	code	    two do |c|
crystal	code	      puts c
crystal	code	    end
crystal	code	  end
crystal	blank	
crystal	code	  def two(&block : Int32 -> _)
crystal	code	    three { |x| yield x }       # yield is faster than passing blocks.
crystal	code	  end
crystal	blank	
crystal	code	  def three
crystal	code	    yield 3
crystal	code	  end
crystal	code	end
crystal	blank	
crystal	code	Rest.new.one
