=begin
  construct_embedded written by Mitchell Foral. mitchell<att>caladbolg<dott>net.
=end

def has_embedded?(parser_file)
  return IO.read(parser_file).include?('#EMBED')
end

def construct_language(parser_file)
  parser_text = IO.read(parser_file).gsub(/#EMBED\([\w_]+\)/) do |elang|
    lang = elang.scan(/^#EMBED\(([\w_]+)\)/)[0][0]
    eparser_file = lang + '.rl'
    if File.exists?(eparser_file)
      eparser = IO.read(eparser_file)
      ragel = eparser.scan(/%%\{(.+?)\}%%/m)[0][0]
      # eliminate machine definition, writes, and includes
      ragel.gsub!(/^\s*machine[^;]+;\s+write[^;]+;\s+include[^;]+;\s+/, '')
      "}%%\n%%{\n#{ragel}"
    else
      ''
    end
  end
  f = File.new(parser_file + '.tmp', 'w')
  f.write(parser_text)
  f.close
end
