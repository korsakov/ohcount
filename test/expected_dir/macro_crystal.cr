crystal	comment	# This is a comment.
crystal	blank	
crystal	code	macro create_foo(name, &block)
crystal	code	  {% name.id = "bar" %}
crystal	code	  {{block}}
