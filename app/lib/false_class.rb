
class FalseClass
  # # +false+ is blank:
  # #
  # #   false.blank? # => true
  # def blank?
  #   true
  # end

  # # +false+ is not duplicable:
  # #
  # #   false.duplicable? # => false
  # #   false.dup         # => TypeError: can't dup FalseClass
  # def duplicable?
  #   false
  # end

  # # Returns +self+ as string.
  # def to_json
  #   self.to_s
  # end

  # # Returns +self+.
  # def to_param
  #   self
  # end
end
