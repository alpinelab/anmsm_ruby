require 'spec_helper'
require 'vcr_setup.rb'

describe AnmsmRuby::Base do
  before :all do
    @instance = nil
    VCR.use_cassette('initialize') do
      @instance = AnmsmRuby::Base.new
    end
    @resort = nil
    VCR.use_cassette('info_for_resort') do
      @resort = @instance.info_for_resort("AILLONS- MARGERIAZ")
    end
  end

  describe "#initialize" do
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

  describe "#all_resorts" do
    it 'should return all resorts ordered by `NOMSTATION`' do
      resorts = nil
      VCR.use_cassette('all_resorts') do
        resorts = @instance.all_resorts
      end
      resorts.first.NOMSTATION.should eq "AILLONS- MARGERIAZ"
      resorts.last.NOMSTATION.should eq "VILLARD DE LANS / CORRENCON"
    end
  end

  describe "#info_for_resort" do
    it 'should return only one result' do
      @resort.length.should eq 1
    end

    it 'should return info for the right resort' do
      @resort.first.SyndicObjectID.should eq "STATANMSM01730027"
    end
  end

  describe "#snow_info_for_resort" do
    before :all do
      @snow_info = nil
      VCR.use_cassette('snow_info_for_resort') do
        @snow_info = @instance.snow_info_for_resort(@resort.first)
      end
    end
    it 'should return only one result' do
      @snow_info.length.should eq 1
    end
    it 'should return snow info for the right resort' do
      @snow_info.first.SyndicObjectID.should eq "ESPANMSM01730027"
      @snow_info.first.STATION.should eq @resort.first.SyndicObjectID
      @snow_info.first.NBTOTPISTES.should_not be_nil
    end
  end

  describe "#weather_for_resort" do
    before :all do
      @weather_info = nil
      VCR.use_cassette('weather_for_resort') do
        @weather_info = @instance.weather_for_resort(@resort.first)
      end
    end
    it 'should return only one result' do
      @weather_info.length.should eq 1
    end
    it 'should return snow info for the right resort' do
      @weather_info.first.SyndicObjectID.should eq "BULLANMSM2V50011Z"
      @weather_info.first.STATION.should eq @resort.first.SyndicObjectID
      @weather_info.first.CIELHIVER.should_not be_nil
    end
  end
end