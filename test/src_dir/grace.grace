//////////////////////////////////////////////////
// Sample Grace code

import "parsers-test" as parsers

class exports {
  inherit parsers.exports
  //BEGINGRAMMAR
  // top level
  def program = rule {codeSequence ~ rep(ws) ~ end}
  def codeSequence = rule { repdel((declaration | statement | empty), semicolon) }
  def hashLine = rule { (symbol "#") ~ rep(anyChar | space) ~ (newLine | end) }

  // def comment =

  //def oldClassDeclaration = rule { classId ~ identifier ~ lBrace ~
  //                             opt(genericFormals ~ blockFormals ~ arrow) ~ codeSequence ~ rBrace }

  def typeOpExpression = rule { rep1sep(basicTypeExpression, typeOp) }

  def typeOpExpression = rule {
    var otherOperator
    basicTypeExpression ~ opt(ws) ~
      opt( guard(typeOp, { s -> otherOperator:= s;
                                true }) ~ rep1sep(basicTypeExpression ~ opt(ws),
               guard(typeOp, { s -> s == otherOperator })
          )
      )
    }

  // "literals"
  def literal = rule { stringLiteral | selfLiteral | blockLiteral | numberLiteral | objectLiteral | lineupLiteral | typeLiteral }

  // terminals
  def backslash = token "\\"    // doesn't belong here, doesn't work if left below!

  def colon = rule {both(symbol ":", not(assign))}
  def newLine = symbol "\n"
  def lParen = symbol "("
  def rParen = symbol ")"

  def reservedOp = rule {assign | equals | dot | arrow | colon | semicolon}  // this is not quite right

  //ENDGRAMMAR
}

