class Array
  # def reverse_each
  #   return to_enum(:reverse_each) unless block_given?

  #   i = size - 1
  #   while i >= 0
  #     yield self[i]
  #     i -= 1
  #   end

  #   self
  # end

  # # If any item in the array has the key == `key` true, otherwise false.
  # # Of good use when writing specs.
  # def has_hash_key?(key)
  #   self.each do |entity|
  #     return true if entity.has_key? key
  #   end
  #   return false
  # end

  # # If any item in the array has the value == `key` true, otherwise false
  # # Of good use when writing specs.
  # def has_hash_value?(key)
  #   self.each do |entity|
  #     entity.each_pair{|hash_key, value| return true if value == key}
  #   end
  #   return false
  # end

  # # Returns the tail of the array from +position+.
  # #
  # #   %w( a b c d ).from(0)  # => ["a", "b", "c", "d"]
  # #   %w( a b c d ).from(2)  # => ["c", "d"]
  # #   %w( a b c d ).from(10) # => []
  # #   %w().from(0)           # => []
  # def from(position)
  #   self[position, length] || []
  # end

  # # Returns the beginning of the array up to +position+.
  # #
  # #   %w( a b c d ).to(0)  # => ["a"]
  # #   %w( a b c d ).to(2)  # => ["a", "b", "c"]
  # #   %w( a b c d ).to(10) # => ["a", "b", "c", "d"]
  # #   %w().to(0)           # => []
  # def to(position)
  #   first position + 1
  # end

  # # Equal to <tt>self[1]</tt>.
  # #
  # #   %w( a b c d e ).second # => "b"
  # def second
  #   self[1]
  # end

  # # Converts the array to a comma-separated sentence where the last element is
  # # joined by the connector word.
  # #
  # # You can pass the following options to change the default behavior. If you
  # # pass an option key that doesn't exist in the list below, it will raise an
  # # <tt>ArgumentError</tt>.
  # #
  # # Options:
  # #
  # # * <tt>:words_connector</tt> - The sign or word used to join the elements
  # #   in arrays with two or more elements (default: ", ").
  # # * <tt>:two_words_connector</tt> - The sign or word used to join the elements
  # #   in arrays with two elements (default: " and ").
  # # * <tt>:last_word_connector</tt> - The sign or word used to join the last element
  # #   in arrays with three or more elements (default: ", and ").
  # #
  # #   [].to_sentence                      # => ""
  # #   ['one'].to_sentence                 # => "one"
  # #   ['one', 'two'].to_sentence          # => "one and two"
  # #   ['one', 'two', 'three'].to_sentence # => "one, two, and three"
  # #
  # #   ['one', 'two'].to_sentence(passing: 'invalid option')
  # #   # => ArgumentError: Unknown key :passing
  # #
  # #   ['one', 'two'].to_sentence(two_words_connector: '-')
  # #   # => "one-two"
  # #
  # #   ['one', 'two', 'three'].to_sentence(words_connector: ' or ', last_word_connector: ' or at least ')
  # #   # => "one or two or at least three"
  # def to_sentence(options = {})
  #   options.assert_valid_keys(:words_connector, :two_words_connector, :last_word_connector)

  #   default_connectors = {
  #     :words_connector     => ', ',
  #     :two_words_connector => ' and ',
  #     :last_word_connector => ', and '
  #   }
  #   options = default_connectors.merge!(options)

  #   case length
  #   when 0
  #     ''
  #   when 1
  #     self[0].to_s.dup
  #   when 2
  #     "#{self[0]}#{options[:two_words_connector]}#{self[1]}"
  #   else
  #     "#{self[0...-1].join(options[:words_connector])}#{options[:last_word_connector]}#{self[-1]}"
  #   end
  # end

  # # Converts a collection of elements into a formatted string by calling
  # # <tt>to_s</tt> on all elements and joining them. Having this model:
  # #
  # #   class Blog < ActiveRecord::Base
  # #     def to_s
  # #       title
  # #     end
  # #   end
  # #
  # #   Blog.all.map(&:title) #=> ["First Post", "Second Post", "Third post"]
  # #
  # # <tt>to_formatted_s</tt> shows us:
  # #
  # #   Blog.all.to_formatted_s # => "First PostSecond PostThird Post"
  # #
  # # Adding in the <tt>:db</tt> argument as the format yields a comma separated
  # # id list:
  # #
  # #   Blog.all.to_formatted_s(:db) # => "1,2,3"
  # def to_formatted_s(format = :default)
  #   case format
  #   when :db
  #     if empty?
  #       'null'
  #     else
  #       collect { |element| element.id }.join(',')
  #     end
  #   else
  #     to_default_s
  #   end
  # end
  # alias_method :to_default_s, :to_s
  # alias_method :to_s, :to_formatted_s

  # # Extracts options from a set of arguments. Removes and returns the last
  # # element in the array if it's a hash, otherwise returns a blank hash.
  # def extract_options!
  #   if last.is_a?(Hash)
  #     pop
  #   else
  #     {}
  #   end
  # end

  # # Splits or iterates over the array in groups of size +number+,
  # # padding any remaining slots with +fill_with+ unless it is +false+.
  # #
  # #   %w(1 2 3 4 5 6 7 8 9 10).in_groups_of(3) {|group| p group}
  # #   ["1", "2", "3"]
  # #   ["4", "5", "6"]
  # #   ["7", "8", "9"]
  # #   ["10", nil, nil]
  # #
  # #   %w(1 2 3 4 5).in_groups_of(2, '&nbsp;') {|group| p group}
  # #   ["1", "2"]
  # #   ["3", "4"]
  # #   ["5", "&nbsp;"]
  # #
  # #   %w(1 2 3 4 5).in_groups_of(2, false) {|group| p group}
  # #   ["1", "2"]
  # #   ["3", "4"]
  # #   ["5"]
  # def in_groups_of(number, fill_with = nil)
  #   if fill_with == false
  #     collection = self
  #   else
  #     # size % number gives how many extra we have;
  #     # subtracting from number gives how many to add;
  #     # modulo number ensures we don't add group of just fill.
  #     padding = (number - size % number) % number
  #     collection = dup.concat([fill_with] * padding)
  #   end

  #   if block_given?
  #     collection.each_slice(number) { |slice| yield(slice) }
  #   else
  #     groups = []
  #     collection.each_slice(number) { |group| groups << group }
  #     groups
  #   end
  # end

  # # Splits or iterates over the array in +number+ of groups, padding any
  # # remaining slots with +fill_with+ unless it is +false+.
  # #
  # #   %w(1 2 3 4 5 6 7 8 9 10).in_groups(3) {|group| p group}
  # #   ["1", "2", "3", "4"]
  # #   ["5", "6", "7", nil]
  # #   ["8", "9", "10", nil]
  # #
  # #   %w(1 2 3 4 5 6 7 8 9 10).in_groups(3, '&nbsp;') {|group| p group}
  # #   ["1", "2", "3", "4"]
  # #   ["5", "6", "7", "&nbsp;"]
  # #   ["8", "9", "10", "&nbsp;"]
  # #
  # #   %w(1 2 3 4 5 6 7).in_groups(3, false) {|group| p group}
  # #   ["1", "2", "3"]
  # #   ["4", "5"]
  # #   ["6", "7"]
  # def in_groups(number, fill_with = nil)
  #   # size / number gives minor group size;
  #   # size % number gives how many objects need extra accommodation;
  #   # each group hold either division or division + 1 items.
  #   division = size.div number
  #   modulo = size % number

  #   # create a new array avoiding dup
  #   groups = []
  #   start = 0

  #   number.times do |index|
  #     length = division + (modulo > 0 && modulo > index ? 1 : 0)
  #     groups << last_group = slice(start, length)
  #     last_group << fill_with if fill_with != false &&
  #       modulo > 0 && length == division
  #     start += length
  #   end

  #   if block_given?
  #     groups.each { |g| yield(g) }
  #   else
  #     groups
  #   end
  # end

  # # Divides the array into one or more subarrays based on a delimiting +value+
  # # or the result of an optional block.
  # #
  # #   [1, 2, 3, 4, 5].split(3)              # => [[1, 2], [4, 5]]
  # #   (1..10).to_a.split { |i| i % 3 == 0 } # => [[1, 2], [4, 5], [7, 8], [10]]
  # def split(value = nil, &block)
  #   inject([[]]) do |results, element|
  #     if block && block.call(element) || value == element
  #       results << []
  #     else
  #       results.last << element
  #     end

  #     results
  #   end
  # end

  # # The human way of thinking about adding stuff to the end of a list is with append
  # alias_method :append,  :<<

  # # The human way of thinking about adding stuff to the beginning of a list is with prepend
  # alias_method :prepend, :unshift

  # # Wraps its argument in an array unless it is already an array (or array-like).
  # #
  # # Specifically:
  # #
  # # * If the argument is +nil+ an empty list is returned.
  # # * Otherwise, if the argument responds to +to_ary+ it is invoked, and its result returned.
  # # * Otherwise, returns an array with the argument as its single element.
  # #
  # #     Array.wrap(nil)       # => []
  # #     Array.wrap([1, 2, 3]) # => [1, 2, 3]
  # #     Array.wrap(0)         # => [0]
  # #
  # # This method is similar in purpose to <tt>Kernel#Array</tt>, but there are some differences:
  # #
  # # * If the argument responds to +to_ary+ the method is invoked. <tt>Kernel#Array</tt>
  # #   moves on to try +to_a+ if the returned value is +nil+, but <tt>Array.wrap</tt> returns
  # #   such a +nil+ right away.
  # # * If the returned value from +to_ary+ is neither +nil+ nor an +Array+ object, <tt>Kernel#Array</tt>
  # #   raises an exception, while <tt>Array.wrap</tt> does not, it just returns the value.
  # # * It does not call +to_a+ on the argument, though special-cases +nil+ to return an empty array.
  # #
  # # The last point is particularly worth comparing for some enumerables:
  # #
  # #   Array(foo: :bar)      # => [[:foo, :bar]]
  # #   Array.wrap(foo: :bar) # => [{:foo=>:bar}]
  # #
  # # There's also a related idiom that uses the splat operator:
  # #
  # #   [*object]
  # #
  # # which for +nil+ returns <tt>[]</tt>, and calls to <tt>Array(object)</tt> otherwise.
  # #
  # # Thus, in this case the behavior may be different for +nil+, and the differences with
  # # <tt>Kernel#Array</tt> explained above apply to the rest of <tt>object</tt>s.
  # def self.wrap(object)
  #   if object.nil?
  #     []
  #   elsif object.respond_to?(:to_ary)
  #     object.to_ary || [object]
  #   else
  #     [object]
  #   end
  # end

  # # An array is blank if it's empty:
  # #
  # #   [].blank?      # => true
  # #   [1,2,3].blank? # => false
  # alias_method :blank?, :empty?

  # # Converts an array into a string suitable for use as a URL query string,
  # # using the given +key+ as the param name.
  # #
  # #   ['Rails', 'coding'].to_query('hobbies') # => "hobbies%5B%5D=Rails&hobbies%5B%5D=coding"
  # def to_query(key)
  #   prefix = "#{key}[]"
  #   collect { |value| value.to_query(prefix) }.join '&'
  # end

  # # Returns a deep copy of array.
  # #
  # #   array = [1, [2, 3]]
  # #   dup   = array.deep_dup
  # #   dup[1][2] = 4
  # #
  # #   array[1][2] #=> nil
  # #   dup[1][2]   #=> 4
  # def deep_dup
  #   map { |it| it.deep_dup }
  # end

  # # Calls <tt>to_param</tt> on all its elements and joins the result with
  # # slashes. This is used by <tt>url_for</tt> in Action Pack.
  # def to_param
  #   collect { |e| e.to_param }.join '/'
  # end

  # def as_json
  #   map { |v| (v.respond_to?(:as_json) ? v.as_json : v) }
  # end

  # # Calls <tt>as_json</tt> on all its elements and converts to a string.
  # def to_json
  #   NSJSONSerialization.dataWithJSONObject(as_json, options: 0, error: nil).to_s
  # end
end
