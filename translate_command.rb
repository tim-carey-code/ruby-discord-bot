# frozen_string_literal: true

require 'uri'
require 'net/http'

class TranslateCommand
  def initialize(bot)
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

      event.respond(content: "query: #{query}", embeds: [{ description: "#{target} translation: " + json_object['data']['translations'][0]['translatedText']}])
    end
  end
end