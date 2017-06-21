// Sample Grace code

import "parsers-test" as parsers

class exports {
  def program = rule {codeSequence ~ rep(ws) ~ end}
}
