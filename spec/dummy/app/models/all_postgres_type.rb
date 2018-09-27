class AllPostgresType < ActiveRecord::Base
  attribute :point, :point if Rails::VERSION::MAJOR >= 5
end
