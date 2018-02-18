class Range #:nodoc:
  defined?(Enumerable)
  # # Optimize range sum to use arithmetic progression if a block is not given and
  # # we have a range of numeric values.
  # def sum(identity = 0)
  #   if block_given? || !(first.is_a?(Integer) && last.is_a?(Integer))
  #     super
  #   else
  #     actual_last = exclude_end? ? (last - 1) : last
  #     if actual_last >= first
  #       (actual_last - first + 1) * (actual_last + first) / 2
  #     else
  #       identity
  #     end
  #   end
  # end

  # # Extends the default Range#include? to support range comparisons.
  # #  (1..5).include?(1..5) # => true
  # #  (1..5).include?(2..3) # => true
  # #  (1..5).include?(2..6) # => false
  # #
  # # The native Range#include? behavior is untouched.
  # #  ('a'..'f').include?('c') # => true
  # #  (5..9).include?(11) # => false
  # def include_with_range?(value)
  #   if value.is_a?(::Range)
  #     # 1...10 includes 1..9 but it does not include 1..10.
  #     operator = exclude_end? && !value.exclude_end? ? :< : :<=
  #     include_without_range?(value.first) && value.last.send(operator, last)
  #   else
  #     include_without_range?(value)
  #   end
  # end

  # alias_method_chain :include?, :range

  # # Compare two ranges and see if they overlap each other
  # #  (1..5).overlaps?(4..6) # => true
  # #  (1..5).overlaps?(7..9) # => false
  # def overlaps?(other)
  #   cover?(other.first) || other.cover?(first)
  # end
end
