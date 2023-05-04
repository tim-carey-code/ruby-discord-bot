# This will load all models into pry when booted up

Dir.glob(File.join('.', 'models', '*.rb')).each { |file| require file }
