require 'parslet'

class FnJoinVisitor < Parslet::Parser
  def visit_Fn__Join(val, h)
    if val.is_a?(Array)
      return val
    end

    if val.is_a?(String)
      return ["", transmog(parser(val)).flatten]
    end

    raise "Incorrect use of Fn::Join, you can only use an Array or String."
  end

  private

  def parser(val)
    ((reference | other).repeat).parse(val)
  end

  def reference
    (str('%{{') >> match('[a-zA-Z0-9\:]').repeat(1).as(:Ref) >> str('}}'))
  end

  def other
    ((str("%{{").absent? >> any).repeat(1).as(:other))
  end

  def transmog(parse_result)
    Parslet::Transform.new do
      rule(:other => simple(:x)) { x.to_s }
      rule(:Ref => simple(:x))   { { "Ref" => x.to_s } }
    end.apply(parse_result)
  end
end
