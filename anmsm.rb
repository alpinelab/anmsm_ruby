# coding: utf-8
require 'ruby_odata'

##### Gem

class AnmsmGem

  def initialize
    # Resort feed
    @resort_svc = OData::Service.new "http://wcf.tourinsoft.com/Syndication/anmsm/817bee9d-faf4-4680-9d05-e41c2c90ae5a", {:namespace => "Anmsm::Resort"}
    # Weather feed
    @weather_svc = OData::Service.new "http://wcf.tourinsoft.com/Syndication/anmsm/fc13de9f-fa6c-45bf-9f25-1f023a3e6db5", {:namespace => "Anmsm::Weather"}
    # Snow feed
    @snow_svc = OData::Service.new "http://wcf.tourinsoft.com/Syndication/anmsm/ce4e4296-6132-4e11-b8db-ea21b92e736c", {:namespace => "Anmsm::Snow"}
    # Webcam feed
    @webcam_svc = OData::Service.new "http://wcf.tourinsoft.com/Syndication/anmsm/2481e5cb-6e0a-4dca-ac62-3124928dfa69", {:namespace => "Anmsm::Webcam"}
  end

  def all_resorts
    @resort_svc.Objects.order_by("NOMSTATION")
    @resort_svc.execute
  end

  def resort_by_name(resort_name)
    @resort_svc.Objects.filter("NOMSTATION eq #{resort_name}")
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

#######

class AnmsmSync

  def sync_weather_for_all_resorts
    anmsm = AnmsmGem.new()
    resorts = anmsm.all_resorts
    puts "#{resorts.length} stations récupérées."
    resorts.each do |resort|
      weather = anmsm.weather_for_resort(resort)
      if weather.length == 1
        update_weather_for_resort(weather[0], resort.NOMSTATION)
      else
        puts "météo ko avec la station #{resort.NOMSTATION}"
      end
    end
  end

  def update_weather_for_resort(weather, resort_name)
    resort = Resort.find_by_slug(Resort.slug_me_please(resort_name))
    rwi = ResortWeatherInfo.create! rwi.resort = resort,
      rwi.avalanche_risk = weather.RISQAVALHIVER,
      rwi.black_slopes_open = weather.OUVNOIRES,
      rwi.blue_slopes_open = weather.OUVBLEUES,
      rwi.green_slopes_open = weather.OUVVERTES,
      rwi.red_slopes_open = weather.OUVROUGES,
      rwi.snow_bottom = weather.HNEIGEBASHIVER,
      rwi.snow_top = weather.HNEIGEHAUTHIVER,
      rwi.temperature_afternoon = weather.TEMPAPMHIVER,
      rwi.weather_afternoon = weather.TEMPAPMHIVER,
      rwi.weather_morning = weather.TEMPAPMHIVER
  end

end

sync = AnmsmSync.new()
sync.sync_weather_for_all_resorts