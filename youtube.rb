require 'dotenv/load'
require 'httparty'
api_key = ENV["SPOTIFY_KEY"]

response = HTTParty.get('https://api.spotify.com/v1/search?q=Rites+of+disease&type=track&&limit=3&market=US', {
  headers: {"Authorization:" => "Bearer #{api_key}"},
})

track = HTTParty.get('https://api.spotify.com/v1/tracks/2qmOLs416IjD06B8CvKGyj?market=US', {
  headers: { "Authorization:" => "Bearer #{api_key}"}
})


puts track['external_urls']['spotify']
