# NOTE: We need to require the following rails engines
# so that the main app could pick up the assets from these engines
# even if they don't appear in the `Gemfile`
require 'cancancan'
require 'kaminari'
require 'parslet'
require 'responders'
require 'jbuilder'

require 'sass-rails'

require 'bootstrap-sass'
require 'font-awesome-sass'
require 'bootstrap3-datetimepicker-rails'
require 'codemirror-rails'
require 'jquery-minicolors-rails'
require 'jquery-rails'
require 'momentjs-rails'
require 'summernote-rails'
require 'twitter-typeahead-rails'

require 'csv'
require 'securerandom'

module Wallaby
  # @private
  class Engine < ::Rails::Engine
    initializer 'wallaby.deflate' do |_|
      # default to Gzip HTML
      config.middleware.use Rack::Deflater
    end

    initializer 'wallaby.assets.precompile' do |_|
      config.assets.precompile +=
        %w(
          codemirror* codemirror/**/*
          wallaby/404.png wallaby/422.png wallaby/500.png
          turbolinks
        )
    end

    initializer 'wallaby.development.reload' do |_|
      # NOTE: Rails reload! will hit here
      # @see http://rmosolgo.github.io/blog/2017/04/12/watching-files-during-rails-development/
      config.to_prepare do
        if Rails.env.development? || Rails.configuration.eager_load
          Rails.logger.debug '  [WALLABY] Reloading...'
          ::Wallaby::Map.clear
          ::Wallaby::Utils.preload_all
        end
      end
    end

    config.before_eager_load do
      # We need to ensure that the core models are loaded before anything else
      Rails.logger.debug '  [WALLABY] Preload all model files.'
      ::Wallaby::Utils.preload 'app/models/**/*.rb'
    end

    config.after_initialize do
      # Preload the rest files
      unless Rails.env.development? || Rails.configuration.eager_load
        Rails.logger.debug '  [WALLABY] Preload files after initialize.'
        ::Wallaby::Utils.preload_all
      end
    end
  end
end

require 'wallaby/configuration'
require 'wallaby/configuration/models'
require 'wallaby/configuration/security'
require 'wallaby/configuration/metadata'
require 'wallaby/configuration/pagination'
require 'wallaby/configuration/features'

require 'utils/wallaby/utils'
require 'routes/wallaby/resources_router'
require 'tree/wallaby/node'

require 'interfaces/wallaby/mode'
require 'interfaces/wallaby/model_decorator/field_helpers'
require 'interfaces/wallaby/model_decorator'
require 'interfaces/wallaby/model_finder'
require 'interfaces/wallaby/model_service_provider'
require 'interfaces/wallaby/model_pagination_provider'

require 'errors/wallaby/general_error'
require 'errors/wallaby/invalid_error'
require 'errors/wallaby/not_found'
require 'errors/wallaby/model_not_found'
require 'errors/wallaby/not_authenticated'
require 'errors/wallaby/not_implemented'
require 'errors/wallaby/resource_not_found'
require 'errors/wallaby/unprocessable_entity'

require 'parsers/wallaby/parser'

require 'adaptors/wallaby/active_record'
require 'adaptors/wallaby/active_record/model_decorator'
fields_builder = 'adaptors/wallaby/active_record/model_decorator/fields_builder'
require fields_builder
require "#{fields_builder}/sti_builder"
require "#{fields_builder}/association_builder"
require "#{fields_builder}/polymorphic_builder"
require 'adaptors/wallaby/active_record/model_decorator/title_field_finder'
require 'adaptors/wallaby/active_record/model_finder'
require 'adaptors/wallaby/active_record/model_pagination_provider'
service_provider = 'adaptors/wallaby/active_record/model_service_provider'
require service_provider
require "#{service_provider}/normalizer"
require "#{service_provider}/permitter"
require "#{service_provider}/querier"
require "#{service_provider}/querier/transformer"
require "#{service_provider}/validator"

require 'paginators/wallaby/abstract_resource_paginator'
require 'paginators/wallaby/resource_paginator'
require 'decorators/wallaby/abstract_resource_decorator'
require 'decorators/wallaby/resource_decorator'
require 'servicers/wallaby/abstract_model_servicer'
require 'servicers/wallaby/model_servicer'

require 'forms/wallaby/form_builder'

require 'services/wallaby/map'
require 'services/wallaby/map/mode_mapper'
require 'services/wallaby/map/model_class_collector'
require 'services/wallaby/map/model_class_mapper'
require 'services/wallaby/lookup_context_wrapper'
require 'services/wallaby/prefixes_builder'
require 'services/wallaby/url_for'
require 'services/wallaby/partial_renderer'
require 'services/wallaby/link_options_normalizer'
require 'services/wallaby/sorting/hash_builder'
require 'services/wallaby/sorting/next_builder'
require 'services/wallaby/sorting/link_builder'

require 'helpers/wallaby/form_helper'
require 'helpers/wallaby/links_helper'
require 'helpers/wallaby/styling_helper'
require 'helpers/wallaby/index_helper'

require 'helpers/wallaby/resources_helper'
require 'helpers/wallaby/base_helper'
require 'helpers/wallaby/secure_helper'
require 'helpers/wallaby/application_helper'

require 'responders/wallaby/abstract_responder'
require 'responders/wallaby/resources_responder'
