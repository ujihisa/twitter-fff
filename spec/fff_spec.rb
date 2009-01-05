require File.dirname(__FILE__) + '/../lib/fff.rb'

describe Fff, 'when called #initialize()' do
  it 'should become to have instance variables in initialize()' do
    u, p = ['john', 'password123']

    twitter = mock('twitter')
    twitter.stub! :friends => []
    Twitter::Base.should_receive(:new).with(u, p).and_return(twitter)

    f = Fff.new(u, p)
    f.instance_variable_get(:@t).should == twitter
    f.instance_variable_get(:@your_followings).should == []
  end
end

describe Fff, 'when called other methods' do
  before do
    u, p = ['john', 'password123']
    people = %w[taro jiro saburo hanako].inject({}) {|memo, name|
      memo.update({name.intern => mock(name, :screen_name => name)})
    }
    twitter = mock(
      'twitter',
      :friends => [people[:taro]],
      :friends_for => [people[:taro], people[:jiro], people[:saburo]])
    Twitter::Base.should_receive(:new).with(u, p).and_return(twitter)
    @f = Fff.new(u, p)
  end

  it 'should return followings by calling #followings()' do
    @f.followings('mike').sort.should == ['taro', 'jiro', 'saburo'].sort
  end

  it 'should return followed or not by calling #followed?()' do
    @f.followed?('taro').should be_true
    @f.followed?('jiro').should be_false
  end
end
