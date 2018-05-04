# NOTE: We need to require the following rails engines
# so that the main app could pick up the assets from these engines
# even if they don't appear in the `Gemfile`
require 'cancancan'
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

require 'wallaby/engine'
require 'wallaby/configuration'
require 'wallaby/configuration/models'
require 'wallaby/configuration/security'
require 'wallaby/configuration/mapping'
require 'wallaby/configuration/metadata'
require 'wallaby/configuration/pagination'
require 'wallaby/configuration/features'

require 'routes/wallaby/resources_router'
require 'tree/wallaby/node'
require 'parsers/wallaby/parser'

require 'utils/wallaby/utils'
require 'utils/wallaby/test_utils'

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

require 'concerns/wallaby/resources_helper_methods'
require 'concerns/wallaby/rails_overriden_methods'

require 'responders/wallaby/abstract_responder'
require 'responders/wallaby/resources_responder'
