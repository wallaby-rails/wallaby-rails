# All files here is for HER ORM
require 'her'
require 'adaptors/wallaby/her'
require 'adaptors/wallaby/her/model_finder'

# ModelDecorator: begin
require 'adaptors/wallaby/her/model_decorator'
# ModelDecorator: end

# ModelPaginationProvider: begin
require 'adaptors/wallaby/her/model_pagination_provider'
# ModelPaginationProvider: end

# ModelServiceProvider: begin
require 'adaptors/wallaby/her/model_service_provider'
# ModelServiceProvider: end

# AuthorizationProvider: begin
require 'adaptors/wallaby/her/default_provider'
require 'adaptors/wallaby/her/cancancan_provider'
require 'adaptors/wallaby/her/pundit_provider'
# AuthorizationProvider: end
