class LocationsController < ApplicationController
  before_action :set_location, only: %i[ show edit update destroy ]

  # GET /locations or /locations.json
  def index
    @locations = Location.all
  end

  # GET /locations/1 or /locations/1.json
  def show
    @weather = get_weather(@location.ip)
    @specific_location = get_specific_location(@location.ip)
  end

  # GET /locations/new
  def new
    @location = Location.new
  end

  # GET /locations/1/edit
  def edit
  end

  # POST /locations or /locations.json
  def create
    @location = Location.new(location_params)

    respond_to do |format|
      if @location.save
        format.html { redirect_to location_url(@location), notice: "Location was successfully created." }
        format.json { render :show, status: :created, location: @location, weather: @weather }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /locations/1 or /locations/1.json
  def update
    respond_to do |format|
      if @location.update(location_params)
        format.html { redirect_to location_url(@location), notice: "Location was successfully updated." }
        format.json { render :show, status: :ok, location: @location }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1 or /locations/1.json
  def destroy
    @location.destroy!

    respond_to do |format|
      format.html { redirect_to locations_url, notice: "Location was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_location
      @location = Location.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def location_params
      params.require(:location).permit(:name, :ip)
    end

    def get_specific_location(ip)
      require 'net/http'
      require 'json'
      #retreive city, state, and country of ip address
      loc = Net::HTTP.get(URI("https://ipapi.co/#{ip}/json/"))
      loc_info = JSON.parse(loc)
      city = loc_info["city"]
      state = loc_info["region"]
      country = loc_info["country_name"]
      return "#{city}, #{state}, #{country}"
    end

    def get_weather(ip)
      require 'net/http'
      require 'json'
      # Retreive the lattitude and longitude coordinates of the ip address
      loc = Net::HTTP.get(URI("https://ipapi.co/#{ip}/json/"))
      loc_info = JSON.parse(loc)
      latitude = loc_info["latitude"]
      longitude = loc_info["longitude"]

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
