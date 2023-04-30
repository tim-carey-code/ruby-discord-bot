# frozen_string_literal: true

require 'dotenv/load'
require 'discordrb'
require 'httparty'
require 'uri'
require 'net/http'
require 'json'
require_relative 'mentions'

class Bot
  attr_reader :bot, :mentions
  api_key = ENV["WEATHER_API_KEY"]

  bot = Discordrb::Bot.new token: ENV['DISCORD_TOKEN'], intents: [:servers, :server_messages, :server_webhooks]

  bot.server(ENV['SERVER_ID'])

  mentions = Mentions.new
  mentions.mention_pm_user(bot)

  bot.application_command(:spongecase) do |event|
    ops = %i[upcase downcase]
    text = event.options['message'].chars.map { |x| x.__send__(ops.sample) }.join
    event.respond(content: text)

    event.send_message(content: 'https://pyxis.nymag.com/v1/imgs/09c/923/65324bb3906b6865f904a72f8f8a908541-16-spongebob-explainer.rsquare.w700.jpg') if event.options['with_picture']
  end

  bot.application_command(:weather) do |event|
    location = event.options['location'].capitalize
    url = "https://api.openweathermap.org/data/2.5/weather?q=#{location},us&units=imperial&appid=#{api_key}"
    response = HTTParty.get(url, format: :plain)

    json_response = JSON.parse(response, symbolize_names: true)

    country = json_response[:sys][:country]

    rounded_temp = json_response[:main][:temp].floor

    event.respond(content: "The current weather in #{location}, #{country} is #{rounded_temp}°F with #{json_response[:weather][0][:description]}. Wind speed of #{json_response[:wind][:speed]} MPH. Humidity is #{json_response[:main][:humidity]}%.")
  end

  # bot.register_application_command(:hourly, 'Get the forecast every 3 hours', server_id: ENV['SERVER_ID']) do |cmd|
  #   cmd.string('location', 'The location to get the weather for', required: true)
  # end

  bot.application_command(:hourly) do |event|
    location = event.options['location'].capitalize
    url = "https://api.openweathermap.org/data/2.5/forecast?q=#{location},us&units=imperial&appid=#{api_key}"
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

  # bot.register_application_command(:play, 'Pick a song to play from YouTube.', server_id: ENV['SERVER_ID']) do |cmd|
  #   cmd.string('query', 'The song you want to search for.', required: true)
  # end
  #
  # bot.application_command(:play) do |group|
  #   api_key = ENV["YOUTUBE_API_KEY"]
  #
  #   response = HTTParty.get("https://youtube.googleapis.com/youtube/v3/search?part=snippet&maxResults=3&q=deformed%20through%20gluttony&key=#{api_key}")
  #
  #   group.respond(content: 'Play Video') do |_, view|
  #     view.row do |r|
  #       r.button(label: 'Pick the youtube video you want to play!', style: :primary, custom_id: 'test_button:1')
  #     end
  #
  #     view.row do |r|
  #       r.select_menu(custom_id: 'video_select', placeholder: 'Select me!', max_values: 3) do |s|
  #         response["items"].each_with_index do |item|
  #           s.option(label: item["snippet"]["title"], value: item["snippet"]["title"])
  #         end
  #       end
  #     end
  #   end
  # end
  #
  # bot.select_menu(custom_id: 'video_select') do |event|
  #   event.respond(content: "You selected: #{event.values.join(', ')}")
  # end

  bot.application_command(:translate) do |event|
    query = event.options['query']
    target = event.options['target']

    url = URI("https://google-translate1.p.rapidapi.com/language/translate/v2")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["content-type"] = 'application/x-www-form-urlencoded'
    request["Accept-Encoding"] = 'application/gzip'
    request["X-RapidAPI-Key"] = '903dc4b2a8msh910de95fc0d7d45p19b4bfjsn919a88f72f80'
    request["X-RapidAPI-Host"] = 'google-translate1.p.rapidapi.com'
    request.body = "source=en&target=#{target}&q=#{query}"

    response = http.request(request)
    json_object = JSON.parse(response.read_body)

    event.respond(content: json_object['data']['translations'][0]['translatedText'])
  end


  bot.run
end
