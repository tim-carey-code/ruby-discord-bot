# frozen_string_literal: true

require 'dotenv/load'
require 'discordrb'
require_relative 'mentions'
require_relative 'spongecase_command'
require_relative 'weather_commands'
require_relative 'translate_command'

api_key = ENV["WEATHER_API_KEY"]

bot = Discordrb::Bot.new token: ENV['DISCORD_TOKEN'], intents: [:servers, :server_messages, :server_webhooks]

bot.server(ENV['SERVER_ID'])

Mentions.new(bot)
SpongecaseCommand.new(bot)
WeatherCommands.new(bot, api_key)
TranslateCommand.new(bot)

bot.run
