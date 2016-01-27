require 'slop'
require 'json'

module Slop
  class KeyValuesOption < ArrayOption
    def finish(_opts)
      self.value = value.map do |s|
        arrs = s.split("=")
        { key: arrs.first, value: arrs.last}
      end
    end
  end

  class ParamsFileOption < ArrayOption
    def call(value)
      self.value = JSON.parse(File.read(value))
    end

    def finish(opts)
      self.value = opts[:paramsfile].map do |p|
        { key: p["ParameterKey"], value: p["ParameterValue"] }
      end
    end
  end
end

def parse_args(args = ARGV, input = ARGF)
  opts = opts_parser.parse(args)
  opts[:params] += opts[:paramsfile]
  args.replace opts.arguments
  opts_h = opts.to_h
  opts_h.delete(:paramsfile)
  opts_h[:stack_name] = args.pop
  opts_h[:template] = input.read
  opts_h
end

def opts_parser
  Slop::Options.new do |o|
    o.params_file '--paramsfile', 'A json cloudformation parameters file'
    o.key_values '--params', 'key=value pairs for the cfn params'
    o.key_values '--tags', 'key=value pairs for the cfn tags'
  end
end
