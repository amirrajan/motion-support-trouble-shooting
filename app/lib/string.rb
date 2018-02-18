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

  # # If you pass a single Fixnum, returns a substring of one character at that
  # # position. The first character of the string is at position 0, the next at
  # # position 1, and so on. If a range is supplied, a substring containing
  # # characters at offsets given by the range is returned. In both cases, if an
  # # offset is negative, it is counted from the end of the string. Returns nil
  # # if the initial offset falls outside the string. Returns an empty string if
  # # the beginning of the range is greater than the end of the string.
  # #
  # #   str = "hello"
  # #   str.at(0)      #=> "h"
  # #   str.at(1..3)   #=> "ell"
  # #   str.at(-2)     #=> "l"
  # #   str.at(-2..-1) #=> "lo"
  # #   str.at(5)      #=> nil
  # #   str.at(5..-1)  #=> ""
  # #
  # # If a Regexp is given, the matching portion of the string is returned.
  # # If a String is given, that given string is returned if it occurs in
  # # the string. In both cases, nil is returned if there is no match.
  # #
  # #   str = "hello"
  # #   str.at(/lo/) #=> "lo"
  # #   str.at(/ol/) #=> nil
  # #   str.at("lo") #=> "lo"
  # #   str.at("ol") #=> nil
  # def at(position)
  #   self[position]
  # end

  # # Returns a substring from the given position to the end of the string.
  # # If the position is negative, it is counted from the end of the string.
  # #
  # #   str = "hello"
  # #   str.from(0)  #=> "hello"
  # #   str.from(3)  #=> "lo"
  # #   str.from(-2) #=> "lo"
  # #
  # # You can mix it with +to+ method and do fun things like:
  # #
  # #   str = "hello"
  # #   str.from(0).to(-1) #=> "hello"
  # #   str.from(1).to(-2) #=> "ell"
  # def from(position)
  #   self[position..-1]
  # end

  # # Returns a substring from the beginning of the string to the given position.
  # # If the position is negative, it is counted from the end of the string.
  # #
  # #   str = "hello"
  # #   str.to(0)  #=> "h"
  # #   str.to(3)  #=> "hell"
  # #   str.to(-2) #=> "hell"
  # #
  # # You can mix it with +from+ method and do fun things like:
  # #
  # #   str = "hello"
  # #   str.from(0).to(-1) #=> "hello"
  # #   str.from(1).to(-2) #=> "ell"
  # def to(position)
  #   self[0..position]
  # end

  # # Returns the first character. If a limit is supplied, returns a substring
  # # from the beginning of the string until it reaches the limit value. If the
  # # given limit is greater than or equal to the string length, returns self.
  # #
  # #   str = "hello"
  # #   str.first    #=> "h"
  # #   str.first(1) #=> "h"
  # #   str.first(2) #=> "he"
  # #   str.first(0) #=> ""
  # #   str.first(6) #=> "hello"
  # def first(limit = 1)
  #   if limit == 0
  #     ''
  #   elsif limit >= size
  #     self
  #   else
  #     to(limit - 1)
  #   end
  # end

  # # Returns the last character of the string. If a limit is supplied, returns a substring
  # # from the end of the string until it reaches the limit value (counting backwards). If
  # # the given limit is greater than or equal to the string length, returns self.
  # #
  # #   str = "hello"
  # #   str.last    #=> "o"
  # #   str.last(1) #=> "o"
  # #   str.last(2) #=> "lo"
  # #   str.last(0) #=> ""
  # #   str.last(6) #=> "hello"
  # def last(limit = 1)
  #   if limit == 0
  #     ''
  #   elsif limit >= size
  #     self
  #   else
  #     from(-limit)
  #   end
  # end

  # # Enable more predictable duck-typing on String-like classes. See <tt>Object#acts_like?</tt>.
  # def acts_like_string?
  #   true
  # end

  # # The inverse of <tt>String#include?</tt>. Returns true if the string
  # # does not include the other string.
  # #
  # #   "hello".exclude? "lo" #=> false
  # #   "hello".exclude? "ol" #=> true
  # #   "hello".exclude? ?h   #=> false
  # def exclude?(string)
  #   !include?(string)
  # end

  # # Returns the string, first removing all whitespace on both ends of
  # # the string, and then changing remaining consecutive whitespace
  # # groups into one space each.
  # #
  # # Note that it handles both ASCII and Unicode whitespace like mongolian vowel separator (U+180E).
  # #
  # #   %{ Multi-line
  # #      string }.squish                   # => "Multi-line string"
  # #   " foo   bar    \n   \t   boo".squish # => "foo bar boo"
  # def squish
  #   dup.squish!
  # end

  # # Performs a destructive squish. See String#squish.
  # def squish!
  #   gsub!(/\A[[:space:]]+/, '')
  #   gsub!(/[[:space:]]+\z/, '')
  #   gsub!(/[[:space:]]+/, ' ')
  #   self
  # end

  # # Truncates a given +text+ after a given <tt>length</tt> if +text+ is longer than <tt>length</tt>:
  # #
  # #   'Once upon a time in a world far far away'.truncate(27)
  # #   # => "Once upon a time in a wo..."
  # #
  # # Pass a string or regexp <tt>:separator</tt> to truncate +text+ at a natural break:
  # #
  # #   'Once upon a time in a world far far away'.truncate(27, separator: ' ')
  # #   # => "Once upon a time in a..."
  # #
  # #   'Once upon a time in a world far far away'.truncate(27, separator: /\s/)
  # #   # => "Once upon a time in a..."
  # #
  # # The last characters will be replaced with the <tt>:omission</tt> string (defaults to "...")
  # # for a total length not exceeding <tt>length</tt>:
  # #
  # #   'And they found that many people were sleeping better.'.truncate(25, omission: '... (continued)')
  # #   # => "And they f... (continued)"
  # def truncate(truncate_at, options = {})
  #   return dup unless length > truncate_at

  #   options[:omission] ||= '...'
  #   length_with_room_for_omission = truncate_at - options[:omission].length
  #   stop = \
  #     if options[:separator]
  #       rindex(options[:separator], length_with_room_for_omission) || length_with_room_for_omission
  #     else
  #       length_with_room_for_omission
  #     end

  #   self[0...stop] + options[:omission]
  # end

  # # Same as +indent+, except it indents the receiver in-place.
  # #
  # # Returns the indented string, or +nil+ if there was nothing to indent.
  # def indent!(amount, indent_string=nil, indent_empty_lines=false)
  #   indent_string = indent_string || self[/^[ \t]/] || ' '
  #   re = indent_empty_lines ? /^/ : /^(?!$)/
  #   gsub!(re, indent_string * amount)
  # end

  # # Indents the lines in the receiver:
  # #
  # #   <<EOS.indent(2)
  # #   def some_method
  # #     some_code
  # #   end
  # #   EOS
  # #   # =>
  # #     def some_method
  # #       some_code
  # #     end
  # #
  # # The second argument, +indent_string+, specifies which indent string to
  # # use. The default is +nil+, which tells the method to make a guess by
  # # peeking at the first indented line, and fallback to a space if there is
  # # none.
  # #
  # #   "  foo".indent(2)        # => "    foo"
  # #   "foo\n\t\tbar".indent(2) # => "\t\tfoo\n\t\t\t\tbar"
  # #   "foo".indent(2, "\t")    # => "\t\tfoo"
  # #
  # # While +indent_string+ is typically one space or tab, it may be any string.
  # #
  # # The third argument, +indent_empty_lines+, is a flag that says whether
  # # empty lines should be indented. Default is false.
  # #
  # #   "foo\n\nbar".indent(2)            # => "  foo\n\n  bar"
  # #   "foo\n\nbar".indent(2, nil, true) # => "  foo\n  \n  bar"
  # #
  # def indent(amount, indent_string=nil, indent_empty_lines=false)
  #   dup.tap {|_| _.indent!(amount, indent_string, indent_empty_lines)}
  # end

  # # Returns the plural form of the word in the string.
  # #
  # # If the optional parameter +count+ is specified,
  # # the singular form will be returned if <tt>count == 1</tt>.
  # # For any other value of +count+ the plural will be returned.
  # #
  # #   'post'.pluralize             # => "posts"
  # #   'octopus'.pluralize          # => "octopi"
  # #   'sheep'.pluralize            # => "sheep"
  # #   'words'.pluralize            # => "words"
  # #   'the blue mailman'.pluralize # => "the blue mailmen"
  # #   'CamelOctopus'.pluralize     # => "CamelOctopi"
  # #   'apple'.pluralize(1)         # => "apple"
  # #   'apple'.pluralize(2)         # => "apples"
  # def pluralize(count = nil)
  #   if count == 1
  #     self
  #   else
  #     MotionSupport::Inflector.pluralize(self)
  #   end
  # end

  # # The reverse of +pluralize+, returns the singular form of a word in a string.
  # #
  # #   'posts'.singularize            # => "post"
  # #   'octopi'.singularize           # => "octopus"
  # #   'sheep'.singularize            # => "sheep"
  # #   'word'.singularize             # => "word"
  # #   'the blue mailmen'.singularize # => "the blue mailman"
  # #   'CamelOctopi'.singularize      # => "CamelOctopus"
  # def singularize
  #   MotionSupport::Inflector.singularize(self)
  # end

  # # +constantize+ tries to find a declared constant with the name specified
  # # in the string. It raises a NameError when the name is not in CamelCase
  # # or is not initialized.  See MotionSupport::Inflector.constantize
  # #
  # #   'Module'.constantize  # => Module
  # #   'Class'.constantize   # => Class
  # #   'blargle'.constantize # => NameError: wrong constant name blargle
  # def constantize
  #   MotionSupport::Inflector.constantize(self)
  # end

  # # +safe_constantize+ tries to find a declared constant with the name specified
  # # in the string. It returns nil when the name is not in CamelCase
  # # or is not initialized.  See MotionSupport::Inflector.safe_constantize
  # #
  # #   'Module'.safe_constantize  # => Module
  # #   'Class'.safe_constantize   # => Class
  # #   'blargle'.safe_constantize # => nil
  # def safe_constantize
  #   MotionSupport::Inflector.safe_constantize(self)
  # end

  # # By default, +camelize+ converts strings to UpperCamelCase. If the argument to camelize
  # # is set to <tt>:lower</tt> then camelize produces lowerCamelCase.
  # #
  # # +camelize+ will also convert '/' to '::' which is useful for converting paths to namespaces.
  # #
  # #   'active_record'.camelize                # => "ActiveRecord"
  # #   'active_record'.camelize(:lower)        # => "activeRecord"
  # #   'active_record/errors'.camelize         # => "ActiveRecord::Errors"
  # #   'active_record/errors'.camelize(:lower) # => "activeRecord::Errors"
  # def camelize(first_letter = :upper)
  #   case first_letter
  #   when :upper
  #     MotionSupport::Inflector.camelize(self, true)
  #   when :lower
  #     MotionSupport::Inflector.camelize(self, false)
  #   end
  # end
  # alias_method :camelcase, :camelize

  # # Capitalizes all the words and replaces some characters in the string to create
  # # a nicer looking title. +titleize+ is meant for creating pretty output. It is not
  # # used in the Rails internals.
  # #
  # # +titleize+ is also aliased as +titlecase+.
  # #
  # #   'man from the boondocks'.titleize # => "Man From The Boondocks"
  # #   'x-men: the last stand'.titleize  # => "X Men: The Last Stand"
  # def titleize
  #   MotionSupport::Inflector.titleize(self)
  # end
  # alias_method :titlecase, :titleize

  # # The reverse of +camelize+. Makes an underscored, lowercase form from the expression in the string.
  # #
  # # +underscore+ will also change '::' to '/' to convert namespaces to paths.
  # #
  # #   'ActiveModel'.underscore         # => "active_model"
  # #   'ActiveModel::Errors'.underscore # => "active_model/errors"
  # def underscore
  #   MotionSupport::Inflector.underscore(self)
  # end

  # # Replaces underscores with dashes in the string.
  # #
  # #   'puni_puni'.dasherize # => "puni-puni"
  # def dasherize
  #   MotionSupport::Inflector.dasherize(self)
  # end

  # # Removes the module part from the constant expression in the string.
  # #
  # #   'ActiveRecord::CoreExtensions::String::Inflections'.demodulize # => "Inflections"
  # #   'Inflections'.demodulize                                       # => "Inflections"
  # #
  # # See also +deconstantize+.
  # def demodulize
  #   MotionSupport::Inflector.demodulize(self)
  # end

  # # Removes the rightmost segment from the constant expression in the string.
  # #
  # #   'Net::HTTP'.deconstantize   # => "Net"
  # #   '::Net::HTTP'.deconstantize # => "::Net"
  # #   'String'.deconstantize      # => ""
  # #   '::String'.deconstantize    # => ""
  # #   ''.deconstantize            # => ""
  # #
  # # See also +demodulize+.
  # def deconstantize
  #   MotionSupport::Inflector.deconstantize(self)
  # end

  # # Creates the name of a table like Rails does for models to table names. This method
  # # uses the +pluralize+ method on the last word in the string.
  # #
  # #   'RawScaledScorer'.tableize # => "raw_scaled_scorers"
  # #   'egg_and_ham'.tableize     # => "egg_and_hams"
  # #   'fancyCategory'.tableize   # => "fancy_categories"
  # def tableize
  #   MotionSupport::Inflector.tableize(self)
  # end

  # # Create a class name from a plural table name like Rails does for table names to models.
  # # Note that this returns a string and not a class. (To convert to an actual class
  # # follow +classify+ with +constantize+.)
  # #
  # #   'egg_and_hams'.classify # => "EggAndHam"
  # #   'posts'.classify        # => "Post"
  # #
  # # Singular names are not handled correctly.
  # #
  # #   'business'.classify # => "Busines"
  # def classify
  #   MotionSupport::Inflector.classify(self)
  # end

  # # Capitalizes the first word, turns underscores into spaces, and strips '_id'.
  # # Like +titleize+, this is meant for creating pretty output.
  # #
  # #   'employee_salary'.humanize # => "Employee salary"
  # #   'author_id'.humanize       # => "Author"
  # def humanize
  #   MotionSupport::Inflector.humanize(self)
  # end

  # # Creates a foreign key name from a class name.
  # # +separate_class_name_and_id_with_underscore+ sets whether
  # # the method should put '_' between the name and 'id'.
  # #
  # #   'Message'.foreign_key        # => "message_id"
  # #   'Message'.foreign_key(false) # => "messageid"
  # #   'Admin::Post'.foreign_key    # => "post_id"
  # def foreign_key(separate_class_name_and_id_with_underscore = true)
  #   MotionSupport::Inflector.foreign_key(self, separate_class_name_and_id_with_underscore)
  # end

  # alias_method :starts_with?, :start_with?
  # alias_method :ends_with?, :end_with?

  # # Strips indentation in heredocs.
  # #
  # # For example in
  # #
  # #   if options[:usage]
  # #     puts <<-USAGE.strip_heredoc
  # #       This command does such and such.
  # #
  # #       Supported options are:
  # #         -h         This message
  # #         ...
  # #     USAGE
  # #   end
  # #
  # # the user would see the usage message aligned against the left margin.
  # #
  # # Technically, it looks for the least indented line in the whole string, and removes
  # # that amount of leading whitespace.
  # def strip_heredoc
  #   indent = scan(/^[ \t]*(?=\S)/).min.try(:size) || 0
  #   gsub(/^[ \t]{#{indent}}/, '')
  # end
end
