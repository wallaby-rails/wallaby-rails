# frozen_string_literal: true

module Wallaby
  # Wallaby engine
  class Engine < ::Rails::Engine
    initializer 'wallaby.development.reload' do |_|
      # NOTE: Rails reload! will hit here
      # @see https://rmosolgo.github.io/ruby/rails/2017/04/12/watching-files-during-rails-development.html
      config.to_prepare do
        Map.clear if Rails.env.development? || Rails.configuration.eager_load
      end
    end
  end
end
