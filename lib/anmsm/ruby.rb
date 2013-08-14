# require "anmsm/ruby/version"
require 'ruby-odata'
module Anmsm
  module Ruby
    class << self
      def toto
        # Station
        station = OData::Service.new "http://wcf.tourinsoft.com/Syndication/anmsm/817bee9d-faf4-4680-9d05-e41c2c90ae5a"
        # Meteo
        meteo = OData::Service.new "http://wcf.tourinsoft.com/Syndication/anmsm/fc13de9f-fa6c-45bf-9f25-1f023a3e6db5"
        # # Espace neige
        neige = OData::Service.new "http://wcf.tourinsoft.com/Syndication/anmsm/ce4e4296-6132-4e11-b8db-ea21b92e736c"
        # # webcam
        webcam = OData::Service.new "http://wcf.tourinsoft.com/Syndication/anmsm/2481e5cb-6e0a-4dca-ac62-3124928dfa69"


        # #Data Query

        station.Objects.filter("SyndicObjectID eq 'STATANMSM01730049'")
        stationObjects = station.execute

        stationObjects.each do |station|
          # BOUCLE PRINCIPALE: pour chaque station: recuperer les infos dans des variables plus lisibles puis les afficher

        #TODO reprendre le code ci dessous pour le rendre dynamique
          # filter = "STATION eq '#{station.SyndicObjectID}'"
          # meteo.Objects.filter(filter)
          # meteoObjects = meteo.execute

          # neige.Objects.filter(filter)
          # neigeObjects = neige.execute

          # webcam.Objects.filter(filter)
          # webcamObjects = webcam.execute
          # puts meteoObjects.inspect

        # stationObjects
          raw_data = station.WEBOT.split("||")
          website_url = raw_data[1]  

          altitude_bottom = station.ALTBAS  

          altitude_top = station.ALTHAUT  

          closing_date = station.FERMPART  

          description = station.DESCHIVERFR

          latitude = station.LATITUDE

          longitude = station.LONGITUDE

          opening_date = station.OUVSTATION

          slopes_map_url = station.PLANPISTES

          #tags = STYLEHIVER
          tags = ""
          #TABLE CORRESPONDANCE ANMSM <=> SKIWALLET
          tags_values = {"Nouvelles glisses" => "new-rides", 
                  "Site Nordique" => "nordic-ski",
                  "Grand Domaine" => "large-domain",
                  "Station Club" => "club-resort",
                  "Village de charme" => "charming-village",
                  "Station Alti-Forme" => "altiform-resort",
                  "Label Famille Plus" => "mountain-familly-label"}
            raw_html = Nokogiri::HTML(station.STYLESHIVER)
            imgs = raw_html.css("img")
            if !imgs.empty?
              imgs.each do |i|    
                if tags_values[i["alt"]]
                  tags = tags+tags_values[i["alt"]]
                else
                  puts "erreur: aucune correspondance"
                end
              end 
            else
              puts "Erreur: aucun resultat"
            end  

        # #meteoObjects
        # avalanche_risk = nil
        # meteoObjects.each do |m|
        #   avalanche_risk = m.RISQAVALHIVER

        #   # black_slopes_open = m.OUVNOIRES

        #   # blue_slopes_open = m.OUVBLEUES

        #   # green_slopes_open = m.OUVVERTES

        #   # red_slopes_open = m.OUVROUGES

        #   # snow_bottom = m.HNEIGEBASHIVER

        #   # snow_top = m.HNEIGEHAUTHIVER

        #   # temperature_afternoon = m.TEMPAPMHIVER

        #   # weather_afternoon = m.TEMPAPMHIVER

        #   # weather_morning = m.TEMPAPMHIVER
        # end

        # #neigeObjects
        # neigeObjects.each do |n|
        #   # black_slopes_count = n.NBTOTNOIRES

        #   # blue_slopes_count = n.NBTOTBLEUES

        #   # ski_back = n.RETOURSKI
          
        #   # green_slopes_count = n.NBTOTVERTES

        #   # lift_count = n.NBTOTRM  

        #   # red_slopes_count = n.NBTOTROUGES
        # end

        # #webcamObjects
        #   webcamObjects.each do |w|
        #     raw_data = w.WEBCAM.split("||")
        #     if raw_data.length >= 4 and raw_data[4].match('https?:\/\/.+')
        #       webcam_url = raw_data[4]  
        #     else
        #       webcam_url = "Erreur: url mal formulee"
        #     end
        #   end
          

        #   #champs non pertinent
        #   # puts "---temperature_morning--"
        #   # objects.each do |o|
        #   #   # puts o.
        #   # end

        #   # puts "---email--"
        #   # stationObjects.each do |o|
        #   #   puts o.DESCHIVERFR
        #   # end

        #   # OSEF à faire a la main
        #   # puts "---road_map_url--"
        #   # objects.each do |o|
        #   #   # puts o.
        #   # end

        #   # OSEF
        #   # puts "---sales_closing_hour--"
        #   # objects.each do |o|
        #   #   # puts o.
        #   # end

        #   #OSEF à faire à la main
        #   # puts "---terms_url--"
        #   # objects.each do |o|
        #   #   # puts o.
        #   # end

        #   # à faire à la main
        #   # puts "---webcam_thumb--"
        #   # objects.each do |o|
        #   #   # puts o.
        #   # end


        #   #AFFICHAGE
        #   puts "=== STATION: #{station.NOMSTATION} ==="
        #   puts "=== ResortWeatherInfo ==="
        #   puts "avalanche_risk: "+avalanche_risk
        #   puts "black_slopes_open: "+black_slopes_open
        #   puts "blue_slopes_open: "+blue_slopes_open
        #   #puts "date: "+date
        #   puts "green_slopes_open: "+green_slopes_open
        #   puts "red_slopes_open: "+red_slopes_open
        #   puts "ski_back: "+ski_back
        #   puts "snow_bottom: "+snow_bottom
        #   puts "snow_top: "+snow_top
        #   puts "temperature_afternoon: "+temperature_afternoon
        #   #puts "temperature_morning: "+temperature_morning
        #   puts "weather_afternoon: "+weather_afternoon
        #   puts "weather_morning: "+weather_morning

        #   puts "=== ResortInfo ==="
        #   puts "altitude_bottom: "+altitude_bottom
        #   puts "altitude_top: "+altitude_top
        #   puts "black_slopes_count: "+black_slopes_count
        #   puts "blue_slopes_count: "+blue_slopes_count
        #   puts "closing_date: "+closing_date
        #   puts "description: "+description
        #   #puts "email: "
        #   puts "green_slopes_count: "+green_slopes_count
        #   putends "latitude: "+latitude
        #   puts "lift_count: "+lift_count
        #   puts "longitude: "+longitude
        #   puts "opening_date: "+opening_date
        #   puts "red_slopes_count: "+red_slopes_count
        #   #puts "road_map_url: "+road_map_url
        #   puts "sales_closing_hour: "+sales_closing_hour
        #   puts "slopes_map_url: "+slopes_map_url
        #   puts "tags: "+tags
        #   #puts "terms_url: "+terms_url
        #   puts "weather_url: "+weather_url
        #   #puts "webcam_thumb: "+webcam_thumb
        #   puts "webcam_url: "+webcam_url
        #   puts "website_url: "+website_url
        end
      end
    end
  end
end
