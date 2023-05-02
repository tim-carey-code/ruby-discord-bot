# frozen_string_literal: true

require 'httparty'

class WeatherCommands
  def initialize(bot, api_key)
    @bot = bot
    @api_key = api_key
    current_weather
    hourly_weather
  end

  private

  def current_weather
    @bot.application_command(:weather) do |event|
      location = event.options['location'].capitalize
      url = "https://api.openweathermap.org/data/2.5/weather?q=#{location},us&units=imperial&appid=#{@api_key}"
      response = HTTParty.get(url, format: :plain)

      json_response = JSON.parse(response, symbolize_names: true)

      country = json_response[:sys][:country]

      rounded_temp = json_response[:main][:temp].floor

      event.respond(content: "The current weather in #{location}, #{country} is #{rounded_temp}°F with #{json_response[:weather][0][:description]}. Wind speed of #{json_response[:wind][:speed]} MPH. Humidity is #{json_response[:main][:humidity]}%.")
    end
  end

  def hourly_weather
    @bot.application_command(:hourly) do |event|
      location = event.options['location'].capitalize
      url = "https://api.openweathermap.org/data/2.5/forecast?q=#{location},us&units=imperial&appid=#{@api_key}"
      response = HTTParty.get(url, format: :plain)

      json_response = JSON.parse(response, symbolize_names: true)

      country = json_response[:city][:country]

      hourly_forecast = json_response[:list].map do |forecast|
        rounded_temp = forecast[:main][:temp].floor
        time = Time.at(forecast[:dt]).strftime('%I:%M %p')
        "At #{time}, it will be #{rounded_temp}°F with #{forecast[:weather][0][:description]}.\n"
      end

      event.respond(content: "The hourly forecast for #{location}, #{country} is: #{hourly_forecast.join(' ')}")
    end
  end
end
