module Wallaby
  EMPTY_STRING = ''.freeze
  SPACE = ' '.freeze
  SLASH = '/'.freeze
  COLONS = '::'.freeze
  COMMA = ','.freeze
  CSV = 'csv'.freeze
  PERS = [10, 20, 50, 100].freeze
  DEFAULT_PAGE_SIZE = 20
  ERRORS = %i(
    bad_request
    forbidden
    internal_server_error
    not_found
    unauthorized
    unprocessable_entity
  ).freeze
end

require 'wallaby/engine'
