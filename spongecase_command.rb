# frozen_string_literal: true
class SpongecaseCommand
  def initialize(bot)
    bot.application_command(:spongecase) do |event|
      ops = %i[upcase downcase]
      text = event.options['message'].chars.map { |x| x.__send__(ops.sample) }.join
      event.respond(content: text)

      event.send_message(content: 'https://pyxis.nymag.com/v1/imgs/09c/923/65324bb3906b6865f904a72f8f8a908541-16-spongebob-explainer.rsquare.w700.jpg') if event.options['with_picture']
    end
  end
end