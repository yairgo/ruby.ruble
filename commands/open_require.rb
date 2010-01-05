require 'radrails'
require 'radrails/ui'
require 'radrails/editor'

command 'Open require' do |cmd|
  cmd.key_binding = :Shift, :M1, :D
  cmd.scope = 'source.ruby'
  cmd.output = :show_as_tooltip
  cmd.input = :selection, :document
  cmd.invoke do |context|    
    REQUIRE_RE = /^\s*(?:require|load)\s*([\'"])([^\'"#]+?)(?:\.rb)?\1[ \t]*$/
    
    gems_installed = begin
                       require 'rubygems'
                       true
                     rescue LoadError
                       false
                     end
    
    requires = if context['TM_CURRENT_LINE'].to_s =~ REQUIRE_RE
                 ["#{$2}.rb"]
               else
                 context.in.read.scan(REQUIRE_RE).map { |_, path| "#{path}.rb" }
               end
    abort 'No includes found.' if requires.empty?
    
    file = if requires.size > 1
             choice = RadRails::UI.menu(requires) or exit
             requires[choice]
           else
             requires.pop
           end
    dir  = $LOAD_PATH.find { |dir| File.exist? File.join(dir, file) }
    if not dir and gems_installed and gem_spec = Gem::GemPathSearcher.new.find(file)
      dir = File.join(gem_spec.full_gem_path, gem_spec.require_path)
    end
    
    if file and dir
      dir.sub!(%r{\A\.(?=/|\z)}, context['TM_DIRECTORY']) if context['TM_DIRECTORY']
      file_path = File.join(dir, file)
      # puts file_path
      RadRails::Editor.go_to :file => file_path
      nil
    else
      "File not found: #{file}"
    end
  end
end
