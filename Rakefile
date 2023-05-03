require 'active_record'

namespace :db do
  db_config = { adapter: 'sqlite3', database: 'db/discord.sqlite3' }
  desc "Create the database"
  task :create do
    ActiveRecord::Base.establish_connection(db_config)
    puts "Database created"
  end

  desc "Migrate the database"
  task :migrate do
    ActiveRecord::Base.establish_connection(db_config)
    ActiveRecord::MigrationContext.new("db/migrate/", ActiveRecord::SchemaMigration).migrate
    puts "Database migrated"
  end

  desc "Drop the database"
  task :drop do
    File.delete(db_config["database"]) if File.exist?(db_config["database"])
    puts "Database deleted"
  end

  desc "Reset the database"
  task reset: [:drop, :create, :migrate]

  desc "Create a db/schema.rb file"
  task :schema do
    ActiveRecord::Base.establish_connection(db_config)
    require "active_record/schema_dumper"
    filename = "db/schema.rb"
    File.open(filename, "w:utf-8") do |file|
      ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
    end
    puts 'Schema dumped'
  end

end

namespace :g do
  desc "Generate migration"
  task :migration do
    name = ARGV[1] || raise("Specify name: rake g:migration your_migration")
    timestamp = Time.now.strftime("%Y%m%d%H%M%S")
    path = File.expand_path("../db/migrate/#{timestamp}_#{name}.rb", __FILE__)
    migration_class = name.split("_").map(&:capitalize).join

    File.open(path, "w") do |file|
      file.write <<~EOF
        class #{migration_class} < ActiveRecord::Migration[7.0]
          def change
          end
        end
      EOF
    end

    puts "Migration #{path} created"
    abort # needed stop other tasks
  end
end