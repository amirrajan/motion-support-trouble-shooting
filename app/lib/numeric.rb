class Numeric
  defined?(Object)

  # KILOBYTE = 1024
  # MEGABYTE = KILOBYTE * 1024
  # GIGABYTE = MEGABYTE * 1024
  # TERABYTE = GIGABYTE * 1024
  # PETABYTE = TERABYTE * 1024
  # EXABYTE  = PETABYTE * 1024

  # # Enables the use of byte calculations and declarations, like 45.bytes + 2.6.megabytes
  # def bytes
  #   self
  # end
  # alias :byte :bytes

  # def kilobytes
  #   self * KILOBYTE
  # end
  # alias :kilobyte :kilobytes

  # def megabytes
  #   self * MEGABYTE
  # end
  # alias :megabyte :megabytes

  # def gigabytes
  #   self * GIGABYTE
  # end
  # alias :gigabyte :gigabytes

  # def terabytes
  #   self * TERABYTE
  # end
  # alias :terabyte :terabytes

  # def petabytes
  #   self * PETABYTE
  # end
  # alias :petabyte :petabytes

  # def exabytes
  #   self * EXABYTE
  # end
  # alias :exabyte :exabytes

  # # Provides options for converting numbers into formatted strings.
  # # Right now, options are only provided for phone numbers.
  # #
  # # ==== Options
  # #
  # # For details on which formats use which options, see MotionSupport::NumberHelper
  # #
  # # ==== Examples
  # #
  # #  Phone Numbers:
  # #  5551234.to_s(:phone)                                     # => 555-1234
  # #  1235551234.to_s(:phone)                                  # => 123-555-1234
  # #  1235551234.to_s(:phone, area_code: true)                 # => (123) 555-1234
  # #  1235551234.to_s(:phone, delimiter: ' ')                  # => 123 555 1234
  # #  1235551234.to_s(:phone, area_code: true, extension: 555) # => (123) 555-1234 x 555
  # #  1235551234.to_s(:phone, country_code: 1)                 # => +1-123-555-1234
  # #  1235551234.to_s(:phone, country_code: 1, extension: 1343, delimiter: '.')
  # #  # => +1.123.555.1234 x 1343
  # def to_formatted_s(format = :default, options = {})
  #   case format
  #   when :phone
  #     return MotionSupport::NumberHelper.number_to_phone(self, options)
  #   else
  #     self.to_default_s
  #   end
  # end

  # [Float, Fixnum, Bignum].each do |klass|
  #   klass.send(:alias_method, :to_default_s, :to_s)

  #   klass.send(:define_method, :to_s) do |*args|
  #     if args[0].is_a?(Symbol)
  #       format = args[0]
  #       options = args[1] || {}

  #       self.to_formatted_s(format, options)
  #     else
  #       to_default_s(*args)
  #     end
  #   end
  # end

  # # Enables the use of time calculations and declarations, like 45.minutes + 2.hours + 4.years.
  # #
  # # These methods use Time#advance for precise date calculations when using from_now, ago, etc.
  # # as well as adding or subtracting their results from a Time object. For example:
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
  # # While these methods provide precise calculation when used as in the examples above, care
  # # should be taken to note that this is not true if the result of `months', `years', etc is
  # # converted before use:
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
  # def seconds
  #   MotionSupport::Duration.new(self, [[:seconds, self]])
  # end
  # alias :second :seconds

  # def minutes
  #   MotionSupport::Duration.new(self * 60, [[:seconds, self * 60]])
  # end
  # alias :minute :minutes

  # def hours
  #   MotionSupport::Duration.new(self * 3600, [[:seconds, self * 3600]])
  # end
  # alias :hour :hours

  # def days
  #   MotionSupport::Duration.new(self * 24.hours, [[:days, self]])
  # end
  # alias :day :days

  # def weeks
  #   MotionSupport::Duration.new(self * 7.days, [[:days, self * 7]])
  # end
  # alias :week :weeks

  # def fortnights
  #   MotionSupport::Duration.new(self * 2.weeks, [[:days, self * 14]])
  # end
  # alias :fortnight :fortnights

  # # Reads best without arguments:  10.minutes.ago
  # def ago(time = ::Time.now)
  #   time - self
  # end

  # # Reads best with argument:  10.minutes.until(time)
  # alias :until :ago

  # # Reads best with argument:  10.minutes.since(time)
  # def since(time = ::Time.now)
  #   time + self
  # end

  # # Reads best without arguments:  10.minutes.from_now
  # alias :from_now :since

  # # No number is blank:
  # #
  # #   1.blank? # => false
  # #   0.blank? # => false
  # def blank?
  #   false
  # end

  # # Numbers are not duplicable:
  # #
  # #  3.duplicable? # => false
  # #  3.dup         # => TypeError: can't dup Fixnum
  # def duplicable?
  #   false
  # end

  # # Returns +self+.
  # def to_json
  #   self
  # end
end
