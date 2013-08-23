require 'spec_helper'

describe AnmsmRuby::Base do

  describe "#initialize" do
    before :all do
      @instance = AnmsmRuby::Base.new
    end

    it 'should assign @resort_svc' do
      @instance.instance_variable_get(:@resort_svc).should be_an_instance_of OData::Service
    end

    it 'should assign @weather_svc' do
      @instance.instance_variable_get(:@weather_svc).should be_an_instance_of OData::Service
    end

    it 'should assign @snow_svc' do
      @instance.instance_variable_get(:@snow_svc).should be_an_instance_of OData::Service
    end
  end
end