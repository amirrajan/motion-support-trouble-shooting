class Symbol
  defined?(Object)

  # Symbols are not duplicable:
  #
  #   :my_symbol.duplicable? # => false
  #   :my_symbol.dup         # => TypeError: can't dup Symbol
  def duplicable?
    false
  end

  # Returns +self+ as string.
  def to_json
    self.to_s
  end
end
