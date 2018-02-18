# coding: utf-8

class String
  # # A string is blank if it's empty or contains whitespaces only:
  # #
  # #   ''.blank?                 # => true
  # #   '   '.blank?              # => true
  # #   '　'.blank?               # => true
  # #   ' something here '.blank? # => false
  # def blank?
  #   self !~ /[^[:space:]]/
  # end

  # # Returns JSON-escaped +self+.
  # def to_json
  #   JSONString.escape(self)
  # end
end
