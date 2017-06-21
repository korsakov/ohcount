grace	comment	//////////////////////////////////////////////////
grace	comment	// Sample Grace code
grace	blank	
grace	code	import "parsers-test" as parsers
grace	blank	
grace	code	class exports {
grace	code	  inherit parsers.exports
grace	comment	  //BEGINGRAMMAR
grace	comment	  // top level
grace	code	  def program = rule {codeSequence ~ rep(ws) ~ end}
grace	code	  def codeSequence = rule { repdel((declaration | statement | empty), semicolon) }
grace	code	  def hashLine = rule { (symbol "#") ~ rep(anyChar | space) ~ (newLine | end) }
grace	blank	
grace	comment	  // def comment =
grace	blank	
grace	comment	  //def oldClassDeclaration = rule { classId ~ identifier ~ lBrace ~
grace	comment	  //                             opt(genericFormals ~ blockFormals ~ arrow) ~ codeSequence ~ rBrace }
grace	blank	
grace	code	  def typeOpExpression = rule { rep1sep(basicTypeExpression, typeOp) }
grace	blank	
grace	code	  def typeOpExpression = rule {
grace	code	    var otherOperator
grace	code	    basicTypeExpression ~ opt(ws) ~
grace	code	      opt( guard(typeOp, { s -> otherOperator:= s;
grace	code	                                true }) ~ rep1sep(basicTypeExpression ~ opt(ws),
grace	code	               guard(typeOp, { s -> s == otherOperator })
grace	code	          )
grace	code	      )
grace	code	    }
grace	blank	
grace	comment	  // "literals"
grace	code	  def literal = rule { stringLiteral | selfLiteral | blockLiteral | numberLiteral | objectLiteral | lineupLiteral | typeLiteral }
grace	blank	
grace	comment	  // terminals
grace	code	  def backslash = token "\\"    // doesn't belong here, doesn't work if left below!
grace	blank	
grace	code	  def colon = rule {both(symbol ":", not(assign))}
grace	code	  def newLine = symbol "\n"
grace	code	  def lParen = symbol "("
grace	code	  def rParen = symbol ")"
grace	blank	
grace	code	  def reservedOp = rule {assign | equals | dot | arrow | colon | semicolon}  // this is not quite right
grace	blank	
grace	comment	  //ENDGRAMMAR
grace	code	}
grace	blank	
