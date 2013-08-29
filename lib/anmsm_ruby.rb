require 'anmsm_ruby/version'
require 'ruby_odata'

module AnmsmRuby
  class Base
    attr_accessor :resort_svc
    def initialize
      # Resort feed
      @resort_svc = OData::Service.new "http://wcf.tourinsoft.com/Syndication/anmsm/817bee9d-faf4-4680-9d05-e41c2c90ae5a", {:namespace => "Anmsm::Resort"}
      # Weather feed
      @weather_svc = OData::Service.new "http://wcf.tourinsoft.com/Syndication/anmsm/fc13de9f-fa6c-45bf-9f25-1f023a3e6db5", {:namespace => "Anmsm::Weather"}
      # Snow feed
      @snow_svc = OData::Service.new "http://wcf.tourinsoft.com/Syndication/anmsm/ce4e4296-6132-4e11-b8db-ea21b92e736c", {:namespace => "Anmsm::Snow"}
    end

    #returns general info for all resorts
    def all_resorts
      @resort_svc.Objects.order_by("NOMSTATION")
      @resort_svc.execute
    end

    #returns general info for the given resorts
    def info_for_resort(resort_name)
      @resort_svc.Objects.filter("NOMSTATION eq '#{resort_name}'")
      @resort_svc.execute
    end

    #returns snow info for the given resort
    def snow_info_for_resort(resort_anmsm_id)
      @snow_svc.Objects.filter("STATION eq '#{resort_anmsm_id}'").order_by("Updated")
      @snow_svc.execute
    end

    #returns weather info for the given resort
    def weather_for_resort(resort)
      resort_id = resort.SyndicObjectID
      @weather_svc.Objects.filter("STATION eq '#{resort_id}'").order_by("day(Updated)")
                                                              .order_by("month(Updated)")
                                                              .order_by("year(Updated)")
      @weather_svc.execute
    end
  end
end