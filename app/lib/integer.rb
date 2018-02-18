class Integer
  defined?(Object)
  # # Ordinalize turns a number into an ordinal string used to denote the
  # # position in an ordered sequence such as 1st, 2nd, 3rd, 4th.
  # #
  # #  1.ordinalize     # => "1st"
  # #  2.ordinalize     # => "2nd"
  # #  1002.ordinalize  # => "1002nd"
  # #  1003.ordinalize  # => "1003rd"
  # #  -11.ordinalize   # => "-11th"
  # #  -1001.ordinalize # => "-1001st"
  # def ordinalize
  #   MotionSupport::Inflector.ordinalize(self)
  # end

  # # Ordinal returns the suffix used to denote the position
  # # in an ordered sequence such as 1st, 2nd, 3rd, 4th.
  # #
  # #  1.ordinal     # => "st"
  # #  2.ordinal     # => "nd"
  # #  1002.ordinal  # => "nd"
  # #  1003.ordinal  # => "rd"
  # #  -11.ordinal   # => "th"
  # #  -1001.ordinal # => "st"
  # def ordinal
  #   MotionSupport::Inflector.ordinal(self)
  # end

  # # Check whether the integer is evenly divisible by the argument.
  # #
  # #   0.multiple_of?(0)  #=> true
  # #   6.multiple_of?(5)  #=> false
  # #   10.multiple_of?(2) #=> true
  # def multiple_of?(number)
  #   number != 0 ? self % number == 0 : zero?
  # end

  # # Enables the use of time calculations and declarations, like <tt>45.minutes +
  # # 2.hours + 4.years</tt>.
  # #
  # # These methods use Time#advance for precise date calculations when using
  # # <tt>from_now</tt>, +ago+, etc. as well as adding or subtracting their
  # # results from a Time object.
  # #
  # #   # equivalent to Time.now.advance(months: 1)
  # #   1.month.from_now
  # #
  # #   # equivalent to Time.now.advance(years: 2)
  # #   2.years.from_now
  # #
  # #   # equivalent to Time.now.advance(months: 4, years: 5)
  # #   (4.months + 5.years).from_now
  # #
  # # While these methods provide precise calculation when used as in the examples
  # # above, care should be taken to note that this is not true if the result of
  # # +months+, +years+, etc is converted before use:
  # #
  # #   # equivalent to 30.days.to_i.from_now
  # #   1.month.to_i.from_now
  # #
  # #   # equivalent to 365.25.days.to_f.from_now
  # #   1.year.to_f.from_now
  # #
  # # In such cases, Ruby's core
  # # Date[http://ruby-doc.org/stdlib/libdoc/date/rdoc/Date.html] and
  # # Time[http://ruby-doc.org/stdlib/libdoc/time/rdoc/Time.html] should be used for precision
  # # date and time arithmetic.
  # def months
  #   MotionSupport::Duration.new(self * 30.days, [[:months, self]])
  # end
  # alias :month :months

  # def years
  #   MotionSupport::Duration.new(self * 365.25.days, [[:years, self]])
  # end
  # alias :year :years
end
