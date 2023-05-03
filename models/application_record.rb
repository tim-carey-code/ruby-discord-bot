require_relative '../db/database'
require 'active_record'
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end