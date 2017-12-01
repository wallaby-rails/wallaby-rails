# NOTE: We need to require the following rails engines
# so that the main app could pick up the assets from these engines
# even if they don't appear in the `Gemfile`
require 'cancancan'
require 'kaminari'
require 'parslet'
require 'responders'
require 'jbuilder'

require 'sass-rails'

require 'turbolinks'
require 'jquery-turbolinks'
require 'bootstrap-sass'
require 'font-awesome-rails'
require 'bootstrap3-datetimepicker-rails'
require 'codemirror-rails'
require 'jquery-minicolors-rails'
require 'jquery-rails'
require 'momentjs-rails'
require 'summernote-rails'
require 'twitter-typeahead-rails'

require 'csv'

module Wallaby
  # Rails engine
  class Engine < ::Rails::Engine
    # isolate_namespace Wallaby

    initializer 'wallaby.deflate' do |app|
      # default to Gzip HTML
      app.config.middleware.use Rack::Deflater
    end

    initializer 'wallaby.assets.precompile' do |app|
      app.config.assets.precompile +=
        %w(
          codemirror* codemirror/**/*
          wallaby/404.png wallaby/422.png wallaby/500.png
        )
    end

    config.after_initialize do
      Map.clear
    end
  end
end

require 'wallaby/configuration'

require 'utils/wallaby/utils'
require 'tree/wallaby/node'

require 'interfaces/wallaby/mode'
require 'interfaces/wallaby/model_decorator'
require 'interfaces/wallaby/model_finder'
require 'interfaces/wallaby/model_service_provider'
require 'interfaces/wallaby/model_pagination_provider'

require 'nils/wallaby/nil_model_decorator'

require 'errors/wallaby/general_error'
require 'errors/wallaby/deprecated'
require 'errors/wallaby/invalid_error'
require 'errors/wallaby/not_found'
require 'errors/wallaby/model_not_found'
require 'errors/wallaby/not_authenticated'
require 'errors/wallaby/not_implemented'
require 'errors/wallaby/resource_not_found'

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
require 'services/wallaby/sorting/hash_builder'
require 'services/wallaby/sorting/next_builder'

require 'helpers/wallaby/form_helper'
require 'helpers/wallaby/links_helper'
require 'helpers/wallaby/paginatable_helper'
require 'helpers/wallaby/sorting_helper'
require 'helpers/wallaby/styling_helper'
require 'helpers/wallaby/index_helper'

require 'helpers/wallaby/resources_helper'
require 'helpers/wallaby/base_helper'
require 'helpers/wallaby/secure_helper'
require 'helpers/wallaby/application_helper'

require 'responders/wallaby/abstract_responder'
require 'responders/wallaby/resources_responder'
