require 'dotenv/load'
require 'discordrb'

bot = Discordrb::Bot.new token: ENV['DISCORD_TOKEN'], intents: [:server_messages]


bot.register_application_command(:spongecase, 'Are you mocking me?', server_id: ENV['SERVER_ID'], type: :chat_input) do |cmd|
  cmd.string('message', 'Message to spongecase')
  cmd.boolean('with_picture', 'Show the mocking sponge?')
end



bot.message(with_text: 'Ping!') do |event|
  event.respond 'Pong!'
end

bot.run