# frozen_string_literal: true
require 'active_record'

# override database.rake
Rake::Task["db:test:purge"].clear
Rake::Task["db:test:load_schema"].clear
Rake::Task["db:schema:load"].clear

db_namespace = namespace :db do
  namespace :schema do
    desc 'Dump all database schema'
    task dump: %w[environment load_config] do
      require 'active_record/schema_dumper'
      %w[postgresql mysql sqlite].each do |type|
        schema_file = File.join ActiveRecord::Tasks::DatabaseTasks.db_dir, "#{type}_schema.rb"
        File.open(schema_file, 'w:utf-8') do |file|
          ActiveRecord::Base.establish_connection type.to_sym
          ActiveRecord::SchemaDumper.dump ActiveRecord::Base.connection, file
        end
      end
      db_namespace['schema:dump'].reenable
    end

    desc "Recreate the test database from an existent schema.rb file"
    task load: %w[db:test:load_schema] do
    end
  end

  namespace :test do
    desc "Empty the test database"
    task purge: %w[environment load_config] do
      ActiveRecord::Tasks::DatabaseTasks.purge_all
    end

    desc "Recreate the test database from an existent schema.rb file"
    task load_schema: %w[db:test:purge] do
      %w[postgresql mysql sqlite].each do |type|
        ActiveRecord::Base.establish_connection type.to_sym
        should_reconnect = ActiveRecord::Base.connection_pool.active_connection?
        ActiveRecord::Schema.verbose = false
        schema_file = File.join ActiveRecord::Tasks::DatabaseTasks.db_dir, "#{type}_schema.rb"
        if Rails::VERSION::MAJOR == 6 && Rails::VERSION::MINOR >= 1 || Rails::VERSION::MAJOR >= 7
          ActiveRecord::Tasks::DatabaseTasks.load_schema ActiveRecord::Base.configurations.configs_for(env_name: type).first, :ruby, schema_file
        elsif Rails::VERSION::MAJOR >= 5 && Rails::VERSION::MAJOR <= 6
          ActiveRecord::Tasks::DatabaseTasks.load_schema ActiveRecord::Base.configurations[type], :ruby, schema_file
        else
          ActiveRecord::Tasks::DatabaseTasks.load_schema_for ActiveRecord::Base.configurations[type], :ruby, schema_file
        end

      ensure
        ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations[type]) if should_reconnect
      end
    end
  end
end
