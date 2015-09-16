coffeescript	comment	# A CoffeeScript parser test file
coffeescript	blank	
coffeescript	code	simple_code = true
coffeescript	blank	
coffeescript	comment	###
coffeescript	comment	A multi-line block comment
coffeescript	comment	begins and ends with three hash marks
coffeescript	comment	###
coffeescript	blank	
coffeescript	code	multi_line_string = '''
coffeescript	code	                    A multi-line string constant ("here doc")
coffeescript	code	                    begins and ends with three quote marks
coffeescript	code	                    '''
coffeescript	blank	
coffeescript	code	foo = "A string can wrap across multiple lines
coffeescript	code	  and may contain #{interpolated_values}"
coffeescript	blank	
coffeescript	blank	
coffeescript	comment	###
coffeescript	comment	A clever parser can use Ohcount's "Polyglot" feature treat the
coffeescript	comment	following as embedded JavaScript.
coffeescript	comment	###
javascript	code	embedded_js = `function() {
javascript	code	  return [document.title, "Hello JavaScript"].join(": ");
coffeescript	code	}`
coffeescript	blank	
