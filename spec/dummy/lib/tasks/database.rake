# frozen_string_literal: true

require 'active_record'

# override database.rake
Rake::Task["db:schema:load"].clear

db_namespace = namespace :db do
  namespace :schema do
    task load: [:load_config, :check_protected_environments] do
      schema_format = Rails.application.config.active_record.schema_format || :ruby

      ActiveRecord::Base.configurations.configs_for(env_name: Rails.env).each do |db_config|
        ActiveRecord::Tasks::DatabaseTasks.with_temporary_connection(db_config) do
          file = File.join(ActiveRecord::Tasks::DatabaseTasks.db_dir, "#{db_config.name}_schema.rb")
          ActiveRecord::Tasks::DatabaseTasks.load_schema(db_config, schema_format, file)
        end
      end
    end

    task dump: [:load_config] do
      schema_format = Rails.application.config.active_record.schema_format || :ruby

      ActiveRecord::Base.configurations.configs_for(env_name: Rails.env).each do |db_config|
        ActiveRecord::Tasks::DatabaseTasks.with_temporary_connection(db_config) do
          file = File.join(ActiveRecord::Tasks::DatabaseTasks.db_dir, "#{db_config.name}_schema.rb")
          ActiveRecord::Tasks::DatabaseTasks.dump_schema(db_config, schema_format)
        end
      end
    end
  end
end
