class Class
  defined?(Module)
  # # Declare a class-level attribute whose value is inheritable by subclasses.
  # # Subclasses can change their own value and it will not impact parent class.
  # #
  # #   class Base
  # #     class_attribute :setting
  # #   end
  # #
  # #   class Subclass < Base
  # #   end
  # #
  # #   Base.setting = true
  # #   Subclass.setting            # => true
  # #   Subclass.setting = false
  # #   Subclass.setting            # => false
  # #   Base.setting                # => true
  # #
  # # In the above case as long as Subclass does not assign a value to setting
  # # by performing <tt>Subclass.setting = _something_ </tt>, <tt>Subclass.setting</tt>
  # # would read value assigned to parent class. Once Subclass assigns a value then
  # # the value assigned by Subclass would be returned.
  # #
  # # This matches normal Ruby method inheritance: think of writing an attribute
  # # on a subclass as overriding the reader method. However, you need to be aware
  # # when using +class_attribute+ with mutable structures as +Array+ or +Hash+.
  # # In such cases, you don't want to do changes in places but use setters:
  # #
  # #   Base.setting = []
  # #   Base.setting                # => []
  # #   Subclass.setting            # => []
  # #
  # #   # Appending in child changes both parent and child because it is the same object:
  # #   Subclass.setting << :foo
  # #   Base.setting               # => [:foo]
  # #   Subclass.setting           # => [:foo]
  # #
  # #   # Use setters to not propagate changes:
  # #   Base.setting = []
  # #   Subclass.setting += [:foo]
  # #   Base.setting               # => []
  # #   Subclass.setting           # => [:foo]
  # #
  # # For convenience, a query method is defined as well:
  # #
  # #   Subclass.setting?       # => false
  # #
  # # Instances may overwrite the class value in the same way:
  # #
  # #   Base.setting = true
  # #   object = Base.new
  # #   object.setting          # => true
  # #   object.setting = false
  # #   object.setting          # => false
  # #   Base.setting            # => true
  # #
  # # To opt out of the instance reader method, pass <tt>instance_reader: false</tt>.
  # #
  # #   object.setting          # => NoMethodError
  # #   object.setting?         # => NoMethodError
  # #
  # # To opt out of the instance writer method, pass <tt>instance_writer: false</tt>.
  # #
  # #   object.setting = false  # => NoMethodError
  # #
  # # To opt out of both instance methods, pass <tt>instance_accessor: false</tt>.
  def class_attribute(*attrs)
    options = attrs.extract_options!
    # double assignment is used to avoid "assigned but unused variable" warning
    instance_reader = instance_reader = options.fetch(:instance_accessor, true) && options.fetch(:instance_reader, true)
    instance_writer = options.fetch(:instance_accessor, true) && options.fetch(:instance_writer, true)

    attrs.each do |name|
      define_singleton_method(name) { nil }
      define_singleton_method("#{name}?") { !!public_send(name) }

      ivar = "@#{name}"

      define_singleton_method("#{name}=") do |val|
        singleton_class.class_eval do
          remove_possible_method(name)
          define_method(name) { val }
        end

        if singleton_class?
          class_eval do
            remove_possible_method(name)
            define_method(name) do
              if instance_variable_defined? ivar
                instance_variable_get ivar
              else
                singleton_class.send name
              end
            end
          end
        end
        val
      end

      if instance_reader
        remove_possible_method name
        define_method(name) do
          if instance_variable_defined?(ivar)
            instance_variable_get ivar
          else
            self.class.public_send name
          end
        end
        define_method("#{name}?") { !!public_send(name) }
      end

      attr_writer name if instance_writer
    end
  end

  def singleton_class?
    ancestors.first != self
  end

  # # Defines a class attribute if it's not defined and creates a reader method that
  # # returns the attribute value.
  # #
  # #   class Person
  # #     cattr_reader :hair_colors
  # #   end
  # #
  # #   Person.class_variable_set("@@hair_colors", [:brown, :black])
  # #   Person.hair_colors     # => [:brown, :black]
  # #   Person.new.hair_colors # => [:brown, :black]
  # #
  # # The attribute name must be a valid method name in Ruby.
  # #
  # #   class Person
  # #     cattr_reader :"1_Badname "
  # #   end
  # #   # => NameError: invalid attribute name
  # #
  # # If you want to opt out the instance reader method, you can pass <tt>instance_reader: false</tt>
  # # or <tt>instance_accessor: false</tt>.
  # #
  # #   class Person
  # #     cattr_reader :hair_colors, instance_reader: false
  # #   end
  # #
  # #   Person.new.hair_colors # => NoMethodError
  def cattr_reader(*syms)
    options = syms.extract_options!
    syms.each do |sym|
      raise NameError.new('invalid attribute name') unless sym =~ /^[_A-Za-z]\w*$/
      class_exec do
        unless class_variable_defined?("@@#{sym}")
          class_variable_set("@@#{sym}", nil)
        end

        define_singleton_method sym do
          class_variable_get("@@#{sym}")
        end
      end

      unless options[:instance_reader] == false || options[:instance_accessor] == false
        class_exec do
          define_method sym do
            self.class.class_variable_get("@@#{sym}")
          end
        end
      end
    end
  end

  # # Defines a class attribute if it's not defined and creates a writer method to allow
  # # assignment to the attribute.
  # #
  # #   class Person
  # #     cattr_writer :hair_colors
  # #   end
  # #
  # #   Person.hair_colors = [:brown, :black]
  # #   Person.class_variable_get("@@hair_colors") # => [:brown, :black]
  # #   Person.new.hair_colors = [:blonde, :red]
  # #   Person.class_variable_get("@@hair_colors") # => [:blonde, :red]
  # #
  # # The attribute name must be a valid method name in Ruby.
  # #
  # #   class Person
  # #     cattr_writer :"1_Badname "
  # #   end
  # #   # => NameError: invalid attribute name
  # #
  # # If you want to opt out the instance writer method, pass <tt>instance_writer: false</tt>
  # # or <tt>instance_accessor: false</tt>.
  # #
  # #   class Person
  # #     cattr_writer :hair_colors, instance_writer: false
  # #   end
  # #
  # #   Person.new.hair_colors = [:blonde, :red] # => NoMethodError
  # #
  # # Also, you can pass a block to set up the attribute with a default value.
  # #
  # #   class Person
  # #     cattr_writer :hair_colors do
  # #       [:brown, :black, :blonde, :red]
  # #     end
  # #   end
  # #
  # #   Person.class_variable_get("@@hair_colors") # => [:brown, :black, :blonde, :red]
  def cattr_writer(*syms)
    options = syms.extract_options!
    syms.each do |sym|
      raise NameError.new('invalid attribute name') unless sym =~ /^[_A-Za-z]\w*$/
      class_exec do
        unless class_variable_defined?("@@#{sym}")
          class_variable_set("@@#{sym}", nil)
        end

        define_singleton_method "#{sym}=" do |obj|
          class_variable_set("@@#{sym}", obj)
        end
      end

      unless options[:instance_writer] == false || options[:instance_accessor] == false
        class_exec do
          define_method "#{sym}=" do |obj|
            self.class.class_variable_set("@@#{sym}", obj)
          end
        end
      end
      send("#{sym}=", yield) if block_given?
    end
  end

  # # Defines both class and instance accessors for class attributes.
  # #
  # #   class Person
  # #     cattr_accessor :hair_colors
  # #   end
  # #
  # #   Person.hair_colors = [:brown, :black, :blonde, :red]
  # #   Person.hair_colors     # => [:brown, :black, :blonde, :red]
  # #   Person.new.hair_colors # => [:brown, :black, :blonde, :red]
  # #
  # # If a subclass changes the value then that would also change the value for
  # # parent class. Similarly if parent class changes the value then that would
  # # change the value of subclasses too.
  # #
  # #   class Male < Person
  # #   end
  # #
  # #   Male.hair_colors << :blue
  # #   Person.hair_colors # => [:brown, :black, :blonde, :red, :blue]
  # #
  # # To opt out of the instance writer method, pass <tt>instance_writer: false</tt>.
  # # To opt out of the instance reader method, pass <tt>instance_reader: false</tt>.
  # #
  # #   class Person
  # #     cattr_accessor :hair_colors, instance_writer: false, instance_reader: false
  # #   end
  # #
  # #   Person.new.hair_colors = [:brown]  # => NoMethodError
  # #   Person.new.hair_colors             # => NoMethodError
  # #
  # # Or pass <tt>instance_accessor: false</tt>, to opt out both instance methods.
  # #
  # #   class Person
  # #     cattr_accessor :hair_colors, instance_accessor: false
  # #   end
  # #
  # #   Person.new.hair_colors = [:brown]  # => NoMethodError
  # #   Person.new.hair_colors             # => NoMethodError
  # #
  # # Also you can pass a block to set up the attribute with a default value.
  # #
  # #   class Person
  # #     cattr_accessor :hair_colors do
  # #       [:brown, :black, :blonde, :red]
  # #     end
  # #   end
  # #
  # #   Person.class_variable_get("@@hair_colors") #=> [:brown, :black, :blonde, :red]
  def cattr_accessor(*syms, &blk)
    cattr_reader(*syms)
    cattr_writer(*syms, &blk)
  end
end
