# NOTE: We need to require the following rails engines
# so that the main app could pick up the assets from these engines
# even if they don't appear in the `Gemfile`
require 'devise'
require 'cancancan'
require 'kaminari'

require 'sass-rails'
require 'bootstrap-sass'
require 'bootstrap3-datetimepicker-rails'
require 'codemirror-rails'
require 'jquery-minicolors-rails'
require 'jquery-rails'
require 'momentjs-rails'
require 'rails-bootstrap-markdown'
require 'summernote-rails'

module Wallaby
  # Rails engine
  class Engine < ::Rails::Engine
    # isolate_namespace Wallaby
    initializer 'wallaby.deflate' do |app|
      app.config.middleware.use Rack::Deflater
    end

    initializer 'wallaby.initialize_cache' do |_app|
      # TODO: optimize performance here
      Map.clear
      ::Rails.cache.delete_matched 'wallaby/*'

      ::ActionView::Template.class_eval do
        register_template_handler :erb, CachedCompiledErb.new
      end
    end

    initializer 'wallaby.assets.precompile' do |app|
      app.config.assets.precompile += %w[wallaby/form.js wallaby/form.css]
      app.config.assets.precompile += %w[codemirror* codemirror/**/*]
    end
  end
end

require 'wallaby/configuration'

require 'utils/wallaby/utils'

require 'interfaces/wallaby/mode'
require 'interfaces/wallaby/model_decorator'
require 'interfaces/wallaby/model_finder'
require 'interfaces/wallaby/model_handler'

require 'errors/wallaby/general_error'
require 'errors/wallaby/deprecated'
require 'errors/wallaby/invalid_error'
require 'errors/wallaby/model_not_found'
require 'errors/wallaby/not_authenticated'
require 'errors/wallaby/not_implemented'
require 'errors/wallaby/operation_not_found'
require 'errors/wallaby/resource_not_found'

require 'adaptors/wallaby/active_record'
require 'adaptors/wallaby/active_record/model_decorator'
require 'adaptors/wallaby/active_record/model_decorator/fields_builder'
require 'adaptors/wallaby/active_record/model_decorator/title_field_finder'
require 'adaptors/wallaby/active_record/model_finder'
require 'adaptors/wallaby/active_record/model_handler'
require 'adaptors/wallaby/active_record/model_handler/normalizer'
require 'adaptors/wallaby/active_record/model_handler/permitter'
require 'adaptors/wallaby/active_record/model_handler/querier'
require 'adaptors/wallaby/active_record/model_handler/validator'

require 'decorators/wallaby/resource_decorator'

require 'forms/wallaby/form_builder'

require 'handlers/wallaby/cached_compiled_erb'

require 'services/wallaby/map'
require 'services/wallaby/map/mode_mapper'
require 'services/wallaby/map/model_class_collector'
require 'services/wallaby/map/model_class_mapper'
require 'services/wallaby/lookup_context_wrapper'
require 'services/wallaby/model_servicer'
require 'services/wallaby/prefixes_builder'
require 'services/wallaby/sorting/hash_builder'
require 'services/wallaby/sorting/next_builder'

require 'helpers/wallaby/form_helper'
require 'helpers/wallaby/links_helper'
require 'helpers/wallaby/paginatable_helper'
require 'helpers/wallaby/sorting_helper'
require 'helpers/wallaby/styling_helper'

require 'helpers/wallaby/resources_helper'
require 'helpers/wallaby/core_helper'
require 'helpers/wallaby/secure_helper'
require 'helpers/wallaby/application_helper'
