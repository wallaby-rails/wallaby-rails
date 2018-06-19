# All files required for ActiveRecord ORM
require 'kaminari'
require 'adaptors/wallaby/active_record'

require 'adaptors/wallaby/active_record/model_finder'
require 'adaptors/wallaby/active_record/model_pagination_provider'

# ModelDecorator: begin
require 'adaptors/wallaby/active_record/model_decorator'
require 'adaptors/wallaby/active_record/model_decorator/title_field_finder'
require 'adaptors/wallaby/active_record/model_decorator/fields_builder'
require 'adaptors/wallaby/active_record/model_decorator/fields_builder/sti_builder'
require 'adaptors/wallaby/active_record/model_decorator/fields_builder/association_builder'
require 'adaptors/wallaby/active_record/model_decorator/fields_builder/polymorphic_builder'
# ModelDecorator: end

# ModelServiceProvider: begin
require 'adaptors/wallaby/active_record/model_service_provider'
require 'adaptors/wallaby/active_record/model_service_provider/normalizer'
require 'adaptors/wallaby/active_record/model_service_provider/permitter'
require 'adaptors/wallaby/active_record/model_service_provider/querier'
require 'adaptors/wallaby/active_record/model_service_provider/querier/transformer'
require 'adaptors/wallaby/active_record/model_service_provider/validator'
# ModelServiceProvider: end

# AuthorizationProvider: begin
require 'adaptors/wallaby/active_record/default_provider'
require 'adaptors/wallaby/active_record/cancancan_provider'
require 'adaptors/wallaby/active_record/pundit_provider'
# AuthorizationProvider: end
