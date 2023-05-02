# Discord bot written in Ruby

## How to use this bot

1. Clone this repository
2. cd into the directory
3. Install Ruby 3.1.2(Recommended to use rvm or rbenv) if you don't have it
4. `bundle install`
5. Create a .env file with the following contents:
```
DISCORD_TOKEN=your_token_here
SERVER_ID=discord_server_id_here
WEATHER_API_KEY=your_weather_api_key_here
RAPID_API_KEY=your_rapid_api_key_here
```
- you can get the weather api key from [here](https://openweathermap.org/api) and the rapid api key from [here](https://rapidapi.com/community/api/open-weather-map/endpoints)
- you can get discord tokens and create your bot application in discord [here](https://discord.com/developers/applications)

**You need to make an account on openweather and rapidapi to get the api keys**

- Then you can run the bot with `bundle exec ruby bot.rb` in the root of the directory