require "anmsm_ruby/version"

module AnmsmRuby
  class Base
    def initialize
      # Resort feed
      @resort_svc = OData::Service.new "http://wcf.tourinsoft.com/Syndication/anmsm/817bee9d-faf4-4680-9d05-e41c2c90ae5a", {:namespace => "Anmsm::Resort"}
      # Weather feed
      @weather_svc = OData::Service.new "http://wcf.tourinsoft.com/Syndication/anmsm/fc13de9f-fa6c-45bf-9f25-1f023a3e6db5", {:namespace => "Anmsm::Weather"}
      # Snow feed
      @snow_svc = OData::Service.new "http://wcf.tourinsoft.com/Syndication/anmsm/ce4e4296-6132-4e11-b8db-ea21b92e736c", {:namespace => "Anmsm::Snow"}
    end

    def resort_snow_infos(resort_anmsm_id)
      @snow_svc.Objects.filter("STATION eq '#{resort_anmsm_id}'").order_by("Updated")
      @snow_svc.execute
    end

    def all_resorts
      @resort_svc.Objects.order_by("NOMSTATION")
      @resort_svc.execute
    end

    def resort_by_name(resort_name)
      @resort_svc.Objects.filter("NOMSTATION eq '#{resort_name}'")
      @resort_svc.execute
    end

    def weather_for_resort(resort, date = Time.now)
      resort_id = resort.SyndicObjectID
      @weather_svc.Objects.filter("STATION eq '#{resort_id}'").filter("day(Updated)  eq #{date.day}")
                                                              .filter("month(Updated) eq #{date.month}")
                                                              .filter("year(Updated)  eq #{date.year}")
      @weather_svc.execute
    end
  end
end
