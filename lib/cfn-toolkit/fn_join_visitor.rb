class FnJoinVisitor
  def visit_Fn__Join(val, h)
    if val.is_a?(Array)
      return val
    end

    if val.is_a?(String)
      return ["", val.split("\n").map { |s| s + "\n"}]
    end

    raise "Incorrect use of Fn::Join, you can only use and Array or String."
  end
end
