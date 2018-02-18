class Hash
  # # Returns a new hash with keys deleted if they match a criteria
  # #   h1 = { x: { y: [ { z: 4, y: 1 }, 5, 6] }, a: { b: 2 }  }
  # #
  # #   h1.deep_delete { |k,v| k == :z } #=> { x: { y: [ { y: 1 }, 5, 6] }, a: { b: 2 }  }
  # #   h1.deep_delete { |k,v| k == :y } #=> { x: {}, a: { b: 2 }  }
  # def deep_delete_if(&block)
  #   result = {}
  #   each do |key, value|
  #     next if block.call(key, value)

  #     result[key] = if value.is_a?(Hash)
  #       value.deep_delete_if(&block)
  #     elsif value.is_a?(Array)
  #       value.map { |v| v.is_a?(Hash) ? v.deep_delete_if(&block) : v }
  #     else
  #      value
  #     end
  #   end

  #   result
  # end

  # # Returns a new hash with +self+ and +other_hash+ merged recursively.
  # #
  # #   h1 = { x: { y: [4,5,6] }, z: [7,8,9] }
  # #   h2 = { x: { y: [7,8,9] }, z: 'xyz' }
  # #
  # #   h1.deep_merge(h2) #=> {x: {y: [7, 8, 9]}, z: "xyz"}
  # #   h2.deep_merge(h1) #=> {x: {y: [4, 5, 6]}, z: [7, 8, 9]}
  # #   h1.deep_merge(h2) { |key, old, new| Array.wrap(old) + Array.wrap(new) }
  # #   #=> {:x=>{:y=>[4, 5, 6, 7, 8, 9]}, :z=>[7, 8, 9, "xyz"]}
  # def deep_merge(other_hash, &block)
  #   dup.deep_merge!(other_hash, &block)
  # end

  # # Same as +deep_merge+, but modifies +self+.
  # def deep_merge!(other_hash, &block)
  #   other_hash.each_pair do |k,v|
  #     tv = self[k]
  #     if tv.is_a?(Hash) && v.is_a?(Hash)
  #       self[k] = tv.deep_merge(v, &block)
  #     else
  #       self[k] = block && tv ? block.call(k, tv, v) : v
  #     end
  #   end
  #   self
  # end

  # # Return a hash that includes everything but the given keys. This is useful for
  # # limiting a set of parameters to everything but a few known toggles:
  # #
  # #   @person.update(params[:person].except(:admin))
  # def except(*keys)
  #   dup.except!(*keys)
  # end

  # # Replaces the hash without the given keys.
  # def except!(*keys)
  #   keys.each { |key| delete(key) }
  #   self
  # end

  # # Returns an <tt>MotionSupport::HashWithIndifferentAccess</tt> out of its receiver:
  # #
  # #   { a: 1 }.with_indifferent_access['a'] # => 1
  # def with_indifferent_access
  #   MotionSupport::HashWithIndifferentAccess.new_from_hash_copying_default(self)
  # end

  # # Called when object is nested under an object that receives
  # # #with_indifferent_access. This method will be called on the current object
  # # by the enclosing object and is aliased to #with_indifferent_access by
  # # default. Subclasses of Hash may overwrite this method to return +self+ if
  # # converting to an <tt>MotionSupport::HashWithIndifferentAccess</tt> would not be
  # # desirable.
  # #
  # #   b = { b: 1 }
  # #   { a: b }.with_indifferent_access['a'] # calls b.nested_under_indifferent_access
  # alias nested_under_indifferent_access with_indifferent_access

  # # Return a new hash with all keys converted using the block operation.
  # #
  # #  hash = { name: 'Rob', age: '28' }
  # #
  # #  hash.transform_keys{ |key| key.to_s.upcase }
  # #  # => { "NAME" => "Rob", "AGE" => "28" }
  # def transform_keys
  #   result = {}
  #   each_key do |key|
  #     result[yield(key)] = self[key]
  #   end
  #   result
  # end

  # # Destructively convert all keys using the block operations.
  # # Same as transform_keys but modifies +self+.
  # def transform_keys!
  #   keys.each do |key|
  #     self[yield(key)] = delete(key)
  #   end
  #   self
  # end

  # # Return a new hash with all keys converted to strings.
  # #
  # #   hash = { name: 'Rob', age: '28' }
  # #
  # #   hash.stringify_keys
  # #   #=> { "name" => "Rob", "age" => "28" }
  # def stringify_keys
  #   transform_keys{ |key| key.to_s }
  # end

  # # Destructively convert all keys to strings. Same as
  # # +stringify_keys+, but modifies +self+.
  # def stringify_keys!
  #   transform_keys!{ |key| key.to_s }
  # end

  # # Return a new hash with all keys converted to symbols, as long as
  # # they respond to +to_sym+.
  # #
  # #   hash = { 'name' => 'Rob', 'age' => '28' }
  # #
  # #   hash.symbolize_keys
  # #   #=> { name: "Rob", age: "28" }
  # def symbolize_keys
  #   transform_keys{ |key| key.to_sym rescue key }
  # end
  # alias_method :to_options,  :symbolize_keys

  # # Destructively convert all keys to symbols, as long as they respond
  # # to +to_sym+. Same as +symbolize_keys+, but modifies +self+.
  # def symbolize_keys!
  #   transform_keys!{ |key| key.to_sym rescue key }
  # end
  # alias_method :to_options!, :symbolize_keys!

  # # Validate all keys in a hash match <tt>*valid_keys</tt>, raising ArgumentError
  # # on a mismatch. Note that keys are NOT treated indifferently, meaning if you
  # # use strings for keys but assert symbols as keys, this will fail.
  # #
  # #   { name: 'Rob', years: '28' }.assert_valid_keys(:name, :age) # => raises "ArgumentError: Unknown key: years"
  # #   { name: 'Rob', age: '28' }.assert_valid_keys('name', 'age') # => raises "ArgumentError: Unknown key: name"
  # #   { name: 'Rob', age: '28' }.assert_valid_keys(:name, :age)   # => passes, raises nothing
  # def assert_valid_keys(*valid_keys)
  #   valid_keys.flatten!
  #   each_key do |k|
  #     raise ArgumentError.new("Unknown key: #{k}") unless valid_keys.include?(k)
  #   end
  # end

  # # Return a new hash with all keys converted by the block operation.
  # # This includes the keys from the root hash and from all
  # # nested hashes.
  # #
  # #  hash = { person: { name: 'Rob', age: '28' } }
  # #
  # #  hash.deep_transform_keys{ |key| key.to_s.upcase }
  # #  # => { "PERSON" => { "NAME" => "Rob", "AGE" => "28" } }
  # def deep_transform_keys(&block)
  #   result = {}
  #   each do |key, value|
  #     result[yield(key)] = if value.is_a?(Hash)
  #       value.deep_transform_keys(&block)
  #     elsif value.is_a?(Array)
  #       value.map { |v| v.is_a?(Hash) ? v.deep_transform_keys(&block) : v }
  #     else
  #      value
  #     end
  #   end
  #   result
  # end

  # # Destructively convert all keys by using the block operation.
  # # This includes the keys from the root hash and from all
  # # nested hashes.
  # def deep_transform_keys!(&block)
  #   keys.each do |key|
  #     value = delete(key)
  #     self[yield(key)] = if value.is_a?(Hash)
  #       value.deep_transform_keys(&block)
  #     elsif value.is_a?(Array)
  #       value.map { |v| v.is_a?(Hash) ? v.deep_transform_keys(&block) : v }
  #     else
  #      value
  #     end
  #   end
  #   self
  # end

  # # Return a new hash with all keys converted to strings.
  # # This includes the keys from the root hash and from all
  # # nested hashes.
  # #
  # #   hash = { person: { name: 'Rob', age: '28' } }
  # #
  # #   hash.deep_stringify_keys
  # #   # => { "person" => { "name" => "Rob", "age" => "28" } }
  # def deep_stringify_keys
  #   deep_transform_keys{ |key| key.to_s }
  # end

  # # Destructively convert all keys to strings.
  # # This includes the keys from the root hash and from all
  # # nested hashes.
  # def deep_stringify_keys!
  #   deep_transform_keys!{ |key| key.to_s }
  # end

  # # Return a new hash with all keys converted to symbols, as long as
  # # they respond to +to_sym+. This includes the keys from the root hash
  # # and from all nested hashes.
  # #
  # #   hash = { 'person' => { 'name' => 'Rob', 'age' => '28' } }
  # #
  # #   hash.deep_symbolize_keys
  # #   # => { person: { name: "Rob", age: "28" } }
  # def deep_symbolize_keys
  #   deep_transform_keys{ |key| key.to_sym rescue key }
  # end

  # # Destructively convert all keys to symbols, as long as they respond
  # # to +to_sym+. This includes the keys from the root hash and from all
  # # nested hashes.
  # def deep_symbolize_keys!
  #   deep_transform_keys!{ |key| key.to_sym rescue key }
  # end

  # # Merges the caller into +other_hash+. For example,
  # #
  # #   options = options.reverse_merge(size: 25, velocity: 10)
  # #
  # # is equivalent to
  # #
  # #   options = { size: 25, velocity: 10 }.merge(options)
  # #
  # # This is particularly useful for initializing an options hash
  # # with default values.
  # def reverse_merge(other_hash)
  #   other_hash.merge(self)
  # end

  # # Destructive +reverse_merge+.
  # def reverse_merge!(other_hash)
  #   # right wins if there is no left
  #   merge!( other_hash ){|key,left,right| left }
  # end
  # alias_method :reverse_update, :reverse_merge!

  # # Slice a hash to include only the given keys. This is useful for
  # # limiting an options hash to valid keys before passing to a method:
  # #
  # #   def search(criteria = {})
  # #     criteria.assert_valid_keys(:mass, :velocity, :time)
  # #   end
  # #
  # #   search(options.slice(:mass, :velocity, :time))
  # #
  # # If you have an array of keys you want to limit to, you should splat them:
  # #
  # #   valid_keys = [:mass, :velocity, :time]
  # #   search(options.slice(*valid_keys))
  # def slice(*keys)
  #   keys.map! { |key| convert_key(key) } if respond_to?(:convert_key, true)
  #   keys.each_with_object(self.class.new) { |k, hash| hash[k] = self[k] if has_key?(k) }
  # end

  # # Replaces the hash with only the given keys.
  # # Returns a hash containing the removed key/value pairs.
  # #
  # #   { a: 1, b: 2, c: 3, d: 4 }.slice!(:a, :b)
  # #   # => {:c=>3, :d=>4}
  # def slice!(*keys)
  #   keys.map! { |key| convert_key(key) } if respond_to?(:convert_key, true)
  #   omit = slice(*self.keys - keys)
  #   hash = slice(*keys)
  #   replace(hash)
  #   omit
  # end

  # # Removes and returns the key/value pairs matching the given keys.
  # #
  # #   { a: 1, b: 2, c: 3, d: 4 }.extract!(:a, :b) # => {:a=>1, :b=>2}
  # #   { a: 1, b: 2 }.extract!(:a, :x)             # => {:a=>1}
  # def extract!(*keys)
  #   keys.each_with_object(self.class.new) { |key, result| result[key] = delete(key) if has_key?(key) }
  # end
end
