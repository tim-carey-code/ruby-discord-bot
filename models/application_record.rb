require 'active_record'
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  self.establish_connection(adapter: 'sqlite3', database: 'db/discord.sqlite3')
end