module Kernel
  defined?(Object)

  # # class_eval on an object acts like singleton_class.class_eval.
  # def class_eval(*args, &block)
  #   singleton_class.class_eval(*args, &block)
  # end

  # def log(*args)
  #   MotionSupport.logger.log(*args)
  # end

  # def l(*args)
  #   MotionSupport.logger.log(args.map { |a| a.inspect })
  # end
end
