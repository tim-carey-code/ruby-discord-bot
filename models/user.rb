require_relative 'application_record'
class User < ApplicationRecord
  validates :email, presence: true
end