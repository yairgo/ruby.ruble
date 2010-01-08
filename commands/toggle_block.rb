require 'radrails'
require 'toggle_block'

command "Toggle 'do ... end' / '{ ... }'" do |cmd|
  cmd.trigger = 'CONTROL+{'
  cmd.scope = 'source.ruby'
  cmd.output = :insert_as_snippet
  cmd.input = :selection, :document
  cmd.invoke do |context|
    require 'escape'
    code = context.in.read
    # regex = /\{(?m:.*?\x{FFFC}.*?)\}|do\b(?m:.*?\x{FFFC}.*?)\bend\b/ # The wide hex character match isn't working
    regex = /\{(?m:.*?)\}|do\b(?m:.*?)\bend\b/
    code.gsub(regex) {|match| e_sn(toggle_block(match)).gsub(CURSOR, "$0") }
  end
end
