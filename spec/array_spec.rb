describe 'array' do
  it 'finds hash values' do
    array_of_hashes = [
      {
        line1: 3,
        line2: 5
      },
      {
        line3: 7,
        line4: 9
      }
    ]
    array_of_hashes.has_hash_value?(5).should.be.true
    array_of_hashes.has_hash_value?(4).should.not.be.true
  end
end

describe 'array access' do
  describe "from" do
    it "should return the tail of an array from position" do
      ['a', 'b', 'c', 'd'].from(0).should == ["a", "b", "c", "d"]
      ['a', 'b', 'c', 'd'].from(2).should == ["c", "d"]
      ['a', 'b', 'c', 'd'].from(10).should == []
      [].from(0).should == []
    end
  end

  describe "to" do
    it "should return the head of an array up to position" do
      ['a', 'b', 'c', 'd'].to(0).should == ["a"]
      ['a', 'b', 'c', 'd'].to(2).should == ["a", "b", "c"]
      ['a', 'b', 'c', 'd'].to(10).should == ["a", "b", "c", "d"]
      [].to(0).should == []
    end
  end

  describe "second" do
    it "should return the second element in an array" do
      ['a', 'b', 'c', 'd'].second.should == 'b'
    end

    it "should return nil if there is no second element" do
      [].second.should == nil
    end
  end
end

describe 'array' do
  describe "to_sentence" do
    it "should convert plain array" do
      [].to_sentence.should == ""
      ['one'].to_sentence.should == "one"
      ['one', 'two'].to_sentence.should == "one and two"
      ['one', 'two', 'three'].to_sentence.should == "one, two, and three"
    end

    it "should convert sentence with words connector" do
      ['one', 'two', 'three'].to_sentence(:words_connector => ' ').should == "one two, and three"
      ['one', 'two', 'three'].to_sentence(:words_connector => ' & ').should == "one & two, and three"
      ['one', 'two', 'three'].to_sentence(:words_connector => nil).should == "onetwo, and three"
    end

    it "should convert sentence with last word connector" do
      ['one', 'two', 'three'].to_sentence(:last_word_connector => ', and also ').should == "one, two, and also three"
      ['one', 'two', 'three'].to_sentence(:last_word_connector => nil).should == "one, twothree"
      ['one', 'two', 'three'].to_sentence(:last_word_connector => ' ').should == "one, two three"
      ['one', 'two', 'three'].to_sentence(:last_word_connector => ' and ').should == "one, two and three"
    end

    it "should convert two-element array" do
      ['one', 'two'].to_sentence.should == "one and two"
      ['one', 'two'].to_sentence(:two_words_connector => ' ').should == "one two"
    end

    it "should convert one-element array" do
      ['one'].to_sentence.should == "one"
    end

    it "should create new object" do
      elements = ["one"]
      elements.to_sentence.object_id.should.not == elements[0].object_id
    end

    it "should convert non-string element" do
      [1].to_sentence.should == '1'
    end

    it "should not modify given hash" do
      options = { words_connector: ' ' }
      ['one', 'two', 'three'].to_sentence(options).should == "one two, and three"
      options.should == { words_connector: ' ' }
    end
  end

  describe "to_s" do
    it "should convert to database format" do
      collection = [
        Class.new { def id() 1 end }.new,
        Class.new { def id() 2 end }.new,
        Class.new { def id() 3 end }.new
      ]

      [].to_s(:db).should == "null"
      collection.to_s(:db).should == "1,2,3"
    end
  end
end

describe 'array options' do
  describe "extract_options!" do
    it "should extract an options hash from an array" do
      [1, 2, :a => :b].extract_options!.should == { :a => :b }
    end

    it "should return an empty hash if the last element is not a hash" do
      [1, 2].extract_options!.should == {}
    end

    it "should return an empty hash on an empty array" do
      [].extract_options!.should == {}
    end
  end
end

describe 'array grouping' do
  describe "in_groups_of" do
    it "should group array and fill rest with nil" do
      %w(1 2 3 4 5 6 7 8 9 10).in_groups_of(3).should == [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"],
        ["10", nil, nil]
      ]
    end

    it "should group array and fill with specified filler" do
      %w(1 2 3 4 5).in_groups_of(2, 'empty').should == [
        ["1", "2"],
        ["3", "4"],
        ["5", "empty"]
      ]
    end

    it "should not fill the last group if turned off" do
      %w(1 2 3 4 5).in_groups_of(2, false).should == [
        ["1", "2"],
        ["3", "4"],
        ["5"]
      ]
    end

    it "should yield each slice to a block if given" do
      result = []
      %w(1 2 3 4 5 6 7 8 9 10).in_groups_of(3) { |group| result << ['foo'] + group + ['bar'] }
      result.should == [
        ["foo", "1", "2", "3", "bar"],
        ["foo", "4", "5", "6", "bar"],
        ["foo", "7", "8", "9", "bar"],
        ["foo", "10", nil, nil, "bar"]
      ]
    end
  end

  describe "in_groups" do
    it "should group array and fill the rest with nil" do
      %w(1 2 3 4 5 6 7 8 9 10).in_groups(3).should == [
        ["1", "2", "3", "4"],
        ["5", "6", "7", nil],
        ["8", "9", "10", nil]
      ]
    end

    it "should group array and fill the result with specified filler" do
      %w(1 2 3 4 5 6 7 8 9 10).in_groups(3, 'empty').should == [
        ["1", "2", "3", "4"],
        ["5", "6", "7", "empty"],
        ["8", "9", "10", "empty"]
      ]
    end

    it "should not fill the last group if turned off" do
      %w(1 2 3 4 5 6 7).in_groups(3, false).should == [
        ["1", "2", "3"],
        ["4", "5"],
        ["6", "7"]
      ]
    end

    it "should yield each slice to a block if given" do
      result = []
      %w(1 2 3 4 5 6 7 8 9 10).in_groups(3) { |group| result << ['foo'] + group + ['bar'] }
      result.should == [
        ["foo", "1", "2", "3", "4", "bar"],
        ["foo", "5", "6", "7", nil, "bar"],
        ["foo", "8", "9", "10", nil, "bar"]
      ]
    end
  end

  describe "split" do
    it "should split array based on delimiting value" do
      [1, 2, 3, 4, 5].split(3).should == [[1, 2], [4, 5]]
    end

    it "should split array based on block result" do
      (1..10).to_a.split { |i| i % 3 == 0 }.should == [[1, 2], [4, 5], [7, 8], [10]]
    end
  end
end

describe 'array' do
  describe "prepend" do
    it "should add an element to the front of the array" do
      [1, 2, 3].prepend(0).should == [0, 1, 2, 3]
    end

    it "should change the array" do
      array = [1, 2, 3]
      array.prepend(0)
      array.should == [0, 1, 2, 3]
    end
  end

  describe "append" do
    it "should add an element to the back of the array" do
      [1, 2, 3].append(4).should == [1, 2, 3, 4]
    end

    it "should change the array" do
      array = [1, 2, 3]
      array.append(4)
      array.should == [1, 2, 3, 4]
    end
  end
end

describe 'array' do
  describe "wrap" do
    it "should return empty array for nil" do
      Array.wrap(nil).should == []
    end

    it "should return unchanged array for array" do
      Array.wrap([1, 2, 3]).should == [1, 2, 3]
    end

    it "should not flatten multidimensional array" do
      Array.wrap([[1], [2], [3]]).should == [[1], [2], [3]]
    end

    it "should turn simple object into array" do
      Array.wrap(0).should == [0]
    end
  end
end
