require 'radrails'

command 'xmlread(..)' do |cmd|
  cmd.trigger = 'xml'
  cmd.scope = 'source.ruby'
  cmd.output = :insert_as_snippet
  cmd.input = :document
  cmd.invoke do |context|    
    require 'ruby_requires'
    require 'insert'
    
    snippet = 'REXML::Document.new(File.read("${1:path_to_file}"))'
    result = insert_at_cursor(context.in.read, snippet) { |code| RubyRequires.add_requires(code, 'rexml/document') }
  end
end