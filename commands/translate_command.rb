# frozen_string_literal: true

class TranslateCommand
  def initialize(bot)
    bot.application_command(:translate) do |event|
      query = event.options['query']
      target = event.options['target']

      translated_text = EasyTranslate.translate("#{query}", to: target)

      event.respond(content: "query: #{query}", embeds: [{ description: "#{target} translation: #{translated_text}"}])
    end
  end
end
