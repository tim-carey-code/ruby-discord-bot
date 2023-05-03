require 'active_record'

db_config = YAML.load(File.read(File.join(File.dirname(__FILE__), '../db/config.yml')))
ActiveRecord::Base.establish_connection(db_config['development'])
