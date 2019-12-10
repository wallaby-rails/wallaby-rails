RSpec.configure do |config|
  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # config.before(:suite) do
  #   if config.use_transactional_fixtures?

  #     raise(<<-MSG)
  #       Delete line `config.use_transactional_fixtures = true` from rails_helper.rb
  #       (or set it to false) to prevent uncommitted transactions being used in
  #       JavaScript-dependent specs.
  #       During testing, the Ruby app server that the JavaScript browser driver
  #       connects to uses a different database connection to the database connection
  #       used by the spec.

  #       This Ruby app server database connection would not be able to see data that
  #       has been setup by the spec's database connection inside an uncommitted
  #       transaction.
  #       Disabling the use_transactional_fixtures setting helps avoid uncommitted
  #       transactions in JavaScript-dependent specs, meaning that the Ruby app server
  #       database connection can see any data set up by the specs.
  #     MSG

  #   end
  # end

  config.before(:suite) do
    DatabaseCleaner.clean_with :truncation
    [AllMysqlType, AllSqliteType].each do |model_klass|
      DatabaseCleaner[:active_record, model: model_klass].clean_with :truncation
    end
  end

  config.before do
    DatabaseCleaner.strategy = :transaction
    [AllMysqlType, AllSqliteType].each do |model_klass|
      DatabaseCleaner[:active_record, model: model_klass].strategy = :transaction
    end
  end

  # config.before(:each, type: :feature) do
  #   # :rack_test driver's Rack app under test shares database connection
  #   # with the specs, so we can use transaction strategy for speed.
  #   driver_shares_db_connection_with_specs = Capybara.current_driver == :rack_test
  #
  #   if driver_shares_db_connection_with_specs
  #     DatabaseCleaner.strategy = :transaction
  #   else
  #     # Non-:rack_test driver is probably a driver for a JavaScript browser
  #     # with a Rack app under test that does *not* share a database
  #     # connection with the specs, so we must use truncation strategy.
  #     DatabaseCleaner.strategy = :truncation
  #   end
  # end

  config.before do
    DatabaseCleaner.start
    [AllMysqlType, AllSqliteType].each do |model_klass|
      DatabaseCleaner[:active_record, model: model_klass].start
    end
  end

  config.after do
    DatabaseCleaner.clean
    [AllMysqlType, AllSqliteType].each do |model_klass|
      DatabaseCleaner[:active_record, model: model_klass].clean
    end
  end
end
