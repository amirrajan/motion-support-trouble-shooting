class Module
  defined?(Object)

  # # Encapsulates the common pattern of:
  # #
  # #   alias_method :foo_without_feature, :foo
  # #   alias_method :foo, :foo_with_feature
  # #
  # # With this, you simply do:
  # #
  # #   alias_method_chain :foo, :feature
  # #
  # # And both aliases are set up for you.
  # #
  # # Query and bang methods (foo?, foo!) keep the same punctuation:
  # #
  # #   alias_method_chain :foo?, :feature
  # #
  # # is equivalent to
  # #
  # #   alias_method :foo_without_feature?, :foo?
  # #   alias_method :foo?, :foo_with_feature?
  # #
  # # so you can safely chain foo, foo?, and foo! with the same feature.
  # def alias_method_chain(target, feature)
  #   # Strip out punctuation on predicates or bang methods since
  #   # e.g. target?_without_feature is not a valid method name.
  #   aliased_target, punctuation = target.to_s.sub(/([?!=])$/, ''), $1
  #   yield(aliased_target, punctuation) if block_given?

  #   with_method = "#{aliased_target}_with_#{feature}#{punctuation}"
  #   without_method = "#{aliased_target}_without_#{feature}#{punctuation}"

  #   alias_method without_method, target
  #   alias_method target, with_method

  #   case
  #   when public_method_defined?(without_method)
  #     public target
  #   when protected_method_defined?(without_method)
  #     protected target
  #   when private_method_defined?(without_method)
  #     private target
  #   end
  # end

  # # Allows you to make aliases for attributes, which includes
  # # getter, setter, and query methods.
  # #
  # #   class Content < ActiveRecord::Base
  # #     # has a title attribute
  # #   end
  # #
  # #   class Email < Content
  # #     alias_attribute :subject, :title
  # #   end
  # #
  # #   e = Email.find(1)
  # #   e.title    # => "Superstars"
  # #   e.subject  # => "Superstars"
  # #   e.subject? # => true
  # #   e.subject = "Megastars"
  # #   e.title    # => "Megastars"
  # def alias_attribute(new_name, old_name)
  #   module_exec do
  #     define_method(new_name) { self.send(old_name) }          # def subject; self.title; end
  #     define_method("#{new_name}?") { self.send("#{old_name}?") }        # def subject?; self.title?; end
  #     define_method("#{new_name}=") { |v| self.send("#{old_name}=", v) }  # def subject=(v); self.title = v; end
  #   end
  # end

  # # A module may or may not have a name.
  # #
  # #   module M; end
  # #   M.name # => "M"
  # #
  # #   m = Module.new
  # #   m.name # => nil
  # #
  # # A module gets a name when it is first assigned to a constant. Either
  # # via the +module+ or +class+ keyword or by an explicit assignment:
  # #
  # #   m = Module.new # creates an anonymous module
  # #   M = m          # => m gets a name here as a side-effect
  # #   m.name         # => "M"
  # def anonymous?
  #   name.nil?
  # end

  # # Declares an attribute reader backed by an internally-named instance variable.
  # def attr_internal_reader(*attrs)
  #   attrs.each {|attr_name| attr_internal_define(attr_name, :reader)}
  # end

  # # Declares an attribute writer backed by an internally-named instance variable.
  # def attr_internal_writer(*attrs)
  #   attrs.each {|attr_name| attr_internal_define(attr_name, :writer)}
  # end

  # # Declares an attribute reader and writer backed by an internally-named instance
  # # variable.
  # def attr_internal_accessor(*attrs)
  #   attr_internal_reader(*attrs)
  #   attr_internal_writer(*attrs)
  # end
  # alias_method :attr_internal, :attr_internal_accessor

  # class << self; attr_accessor :attr_internal_naming_format end
  # self.attr_internal_naming_format = '@_%s'

  # private
  #   def attr_internal_ivar_name(attr)
  #     Module.attr_internal_naming_format % attr
  #   end

  #   def attr_internal_define(attr_name, type)
  #     internal_name = attr_internal_ivar_name(attr_name).sub(/\A@/, '')
  #     class_eval do # class_eval is necessary on 1.9 or else the methods a made private
  #       # use native attr_* methods as they are faster on some Ruby implementations
  #       send("attr_#{type}", internal_name)
  #     end
  #     attr_name, internal_name = "#{attr_name}=", "#{internal_name}=" if type == :writer
  #     alias_method attr_name, internal_name
  #     remove_method internal_name
  #   end

  # def mattr_reader(*syms)
  #   receiver = self
  #   options = syms.extract_options!
  #   syms.each do |sym|
  #     raise NameError.new('invalid attribute name') unless sym =~ /^[_A-Za-z]\w*$/
  #     class_exec do
  #       unless class_variable_defined?("@@#{sym}")
  #         class_variable_set("@@#{sym}", nil)
  #       end

  #       define_singleton_method sym do
  #         class_variable_get("@@#{sym}")
  #       end
  #     end

  #     unless options[:instance_reader] == false || options[:instance_accessor] == false
  #       class_exec do
  #         define_method sym do
  #           receiver.class_variable_get("@@#{sym}")
  #         end
  #       end
  #     end
  #   end
  # end

  # def mattr_writer(*syms)
  #   receiver = self
  #   options = syms.extract_options!
  #   syms.each do |sym|
  #     raise NameError.new('invalid attribute name') unless sym =~ /^[_A-Za-z]\w*$/
  #     class_exec do
  #       define_singleton_method "#{sym}=" do |obj|
  #         class_variable_set("@@#{sym}", obj)
  #       end
  #     end

  #     unless options[:instance_writer] == false || options[:instance_accessor] == false
  #       class_exec do
  #         define_method "#{sym}=" do |obj|
  #           receiver.class_variable_set("@@#{sym}", obj)
  #         end
  #       end
  #     end
  #   end
  # end

  # # Extends the module object with module and instance accessors for class attributes,
  # # just like the native attr* accessors for instance attributes.
  # #
  # #   module AppConfiguration
  # #     mattr_accessor :google_api_key
  # #
  # #     self.google_api_key = "123456789"
  # #   end
  # #
  # #   AppConfiguration.google_api_key # => "123456789"
  # #   AppConfiguration.google_api_key = "overriding the api key!"
  # #   AppConfiguration.google_api_key # => "overriding the api key!"
  # def mattr_accessor(*syms)
  #   mattr_reader(*syms)
  #   mattr_writer(*syms)
  # end

  # # Provides a delegate class method to easily expose contained objects' public methods
  # # as your own. Pass one or more methods (specified as symbols or strings)
  # # and the name of the target object via the <tt>:to</tt> option (also a symbol
  # # or string). At least one method and the <tt>:to</tt> option are required.
  # #
  # # Delegation is particularly useful with Active Record associations:
  # #
  # #   class Greeter < ActiveRecord::Base
  # #     def hello
  # #       'hello'
  # #     end
  # #
  # #     def goodbye
  # #       'goodbye'
  # #     end
  # #   end
  # #
  # #   class Foo < ActiveRecord::Base
  # #     belongs_to :greeter
  # #     delegate :hello, to: :greeter
  # #   end
  # #
  # #   Foo.new.hello   # => "hello"
  # #   Foo.new.goodbye # => NoMethodError: undefined method `goodbye' for #<Foo:0x1af30c>
  # #
  # # Multiple delegates to the same target are allowed:
  # #
  # #   class Foo < ActiveRecord::Base
  # #     belongs_to :greeter
  # #     delegate :hello, :goodbye, to: :greeter
  # #   end
  # #
  # #   Foo.new.goodbye # => "goodbye"
  # #
  # # Methods can be delegated to instance variables, class variables, or constants
  # # by providing them as a symbols:
  # #
  # #   class Foo
  # #     CONSTANT_ARRAY = [0,1,2,3]
  # #     @@class_array  = [4,5,6,7]
  # #
  # #     def initialize
  # #       @instance_array = [8,9,10,11]
  # #     end
  # #     delegate :sum, to: :CONSTANT_ARRAY
  # #     delegate :min, to: :@@class_array
  # #     delegate :max, to: :@instance_array
  # #   end
  # #
  # #   Foo.new.sum # => 6
  # #   Foo.new.min # => 4
  # #   Foo.new.max # => 11
  # #
  # # It's also possible to delegate a method to the class by using +:class+:
  # #
  # #   class Foo
  # #     def self.hello
  # #       "world"
  # #     end
  # #
  # #     delegate :hello, to: :class
  # #   end
  # #
  # #   Foo.new.hello # => "world"
  # #
  # # Delegates can optionally be prefixed using the <tt>:prefix</tt> option. If the value
  # # is <tt>true</tt>, the delegate methods are prefixed with the name of the object being
  # # delegated to.
  # #
  # #   Person = Struct.new(:name, :address)
  # #
  # #   class Invoice < Struct.new(:client)
  # #     delegate :name, :address, to: :client, prefix: true
  # #   end
  # #
  # #   john_doe = Person.new('John Doe', 'Vimmersvej 13')
  # #   invoice = Invoice.new(john_doe)
  # #   invoice.client_name    # => "John Doe"
  # #   invoice.client_address # => "Vimmersvej 13"
  # #
  # # It is also possible to supply a custom prefix.
  # #
  # #   class Invoice < Struct.new(:client)
  # #     delegate :name, :address, to: :client, prefix: :customer
  # #   end
  # #
  # #   invoice = Invoice.new(john_doe)
  # #   invoice.customer_name    # => 'John Doe'
  # #   invoice.customer_address # => 'Vimmersvej 13'
  # #
  # # If the delegate object is +nil+ an exception is raised, and that happens
  # # no matter whether +nil+ responds to the delegated method. You can get a
  # # +nil+ instead with the +:allow_nil+ option.
  # #
  # #   class Foo
  # #     attr_accessor :bar
  # #     def initialize(bar = nil)
  # #       @bar = bar
  # #     end
  # #     delegate :zoo, to: :bar
  # #   end
  # #
  # #   Foo.new.zoo   # raises NoMethodError exception (you called nil.zoo)
  # #
  # #   class Foo
  # #     attr_accessor :bar
  # #     def initialize(bar = nil)
  # #       @bar = bar
  # #     end
  # #     delegate :zoo, to: :bar, allow_nil: true
  # #   end
  # #
  # #   Foo.new.zoo   # returns nil
  # def delegate(*methods)
  #   options = methods.pop
  #   unless options.is_a?(Hash) && to = options[:to]
  #     raise ArgumentError, 'Delegation needs a target. Supply an options hash with a :to key as the last argument (e.g. delegate :hello, to: :greeter).'
  #   end

  #   prefix, allow_nil = options.values_at(:prefix, :allow_nil)
  #   unguarded = !allow_nil

  #   if prefix == true && to =~ /^[^a-z_]/
  #     raise ArgumentError, 'Can only automatically set the delegation prefix when delegating to a method.'
  #   end

  #   method_prefix = \
  #     if prefix
  #       "#{prefix == true ? to : prefix}_"
  #     else
  #       ''
  #     end

  #   reference, *hierarchy = to.to_s.split('.')
  #   entry = resolver =
  #     case reference
  #     when 'self'
  #       ->(_self) { _self }
  #     when /^@@/
  #       ->(_self) { _self.class.class_variable_get(reference) }
  #     when /^@/
  #       ->(_self) { _self.instance_variable_get(reference) }
  #     when /^[A-Z]/
  #       ->(_self) { if reference.to_s =~ /::/ then reference.constantize else _self.class.const_get(reference) end }
  #     else
  #       ->(_self) { _self.send(reference) }
  #     end
  #   resolver = ->(_self) { hierarchy.reduce(entry.call(_self)) { |obj, method| obj.public_send(method) } } unless hierarchy.empty?

  #   methods.each do |method|
  #     module_exec do
  #       # def customer_name(*args, &block)
  #       #   begin
  #       #     if unguarded || client || client.respond_to?(:name)
  #       #       client.name(*args, &block)
  #       #     end
  #       #   rescue client.nil? && NoMethodError
  #       #     raise "..."
  #       #   end
  #       # end
  #       define_method("#{method_prefix}#{method}") do |*args, &block|
  #         target = resolver.call(self)
  #         if unguarded || target || target.respond_to?(method)
  #           begin
  #             target.public_send(method, *args, &block)
  #           rescue target.nil? && NoMethodError # only rescue NoMethodError when target is nil
  #             raise "#{self}##{method_prefix}#{method} delegated to #{to}.#{method}, but #{to} is nil: #{self.inspect}"
  #           end
  #         end
  #       end
  #     end
  #   end
  # end

  # # Returns the name of the module containing this one.
  # #
  # #   M::N.parent_name # => "M"
  # def parent_name
  #   if defined? @parent_name
  #     @parent_name
  #   else
  #     @parent_name = name =~ /::[^:]+\Z/ ? $`.freeze : nil
  #   end
  # end

  # # Returns the module which contains this one according to its name.
  # #
  # #   module M
  # #     module N
  # #     end
  # #   end
  # #   X = M::N
  # #
  # #   M::N.parent # => M
  # #   X.parent    # => M
  # #
  # # The parent of top-level and anonymous modules is Object.
  # #
  # #   M.parent          # => Object
  # #   Module.new.parent # => Object
  # def parent
  #   parent_name ? parent_name.constantize : Object
  # end

  # # Returns all the parents of this module according to its name, ordered from
  # # nested outwards. The receiver is not contained within the result.
  # #
  # #   module M
  # #     module N
  # #     end
  # #   end
  # #   X = M::N
  # #
  # #   M.parents    # => [Object]
  # #   M::N.parents # => [M, Object]
  # #   X.parents    # => [M, Object]
  # def parents
  #   parents = []
  #   if parent_name
  #     parts = parent_name.split('::')
  #     until parts.empty?
  #       parents << (parts * '::').constantize
  #       parts.pop
  #     end
  #   end
  #   parents << Object unless parents.include? Object
  #   parents
  # end

  # def local_constants #:nodoc:
  #   constants(false)
  # end

  # def reachable? #:nodoc:
  #   !anonymous? && name.safe_constantize.equal?(self)
  # end

  def remove_possible_method(method)
    if method_defined?(method) || private_method_defined?(method)
      undef_method(method)
    end
  end

  def redefine_method(method, &block)
    remove_possible_method(method)
    define_method(method, &block)
  end
end
