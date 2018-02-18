class Date
  # def self.gregorian_leap?(year)
  #   if year % 400 == 0
  #     true
  #   elsif year % 100 == 0 then
  #     false
  #   elsif year % 4 == 0 then
  #     true
  #   else
  #     false
  #   end
  # end

  # def initialize(year = nil, month = nil, day = nil)
  #   if year && month && day
  #     @value = Time.utc(year, month, day)
  #   else
  #     @value = Time.now
  #   end
  # end

  # def self.today
  #   new
  # end

  # def to_s
  #   "#{year}-#{month}-#{day}"
  # end

  # def ==(other)
  #   year == other.year &&
  #   month == other.month &&
  #   day == other.day
  # end

  # def +(other)
  #   val = @value + other * 3600 * 24
  #   Date.new(val.year, val.month, val.day)
  # end

  # def -(other)
  #   if other.is_a?(Date)
  #     (@value - other.instance_variable_get(:@value)) / (3600 * 24)
  #   elsif other.is_a?(Time)
  #     (@value - other)
  #   else
  #     self + (-other)
  #   end
  # end

  # def >>(months)
  #   new_year = year + (self.month + months - 1) / 12
  #   new_month = (self.month + months) % 12
  #   new_month = new_month == 0 ? 12 : new_month
  #   new_day = [day, Time.days_in_month(new_month, new_year)].min

  #   Date.new(new_year, new_month, new_day)
  # end

  # def <<(months)
  #   return self >> -months
  # end

  # [:year, :month, :day, :wday, :<, :<=, :>, :>=, :"<=>", :strftime].each do |method|
  #   define_method method do |*args|
  #     @value.send(method, *args)
  #   end
  # end

  # def to_date
  #   self
  # end

  # def to_time
  #   @value
  # end

  # def succ
  #   self + 1
  # end

  # # Duck-types as a Date-like class. See Object#acts_like?.
  # def acts_like_date?
  #   true
  # end

  include DateAndTime::Calculations

  # class << self
  #   attr_accessor :beginning_of_week_default

  #   # Returns the week start (e.g. :monday) for the current request, if this has been set (via Date.beginning_of_week=).
  #   # If <tt>Date.beginning_of_week</tt> has not been set for the current request, returns the week start specified in <tt>config.beginning_of_week</tt>.
  #   # If no config.beginning_of_week was specified, returns :monday.
  #   def beginning_of_week
  #     Thread.current[:beginning_of_week] || beginning_of_week_default || :monday
  #   end

  #   # Sets <tt>Date.beginning_of_week</tt> to a week start (e.g. :monday) for current request/thread.
  #   #
  #   # This method accepts any of the following day symbols:
  #   # :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday
  #   def beginning_of_week=(week_start)
  #     Thread.current[:beginning_of_week] = find_beginning_of_week!(week_start)
  #   end

  #   # Returns week start day symbol (e.g. :monday), or raises an ArgumentError for invalid day symbol.
  #   def find_beginning_of_week!(week_start)
  #     raise ArgumentError, "Invalid beginning of week: #{week_start}" unless ::Date::DAYS_INTO_WEEK.key?(week_start)
  #     week_start
  #   end

  #   # Returns a new Date representing the date 1 day ago (i.e. yesterday's date).
  #   def yesterday
  #     ::Date.current.yesterday
  #   end

  #   # Returns a new Date representing the date 1 day after today (i.e. tomorrow's date).
  #   def tomorrow
  #     ::Date.current.tomorrow
  #   end

  #   # Alias for Date.today.
  #   def current
  #     ::Date.today
  #   end
  # end

  # # Converts Date to a Time (or DateTime if necessary) with the time portion set to the beginning of the day (0:00)
  # # and then subtracts the specified number of seconds.
  # def ago(seconds)
  #   to_time.since(-seconds)
  # end

  # # Converts Date to a Time (or DateTime if necessary) with the time portion set to the beginning of the day (0:00)
  # # and then adds the specified number of seconds
  # def since(seconds)
  #   to_time.since(seconds)
  # end
  # alias :in :since

  # # Converts Date to a Time (or DateTime if necessary) with the time portion set to the beginning of the day (0:00)
  # def beginning_of_day
  #   to_time
  # end
  # alias :midnight :beginning_of_day
  # alias :at_midnight :beginning_of_day
  # alias :at_beginning_of_day :beginning_of_day

  # # Converts Date to a Time (or DateTime if necessary) with the time portion set to the end of the day (23:59:59)
  # def end_of_day
  #   to_time.end_of_day
  # end
  # alias :at_end_of_day :end_of_day

  # def plus_with_duration(other) #:nodoc:
  #   if MotionSupport::Duration === other
  #     other.since(self)
  #   else
  #     plus_without_duration(other)
  #   end
  # end
  # alias_method :plus_without_duration, :+
  # alias_method :+, :plus_with_duration

  # def minus_with_duration(other) #:nodoc:
  #   if MotionSupport::Duration === other
  #     plus_with_duration(-other)
  #   else
  #     minus_without_duration(other)
  #   end
  # end
  # alias_method :minus_without_duration, :-
  # alias_method :-, :minus_with_duration

  # # Provides precise Date calculations for years, months, and days. The +options+ parameter takes a hash with
  # # any of these keys: <tt>:years</tt>, <tt>:months</tt>, <tt>:weeks</tt>, <tt>:days</tt>.
  # def advance(options)
  #   options = options.dup
  #   d = self
  #   d = d >> options.delete(:years) * 12 if options[:years]
  #   d = d >> options.delete(:months)     if options[:months]
  #   d = d +  options.delete(:weeks) * 7  if options[:weeks]
  #   d = d +  options.delete(:days)       if options[:days]
  #   d
  # end

  # # Returns a new Date where one or more of the elements have been changed according to the +options+ parameter.
  # # The +options+ parameter is a hash with a combination of these keys: <tt>:year</tt>, <tt>:month</tt>, <tt>:day</tt>.
  # #
  # #   Date.new(2007, 5, 12).change(day: 1)               # => Date.new(2007, 5, 1)
  # #   Date.new(2007, 5, 12).change(year: 2005, month: 1) # => Date.new(2005, 1, 12)
  # def change(options)
  #   ::Date.new(
  #     options.fetch(:year, year),
  #     options.fetch(:month, month),
  #     options.fetch(:day, day)
  #   )
  # end

  # DATE_FORMATS = {
  #   :short        => '%e %b',
  #   :long         => '%B %e, %Y',
  #   :db           => '%Y-%m-%d',
  #   :number       => '%Y%m%d',
  #   :long_ordinal => lambda { |date|
  #     day_format = MotionSupport::Inflector.ordinalize(date.day)
  #     date.strftime("%B #{day_format}, %Y") # => "April 25th, 2007"
  #   },
  #   :rfc822       => '%e %b %Y',
  #   :iso8601      => '%Y-%m-%d',
  #   :xmlschema    => '%Y-%m-%dT00:00:00Z'
  # }

  # def iso8601
  #   strftime DATE_FORMATS[:iso8601]
  # end

  # # Convert to a formatted string. See DATE_FORMATS for predefined formats.
  # #
  # # This method is aliased to <tt>to_s</tt>.
  # #
  # #   date = Date.new(2007, 11, 10)       # => Sat, 10 Nov 2007
  # #
  # #   date.to_formatted_s(:db)            # => "2007-11-10"
  # #   date.to_s(:db)                      # => "2007-11-10"
  # #
  # #   date.to_formatted_s(:short)         # => "10 Nov"
  # #   date.to_formatted_s(:long)          # => "November 10, 2007"
  # #   date.to_formatted_s(:long_ordinal)  # => "November 10th, 2007"
  # #   date.to_formatted_s(:rfc822)        # => "10 Nov 2007"
  # #
  # # == Adding your own time formats to to_formatted_s
  # # You can add your own formats to the Date::DATE_FORMATS hash.
  # # Use the format name as the hash key and either a strftime string
  # # or Proc instance that takes a date argument as the value.
  # #
  # #   # config/initializers/time_formats.rb
  # #   Date::DATE_FORMATS[:month_and_year] = '%B %Y'
  # #   Date::DATE_FORMATS[:short_ordinal] = ->(date) { date.strftime("%B #{date.day.ordinalize}") }
  # def to_formatted_s(format = :default)
  #   formatter = DATE_FORMATS[format]

  #   return to_default_s unless formatter

  #   return formatter.call(self).to_s if formatter.respond_to?(:call)

  #   strftime(formatter)
  # end
  # alias_method :to_default_s, :to_s
  # alias_method :to_s, :to_formatted_s

  # # Overrides the default inspect method with a human readable one, e.g., "Mon, 21 Feb 2005"
  # def readable_inspect
  #   strftime('%a, %d %b %Y')
  # end
  # alias_method :default_inspect, :inspect
  # alias_method :inspect, :readable_inspect

  # def xmlschema
  #   strftime DATE_FORMATS[:xmlschema]
  # end

  # def as_json
  #   strftime("%Y-%m-%d")
  # end

  # def to_json
  #   as_json.to_json
  # end
end
