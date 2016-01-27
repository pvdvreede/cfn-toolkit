require 'slop'

module Slop
  class KeyValuesOption < ArrayOption
    def finish(_opts)
      self.value = value.map do |s|
        arrs = s.split("=")
        { key: arrs.first, value: arrs.last}
      end
    end
  end
end

def opts_parser
  Slop::Options.new do |o|
    o.key_values '--params', 'key=value pairs for the cfn params'
    o.key_values '--tags', 'key=value pairs for the cfn tags'
  end
end
