class RegisterCommands
  bot.register_application_command(:weather, "Gives the current weather", server_id: ENV['SERVER_ID']) do |cmd|
    cmd.string('location', 'The location to get the weather for', required: true)
  end

  bot.register_application_command(:spongecase, 'Are you mocking me?', server_id: ENV.fetch('SLASH_COMMAND_BOT_SERVER_ID', nil)) do |cmd|
    cmd.string('message', 'Message to spongecase')
    cmd.boolean('with_picture', 'Show the mocking sponge?')
  end
end