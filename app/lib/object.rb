class Object
  # # A duck-type assistant method. For example, Active Support extends Date
  # # to define an <tt>acts_like_date?</tt> method, and extends Time to define
  # # <tt>acts_like_time?</tt>. As a result, we can do <tt>x.acts_like?(:time)</tt> and
  # # <tt>x.acts_like?(:date)</tt> to do duck-type-safe comparisons, since classes that
  # # we want to act like Time simply need to define an <tt>acts_like_time?</tt> method.
  # def acts_like?(duck)
  #   respond_to? :"acts_like_#{duck}?"
  # end

  # # An object is blank if it's false, empty, or a whitespace string.
  # # For example, '', '   ', +nil+, [], and {} are all blank.
  # #
  # # This simplifies:
  # #
  # #   if address.nil? || address.empty?
  # #
  # # ...to:
  # #
  # #   if address.blank?
  # def blank?
  #   respond_to?(:empty?) ? empty? : !self
  # end

  # # An object is present if it's not <tt>blank?</tt>.
  # def present?
  #   !blank?
  # end

  # # Returns object if it's <tt>present?</tt> otherwise returns +nil+.
  # # <tt>object.presence</tt> is equivalent to <tt>object.present? ? object : nil</tt>.
  # #
  # # This is handy for any representation of objects where blank is the same
  # # as not present at all. For example, this simplifies a common check for
  # # HTTP POST/query parameters:
  # #
  # #   state   = params[:state]   if params[:state].present?
  # #   country = params[:country] if params[:country].present?
  # #   region  = state || country || 'US'
  # #
  # # ...becomes:
  # #
  # #   region = params[:state].presence || params[:country].presence || 'US'
  # def presence
  #   self if present?
  # end

  # # Returns a deep copy of object if it's duplicable. If it's
  # # not duplicable, returns +self+.
  # #
  # #   object = Object.new
  # #   dup    = object.deep_dup
  # #   dup.instance_variable_set(:@a, 1)
  # #
  # #   object.instance_variable_defined?(:@a) #=> false
  # #   dup.instance_variable_defined?(:@a)    #=> true
  # def deep_dup
  #   duplicable? ? dup : self
  # end

  # # Can you safely dup this object?
  # #
  # # False for +nil+, +false+, +true+, symbol, and number objects;
  # # true otherwise.
  # def duplicable?
  #   true
  # end

  # # Returns true if this object is included in the argument(s). Argument must be
  # # any object which responds to +#include?+. Usage:
  # #
  # #   characters = ['Konata', 'Kagami', 'Tsukasa']
  # #   'Konata'.in?(characters) # => true
  # #
  # # This will throw an ArgumentError it doesn't respond to +#include?+.
  # def __in_workaround(args)
  #   args.include?(self)
  # rescue NoMethodError
  #   raise ArgumentError.new("The parameter passed to #in? must respond to #include?")
  # end
  # alias in? __in_workaround

  # # Returns a hash with string keys that maps instance variable names without "@" to their
  # # corresponding values.
  # #
  # #   class C
  # #     def initialize(x, y)
  # #       @x, @y = x, y
  # #     end
  # #   end
  # #
  # #   C.new(0, 1).instance_values # => {"x" => 0, "y" => 1}
  # def instance_values
  #   Hash[instance_variables.map { |name| [name[1..-1], instance_variable_get(name)] }]
  # end

  # # Returns an array of instance variable names as strings including "@".
  # #
  # #   class C
  # #     def initialize(x, y)
  # #       @x, @y = x, y
  # #     end
  # #   end
  # #
  # #   C.new(0, 1).instance_variable_names # => ["@y", "@x"]
  # def instance_variable_names
  #   instance_variables.map { |var| var.to_s }
  # end

  # # Serializes the object to a hash then the hash using Cocoa's NSJSONSerialization
  # def to_json
  #   attributes =
  #     if respond_to?(:to_hash)
  #       to_hash.as_json
  #     else
  #       instance_values.as_json
  #     end

  #   attributes.to_json
  # end

  # # Alias of <tt>to_s</tt>.
  # def to_param
  #   to_s
  # end

  # # Converts an object into a string suitable for use as a URL query string, using the given <tt>key</tt> as the
  # # param name.
  # #
  # # Note: This method is defined as a default implementation for all Objects for Hash#to_query to work.
  # def to_query(key)
  #   "#{CGI.escape(key.to_param)}=#{CGI.escape(to_param.to_s)}"
  # end

  # # Invokes the public method whose name goes as first argument just like
  # # +public_send+ does, except that if the receiver does not respond to it the
  # # call returns +nil+ rather than raising an exception.
  # #
  # # This method is defined to be able to write
  # #
  # #   @person.try(:name)
  # #
  # # instead of
  # #
  # #   @person ? @person.name : nil
  # #
  # # +try+ returns +nil+ when called on +nil+ regardless of whether it responds
  # # to the method:
  # #
  # #   nil.try(:to_i) # => nil, rather than 0
  # #
  # # Arguments and blocks are forwarded to the method if invoked:
  # #
  # #   @posts.try(:each_slice, 2) do |a, b|
  # #     ...
  # #   end
  # #
  # # The number of arguments in the signature must match. If the object responds
  # # to the method the call is attempted and +ArgumentError+ is still raised
  # # otherwise.
  # #
  # # If +try+ is called without arguments it yields the receiver to a given
  # # block unless it is +nil+:
  # #
  # #   @person.try do |p|
  # #     ...
  # #   end
  # #
  # # Please also note that +try+ is defined on +Object+, therefore it won't work
  # # with instances of classes that do not have +Object+ among their ancestors,
  # # like direct subclasses of +BasicObject+. For example, using +try+ with
  # # +SimpleDelegator+ will delegate +try+ to the target instead of calling it on
  # # delegator itself.
  # def try(*a, &b)
  #   if a.empty? && block_given?
  #     yield self
  #   else
  #     public_send(*a, &b) if respond_to?(a.first)
  #   end
  # end

  # # Same as #try, but will raise a NoMethodError exception if the receiving is not nil and
  # # does not implemented the tried method.
  # def try!(*a, &b)
  #   if a.empty? && block_given?
  #     yield self
  #   else
  #     public_send(*a, &b)
  #   end
  # end
end
