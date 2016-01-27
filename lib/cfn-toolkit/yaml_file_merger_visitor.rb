require 'yaml'
require 'deep_merge'

class YamlFileMergerVisitor
  def initialize(path_to_yamls)
    @yaml_glob = File.join(path_to_yamls, "**", "*.yml")
  end

  def visit_template(h)
    Dir[@yaml_glob].each do |f|
      yaml_hash = YAML.load_file(f)
      h.deep_merge!(yaml_hash)
    end
  end
end
