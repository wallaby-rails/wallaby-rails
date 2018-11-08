class AllMysqlType < ActiveRecord::Base
  establish_connection :mysql

  if Rails::VERSION::MAJOR >= 5
    attribute :blob, :blob
    attribute :tinyblob, :tinyblob
  end
end
