class Location < ApplicationRecord
    validates :name, presence: true, uniqueness: true
    validates :ip, presence: true, ipaddr: true, uniqueness: true

    def specific_location
        require 'net/http'
        require 'json'
        #retreive city, state, and country of ip address
        loc = Net::HTTP.get(URI("https://ipapi.co/#{:ip}/json/"))
        loc_info = JSON.parse(loc)
        city = loc_info["city"]
        state = loc_info["region"]
        country = loc_info["country_name"]
        return "#{city}, #{state}, #{country}"
    end

    def weather_array
        require 'net/http'
        require 'json'
        # Retreive the lattitude and longitude coordinates of the ip address
        loc = Net::HTTP.get(URI("https://ipapi.co/#{:ip}/json/"))
        loc_info = JSON.parse(loc)
        latitude = loc_info["latitude"]
        longitude = loc_info["longitude"]
        return get_weather(latitude, longitude)
      end
  
      def get_weather(latitude, longitude)
        #retreive and return the next seven days and their corresponding highs and lows
        weather = Net::HTTP.get(URI("https://api.open-meteo.com/v1/forecast?latitude=#{latitude}&longitude=#{longitude}&daily=temperature_2m_max&daily=temperature_2m_min&temperature_unit=fahrenheit"))
        weather_parse = JSON.parse(weather)
        weather_hash = weather_parse["daily"]
        return pair_values(weather_hash)
      end
  
      def pair_values(hash)
        arr = hash["time"]
        x = 0
        weather_output = Array.new
        while x < arr.length
          weather_output.push("Date of <b>#{hash["time"][x]}</b>: 
          High of <b>#{hash["temperature_2m_max"][x]}°F</b>, 
          Low of <b>#{hash["temperature_2m_min"][x]}°F</b>".html_safe)
          x = x + 1
        end
        return weather_output
      end
end
