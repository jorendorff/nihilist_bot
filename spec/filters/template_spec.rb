require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. spec_helper]))
require 'bot_filter'
require 'filters/template'

describe BotFilter::Template, 'on initialization' do
  before :each do
    @filter = BotFilter::Template.new
  end
  
  it 'should accept options on initialization' do
    lambda { BotFilter::Template.new(stub('options')) }.should_not raise_error(ArgumentError)
  end
  
  it 'should not require options on initialization' do
    lambda { BotFilter::Template.new }.should_not raise_error(ArgumentError)
  end

  it 'should not require specific options for its kind of filter' do
    options = { 'filters' => { } }
    BotFilter::Template.any_instance.stubs(:kind).returns(:foo)
    lambda { BotFilter::Template.new(options) }.should_not raise_error
  end
  
  it 'should store options for its kind of filter' do
    options = { 'filters' => { 'foo' => { :bar => :baz } } }
    BotFilter::Template.any_instance.stubs(:kind).returns(:foo)
    filter = BotFilter::Template.new(options)
    filter.options.should == { :bar => :baz }
  end
  
  it 'should default options to empty hash' do
    filter = BotFilter::Template.new
    filter.options.should == {}
  end
end

class BotFilter::FooCrap < BotFilter::Template; end  # testing-only class

describe BotFilter::Template do
  before :each do
    @filter = BotFilter::Template.new
  end

  it 'should be able to return the name for its kind' do
    @filter.kind.should == :template
  end

  it 'should be able to return the kind name for its subclasses' do
    BotFilter::FooCrap.new.kind.should == :foo_crap
  end
end

describe BotFilter::Template, 'when processing' do
  before :each do
    @filter = BotFilter::Template.new
  end

  it 'should require data' do
    lambda { @filter.process }.should raise_error(ArgumentError)
  end
  
  it 'should require a hash' do
    lambda { @filter.process('puppies') }.should raise_error(TypeError)
  end
  
  it 'should accept a hash' do
    lambda { @filter.process({ :data => 'puppies' }) }.should_not raise_error
  end
  
  it 'should return a hash' do
    @filter.process({ :data => 'puppies' }).should be_kind_of(Hash)
  end
  
  it 'should return the input hash' do
    data = { :data => 'puppies' }
    @filter.process(data).should == data
  end
end
