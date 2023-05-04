# frozen_string_literal: true

require 'open-weather-ruby-client'

class WeatherCommands
  def initialize(bot)
    @bot = bot
    @client = OpenWeather::Client.new(
      api_key: ENV["WEATHER_API_KEY"]
    )
    current_weather
    hourly_weather
  end
  def current_weather
    @bot.application_command(:weather) do |event|
      location = get_location(event)
      data = @client.current_weather(city: location, country: 'US', units: 'imperial')

      current_temp = data.main.temp
      weather_description = data.weather[0].description
      wind_speed = data.wind.speed
      humidity = data.main.humidity
      feels_like = data.main.feels_like
      high_temp = data.main.temp_max
      low_temp = data.main.temp_min

      event.respond(content:"The current weather in #{location}, US is: #{current_temp}°F with #{weather_description}. Wind speed: #{wind_speed}mph. Humidity: #{humidity}%. Feels like: #{feels_like}°F. High: #{high_temp}°F. Low: #{low_temp}.")
    end
  end

  def hourly_weather
    @bot.application_command(:hourly) do |event|
      location = get_location(event)
      url = "https://api.openweathermap.org/data/2.5/forecast?q=#{location},us&units=imperial&appid=#{@client.api_key}"
      json_response = get_json_response(url)

      country = json_response[:city][:country]

      hourly_forecast = json_response[:list].map do |forecast|
        rounded_temp = forecast[:main][:temp].floor
        time = Time.at(forecast[:dt]).strftime('%I:%M %p')
        "At #{time}, it will be #{rounded_temp}°F with #{forecast[:weather][0][:description]}.\n"
      end

      event.respond(content: "The 5 day 3 hour forecast for #{location}, #{country}\n #{hourly_forecast.join(' ')}")
    end
  end

  def get_json_response(url)
    response = HTTParty.get(url, format: :plain)
    JSON.parse(response, symbolize_names: true)
  end

  def get_location(event)
    event.options['location'].capitalize
  end
end
