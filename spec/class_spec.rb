class CAttrAccessorBase
  cattr_accessor :empty_accessor
  cattr_accessor :base_accessor, :derived_accessor
end

class CAttrAccessorDerived < CAttrAccessorBase
end

describe "class" do
  describe "attribute accessors" do
    before do
      @class = Class.new
      @class.instance_eval do
        cattr_accessor :foo
        cattr_accessor :bar, :instance_writer => false
        cattr_reader   :shaq, :instance_reader => false
        cattr_accessor :camp, :instance_accessor => false
      end
      @object = @class.new
    end

    describe "reader" do
      it "should return nil by default" do
        @class.foo.should.be.nil
      end
    end

    describe "writer" do
      it "should set value" do
        @class.foo = :test
        @class.foo.should == :test
      end

      it "should set value through instance writer" do
        @object.foo = :bar
        @object.foo.should == :bar
      end

      it "should set instance reader's value through module's writer" do
        @class.foo = :test
        @object.foo.should == :test
      end

      it "should set module reader's value through instances's writer" do
        @object.foo = :bar
        @class.foo.should == :bar
      end
    end

    describe "instance_writer => false" do
      it "should not create instance writer" do
        @class.should.respond_to :foo
        @class.should.respond_to :foo=
        @object.should.respond_to :bar
        @object.should.not.respond_to :bar=
      end
    end

    describe "instance_reader => false" do
      it "should not create instance reader" do
        @class.should.respond_to :shaq
        @object.should.not.respond_to :shaq
      end
    end

    describe "instance_accessor => false" do
      it "should not create reader or writer" do
        @class.should.respond_to :camp
        @object.should.not.respond_to :camp
        @object.should.not.respond_to :camp=
      end
    end
  end

  describe "invalid attribute accessors" do
    it "should raise NameError when creating an invalid reader" do
      lambda do
        Class.new do
          cattr_reader "invalid attribute name"
        end
      end.should.raise NameError
    end

    it "should raise NameError when creating an invalid writer" do
      lambda do
        Class.new do
          cattr_writer "invalid attribute name"
        end
      end.should.raise NameError
    end
  end

  describe "inheritance" do
    it "should be accessible in the base class and the derived class" do
      CAttrAccessorBase.respond_to?(:empty_accessor).should == true
      CAttrAccessorDerived.respond_to?(:empty_accessor).should == true
    end

    it "should return nil for an unset accessor in the base class" do
      CAttrAccessorBase.empty_accessor.should == nil
    end

    it "should return nil for an unset accessor in the derived class" do
      CAttrAccessorDerived.empty_accessor.should == nil
    end

    it "should return a value for an accessor set in the base class in the base class" do
      CAttrAccessorBase.base_accessor = 10
      CAttrAccessorBase.base_accessor.should == 10
    end

    it "should return a value for an accessor set in the base class in the derived class" do
      CAttrAccessorBase.base_accessor = 10
      CAttrAccessorDerived.base_accessor.should == 10
    end

    it "should return a value for the base class if set for the derived class" do
      CAttrAccessorDerived.derived_accessor = 20
      CAttrAccessorBase.derived_accessor.should == 20
    end

    it "should return a value for an accessor set in the derived class in the derived class" do
      CAttrAccessorDerived.derived_accessor = 20
      CAttrAccessorDerived.derived_accessor.should == 20
    end
  end
end

describe "class" do
  describe "class_attribute" do
    before do
      @klass = Class.new
      @klass.class_eval { class_attribute :setting }
      @sub = Class.new(@klass)
    end

    it "should default to nil" do
      @klass.setting.should.be.nil
      @sub.setting.should.be.nil
    end

    it "should be inheritable" do
      @klass.setting = 1
      @sub.setting.should == 1
    end

    it "should be overridable" do
      @sub.setting = 1
      @klass.setting.should.be.nil

      @klass.setting = 2
      @sub.setting.should == 1

      Class.new(@sub).setting.should == 1
    end

    it "should define a query method" do
      @klass.setting?.should.be.false
      @klass.setting = 1
      @klass.setting?.should.be.true
    end

    it "should define an instance reader that delegates to class" do
      @klass.new.setting.should.be.nil

      @klass.setting = 1
      @klass.new.setting.should == 1
    end

    it "should allow to override per instance" do
      object = @klass.new
      object.setting = 1
      @klass.setting.should == nil
      @klass.setting = 2
      object.setting.should == 1
    end

    it "should define query method on instance" do
      object = @klass.new
      object.setting?.should.be.false
      object.setting = 1
      object.setting?.should.be.true
    end

    describe "instance_writer => false" do
      it "should not create instance writer" do
        object = Class.new { class_attribute :setting, :instance_writer => false }.new
        lambda { object.setting = 'boom' }.should.raise NoMethodError
      end
    end

    describe "instance_reader => false" do
      it "should not create instance reader" do
        object = Class.new { class_attribute :setting, :instance_reader => false }.new
        lambda { object.setting }.should.raise NoMethodError
        lambda { object.setting? }.should.raise NoMethodError
      end
    end

    describe "instance_accessor => false" do
      it "should not create reader or writer" do
        object = Class.new { class_attribute :setting, :instance_accessor => false }.new
        lambda { object.setting }.should.raise NoMethodError
        lambda { object.setting? }.should.raise NoMethodError
        lambda { object.setting = 'boom' }.should.raise NoMethodError
      end
    end

    it "should work well with singleton classes" do
      object = @klass.new
      object.singleton_class.setting = 'foo'
      object.setting.should == "foo"
    end

    it "should return set value through setter" do
      val = @klass.send(:setting=, 1)
      val.should == 1
    end
  end
end
