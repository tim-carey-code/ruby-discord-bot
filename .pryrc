# This will load all my models into pry when booted up

Dir.glob(File.join('.', 'models', '*.rb')).each { |file| require file }
