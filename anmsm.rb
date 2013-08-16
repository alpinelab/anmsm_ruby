# coding: utf-8
require 'ruby_odata'
require 'i18n'

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

  # def generate_resort_slug(resort_name)
  #   return nil if resort_name.nil? || resort_name.match(/^\s*$/)
  #   slug = resort_name.clone
  #   #apostrophes
  #   slug.gsub!(/'/, '-') if slug.match(/'/)
  #   # remplacer les "/" par "-"    
  #   slug.gsub!(/\//, '-') if slug.match(/\//)
  #   #gerer les tirets-espace 
  #   slug.gsub!(/( *- *)/,'-') if slug.match(/( *- *)/)    
  #   # remplacer " " par "-"
  #   slug.gsub!(/ +/, '-') if slug.match(/ +/)   
  #   # minuscule
  #   I18n.transliterate(slug.downcase)
  # end

  def generate_resort_name(resort_name)
    return nil if resort_name.nil? || resort_name.match(/^\s*$/)
    name = resort_name.clone
    #virer les espaces superflus
    name.gsub!(/ {2,}/, ' ') if name.match(/ {2,}/)
    name.gsub!(/^ | $/, '') if name.match(/^ | $/)
    #gerer les slash
    name.gsub!(/(\b *\/ *\b)/, ' / ') if name.match(/(\b *\/ *\b)/)
    #convertir les " - " en " / "
    name.gsub!(/\b - \b/, ' / ') if name.match(/\b - \b/)
    name.gsub!(/(\b- \b)|(\b -\b)/, '-') if name.match(/(\b- \b)|(\b -\b)/)
    #capitaliser chaque mot tout en gerant les mots composés (ex: Crest-volant) et les apostrophes (ex: Alpes D'huez)    
    words = name.split(/( |'|-)/)
    words.each do |i|
      i.downcase!
      i.capitalize! unless i == nil || i.length <= 1
    end
    name = words.join("")
  end

  def sync_weather_for_all_resorts
    anmsm = AnmsmGem.new()
    resorts = anmsm.all_resorts
    puts "#{resorts.length} stations récupérées."
    resorts.each do |resort| 
      slug = generate_resort_slug(resort.NOMSTATION) 
      display_name = generate_resort_name(resort.NOMSTATION)    
      weather = anmsm.weather_for_resort(resort)
      if weather.length == 1
        #update_weather_for_resort(weather[0], resort.NOMSTATION)
        puts "météo ok avec la station #{display_name} (slug: '#{slug}')"
      else
        puts "météo ko avec la station #{display_name} (slug: '#{slug}')"
      end
    end
  end

  def sync_infos_for_all_resorts
    anmsm = AnmsmGem.new()
    resorts = anmsm.all_resorts
    puts "#{resorts.length} stations récupérées."
    resorts.each do |resort| 
      create_sw_resort_from_anmsm_resort(resort)
    end
  end

  def create_sw_resort_from_anmsm_resort(anmsm_resort)
    sw_resort = Resort.new
    sw_resort.name = generate_resort_name(anmsm_resort.NOMSTATION)
    sw_resort.save!
  end

  def create_resort_infos(resort)
    
  end

  #TODO gerer les cas nordique / alpin (cf Autrans) pour retrouver le slug

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

#sync = AnmsmSync.new()
#sync.sync_weather_for_all_resorts
