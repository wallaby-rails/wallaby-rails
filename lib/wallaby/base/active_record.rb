require 'kaminari'
require 'adaptors/wallaby/active_record'
require 'adaptors/wallaby/active_record/model_decorator'
require 'adaptors/wallaby/active_record/model_decorator/title_field_finder'

fields_builder = 'adaptors/wallaby/active_record/model_decorator/fields_builder'
require fields_builder
require "#{fields_builder}/sti_builder"
require "#{fields_builder}/association_builder"
require "#{fields_builder}/polymorphic_builder"

require 'adaptors/wallaby/active_record/model_finder'
require 'adaptors/wallaby/active_record/model_pagination_provider'

service_provider = 'adaptors/wallaby/active_record/model_service_provider'
require service_provider
require "#{service_provider}/normalizer"
require "#{service_provider}/permitter"
require "#{service_provider}/querier"
require "#{service_provider}/querier/transformer"
require "#{service_provider}/validator"
