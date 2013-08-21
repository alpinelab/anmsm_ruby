require 'spec_helper'

describe 'initialize' do
  before :each do
    @instance = AnmsmRuby::Base.new
  end

  it 'should assign @resort_svc' do
    @instance.instance_variable_get(:@resort_svc).should_not be_nil
  end

  it 'should assign @weather_svc' do
    @instance.instance_variable_get(:@weather_svc).should_not be_nil
  end

  it 'should assign @snow_svc' do
    @instance.instance_variable_get(:@snow_svc).should_not be_nil
  end
end