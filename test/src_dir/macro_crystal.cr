# This is a comment.

macro create_foo(name, &block)
  {% name.id = "bar" %}
  {{block}}
