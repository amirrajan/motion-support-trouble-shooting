
class TrueClass
  defined?(Object)

  # +true+ is not blank:
  #
  #   true.blank? # => false
  def blank?
    false
  end

  # +true+ is not duplicable:
  #
  #   true.duplicable? # => false
  #   true.dup         # => TypeError: can't dup TrueClass
  def duplicable?
    false
  end

  # Returns +self+ as string.
  def to_json
    self.to_s
  end

  # Returns +self+.
  def to_param
    self
  end
end
