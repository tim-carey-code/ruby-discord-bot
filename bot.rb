# frozen_string_literal: true

require 'dotenv/load'
require 'discordrb'
require 'httparty'
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

    event.respond(content: "The current weather in #{location}, #{country} is #{rounded_temp}°F with #{json_response[:weather][0][:description]}")
  end


  bot.run
end
