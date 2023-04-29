# frozen_string_literal: true

class Mentions
  def mention_pm_user(bot)
    bot.mention do |event|
      event.user.pm("Hello, #{event.user.name}!")
    end
  end
end