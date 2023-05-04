# frozen_string_literal: true

Bundler.require
require 'dotenv/load'
require_relative 'commands/register_commands'
require_relative 'mentions'
require_relative 'commands/spongecase_command'
require_relative 'commands/weather_commands'
require_relative 'commands/translate_command'

EasyTranslate.api_key = ENV['GOOGLE_API_KEY']


bot = Discordrb::Bot.new token: ENV['DISCORD_TOKEN'], intents: [:servers, :server_messages, :server_webhooks]

bot.server(ENV['SERVER_ID'])

Mentions.new(bot)
SpongecaseCommand.new(bot)
WeatherCommands.new(bot)
TranslateCommand.new(bot)

if ENV['REGISTER_COMMANDS'] == 'true'
  RegisterCommands.register_all(bot)
end

bot.run
