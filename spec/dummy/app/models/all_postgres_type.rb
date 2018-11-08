class AllPostgresType < ActiveRecord::Base
  if Rails::VERSION::MAJOR >= 5
    attribute :bigserial, :bigserial
    attribute :box, :box
    attribute :circle, :circle
    attribute :line, :line
    attribute :lseg, :lseg
    attribute :path, :path
    attribute :point, :point
    attribute :polygon, :polygon
    attribute :serial, :serial
  end
end
