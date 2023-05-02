# frozen_string_literal: true

class TranslateCommand
  def initialize(bot)
    bot.application_command(:translate) do |event|
      query = event.options['query']
      target = event.options['target']

      url = "https://google-translate1.p.rapidapi.com/language/translate/v2"

      response = HTTParty.post(url,
                               body: { source: 'en', target: target, q: query },
                               headers: {
                                 'Content-Type': 'application/x-www-form-urlencoded',
                                 'Accept-Encoding': 'application/gzip',
                                 'X-RapidAPI-Key': ENV['RAPID_API_KEY',],
                                 'X-RapidAPI-Host': 'google-translate1.p.rapidapi.com'
                               }
      )

      json_object = JSON.parse(response.body)

      event.respond(content: "query: #{query}", embeds: [{ description: "#{target} translation: " + json_object['data']['translations'][0]['translatedText']}])
    end
  end
end
