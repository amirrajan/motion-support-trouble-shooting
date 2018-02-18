class NilClass
  defined?(Object)
  # # +nil+ is blank:
  # #
  # #   nil.blank? # => true
  # def blank?
  #   true
  # end

  # # +nil+ is not duplicable:
  # #
  # #   nil.duplicable? # => false
  # #   nil.dup         # => TypeError: can't dup NilClass
  # def duplicable?
  #   false
  # end

  # # Returns 'null'.
  # def to_json
  #   'null'
  # end

  # # Returns +self+.
  # def to_param
  #   self
  # end

  # # Calling +try+ on +nil+ always returns +nil+.
  # # It becomes specially helpful when navigating through associations that may return +nil+.
  # #
  # #   nil.try(:name) # => nil
  # #
  # # Without +try+
  # #   @person && !@person.children.blank? && @person.children.first.name
  # #
  # # With +try+
  # #   @person.try(:children).try(:first).try(:name)
  # def try(*args)
  #   nil
  # end

  # def try!(*args)
  #   nil
  # end
end
