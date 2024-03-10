# frozen_string_literal: true

require 'active_model'
require 'parslet'
require 'responders'
require 'wallaby/view'

require 'wallaby/core/version'
require 'wallaby/constants'
require 'wallaby/deprecator'
require 'wallaby/logger'
require 'wallaby/preloader'
require 'wallaby/guesser'
require 'wallaby/engine'

# Global class attributes that holds the most important configuration/information
# NOTE: DO NOT store any Class in both configuration and map
require 'wallaby/classifier'
require 'wallaby/class_array'
require 'wallaby/class_hash'
require 'wallaby/configuration'
require 'wallaby/configuration/features'
require 'wallaby/configuration/mapping'
require 'wallaby/configuration/metadata'
require 'wallaby/configuration/models'
require 'wallaby/configuration/pagination'
require 'wallaby/configuration/security'
require 'wallaby/configuration/sorting'
require 'wallaby/map'

require 'support/action_dispatch/routing/mapper'

require 'routes/wallaby/resources_router'
require 'routes/wallaby/engines/base_route'
require 'routes/wallaby/engines/engine_route'
require 'routes/wallaby/engines/custom_app_route'
require 'fields/wallaby/all_fields'
require 'tree/wallaby/node'
require 'parsers/wallaby/parser'

require 'utils/wallaby/inflector'
require 'utils/wallaby/field_utils'
require 'utils/wallaby/filter_utils'
require 'utils/wallaby/locale'
require 'utils/wallaby/module_utils'
require 'utils/wallaby/params_utils'
require 'utils/wallaby/utils'

require 'concerns/wallaby/authorizable'
require 'concerns/wallaby/baseable'
require 'concerns/wallaby/configurable'
require 'concerns/wallaby/urlable'

require 'concerns/wallaby/decoratable'
require 'concerns/wallaby/engineable'
require 'concerns/wallaby/fieldable'
require 'concerns/wallaby/paginatable'
require 'concerns/wallaby/prefixable'
require 'concerns/wallaby/resourcable'
require 'concerns/wallaby/servicable'

require 'concerns/wallaby/application_concern'
require 'concerns/wallaby/authentication_concern'
require 'concerns/wallaby/resources_concern'

# These are the designed interfaces if you want to get any ORMs to work with Wallaby
require 'interfaces/wallaby/mode'
require 'interfaces/wallaby/model_decorator'
require 'interfaces/wallaby/model_finder'
require 'interfaces/wallaby/model_service_provider'
require 'interfaces/wallaby/model_pagination_provider'
require 'interfaces/wallaby/model_authorization_provider'

require 'errors/wallaby/general_error'

require 'errors/wallaby/class_not_found'
require 'errors/wallaby/invalid_error'
require 'errors/wallaby/not_implemented'
require 'errors/wallaby/not_found'
require 'errors/wallaby/method_removed'
require 'errors/wallaby/model_not_found'
require 'errors/wallaby/resource_not_found'

require 'errors/wallaby/forbidden'
require 'errors/wallaby/not_authenticated'
require 'errors/wallaby/unprocessable_entity'

require 'decorators/wallaby/resource_decorator'
require 'servicers/wallaby/model_servicer'
require 'paginators/wallaby/model_paginator'
require 'authorizers/wallaby/model_authorizer'
require 'authorizers/wallaby/default_authorization_provider'
require 'authorizers/wallaby/cancancan_authorization_provider'
require 'authorizers/wallaby/pundit_authorization_provider'

require 'forms/wallaby/form_builder'

# These are the service classes responsible
# for finding out the controller/decorator/authorizer/servicer/paginator
require 'services/wallaby/class_finder'
require 'services/wallaby/controller_finder'
require 'services/wallaby/decorator_finder'
require 'services/wallaby/authorizer_finder'
require 'services/wallaby/servicer_finder'
require 'services/wallaby/paginator_finder'
require 'services/wallaby/default_models_excluder'
require 'services/wallaby/fields_regulator'

require 'services/wallaby/map/mode_mapper'
require 'services/wallaby/map/model_class_mapper'
require 'services/wallaby/model_class_filter'
require 'services/wallaby/prefixes_builder'
require 'services/wallaby/engine_name_finder'
require 'services/wallaby/engine_url_for'
require 'services/wallaby/link_options_normalizer'
require 'services/wallaby/sorting/hash_builder'
require 'services/wallaby/sorting/next_builder'
require 'services/wallaby/sorting/single_builder'
require 'services/wallaby/sorting/link_builder'

require 'helpers/wallaby/configuration_helper'
require 'helpers/wallaby/form_helper'
require 'helpers/wallaby/index_helper'
require 'helpers/wallaby/links_helper'
require 'helpers/wallaby/styling_helper'

require 'helpers/wallaby/base_helper'
require 'helpers/wallaby/application_helper'
require 'helpers/wallaby/secure_helper'
require 'helpers/wallaby/resources_helper'

require 'responders/wallaby/resources_responder'
require 'responders/wallaby/json_api_responder'

require 'adaptors/wallaby/custom'
require 'adaptors/wallaby/custom/default_provider'
require 'adaptors/wallaby/custom/model_finder'
require 'adaptors/wallaby/custom/model_decorator'
require 'adaptors/wallaby/custom/model_pagination_provider'
require 'adaptors/wallaby/custom/model_service_provider'

module Wallaby
  # Core module that can be included by controller
  module Core
  end
end
