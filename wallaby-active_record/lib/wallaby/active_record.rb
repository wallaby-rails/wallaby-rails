# frozen_string_literal: true

require 'wallaby/core'

require 'wallaby/active_record/version'

# All files required for ActiveRecord ORM
require 'adapters/wallaby/active_record'
require 'adapters/wallaby/active_record/model_finder'

# ModelPaginationProvider: begin
require 'adapters/wallaby/active_record/model_pagination_provider'
# ModelPaginationProvider: end

# ModelDecorator: begin
require 'adapters/wallaby/active_record/model_decorator'
require 'adapters/wallaby/active_record/model_decorator/title_field_finder'
require 'adapters/wallaby/active_record/model_decorator/fields_builder'
require 'adapters/wallaby/active_record/model_decorator/fields_builder/sti_builder'
require 'adapters/wallaby/active_record/model_decorator/fields_builder/association_builder'
require 'adapters/wallaby/active_record/model_decorator/fields_builder/polymorphic_builder'
# ModelDecorator: end

# ModelServiceProvider: begin
require 'adapters/wallaby/active_record/model_service_provider'
require 'adapters/wallaby/active_record/model_service_provider/normalizer'
require 'adapters/wallaby/active_record/model_service_provider/permitter'
require 'adapters/wallaby/active_record/model_service_provider/querier'
require 'adapters/wallaby/active_record/model_service_provider/querier/escaper'
require 'adapters/wallaby/active_record/model_service_provider/querier/transformer'
require 'adapters/wallaby/active_record/model_service_provider/querier/wrapper'
require 'adapters/wallaby/active_record/model_service_provider/validator'
# ModelServiceProvider: end

# AuthorizationProvider: begin
require 'adapters/wallaby/active_record/default_provider'
require 'adapters/wallaby/active_record/cancancan_provider'
require 'adapters/wallaby/active_record/pundit_provider'
# AuthorizationProvider: end
