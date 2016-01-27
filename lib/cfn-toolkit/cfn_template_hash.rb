class CfnTemplateHash
  def initialize(hash)
    @hash = hash
  end

  def accept(visitor)
    if visitor.respond_to?(:visit_template)
      visitor.visit_template(@hash)
    end
    accept_recurse(@hash, visitor)
    self
  end

  def to_h
    @hash
  end

  private

  def accept_recurse(h, visitor)
    h.each do |k, v|
      value = v
      if v.is_a?(Hash)
        # we shouldnt blow the stack with cfn templates
        # they arent that deep... I hope?
        value = accept_recurse(v, visitor)
      end
      final_value = value
      visit_method = key_to_method(k)
      if visitor.respond_to?(visit_method)
        final_value = visitor.public_send(visit_method, value, @hash)
      end
      h[k] = final_value
    end
  end

  def key_to_method(key)
    key = key.gsub("::", "__")
    "visit_#{key}".to_sym
  end
end
