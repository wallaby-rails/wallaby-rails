module Wallaby
  EMPTY_STRING = ''.freeze
  EMPTY_HASH = {}.freeze
  EMPTY_ARRAY = [].freeze
  SPACE = ' '.freeze
  SLASH = '/'.freeze
  COLONS = '::'.freeze
  COMMA = ','.freeze
  DOT = '.'.freeze

  # Default page size for {Wallaby::Configuration::Pagination#page_size}
  DEFAULT_PAGE_SIZE = 20
  # Default max charactoers to display for {Wallaby::Configuration::Metadata#max}
  DEFAULT_MAX = 20
  # Default provider name for authorizer sorting.
  DEFAULT_PROVIDER = 'default'.freeze

  ERRORS = %i(
    bad_request
    forbidden
    internal_server_error
    not_found
    unauthorized
    unprocessable_entity
  ).freeze
  MODEL_ACTIONS = %i(index new create show edit update destroy).freeze
  FORM_ACTIONS =
    ActiveSupport::HashWithIndifferentAccess.new(new: 'form', create: 'form', edit: 'form', update: 'form').freeze
  SAVE_ACTIONS = %w(create update).freeze

  SCRIPT_NAME = 'SCRIPT_NAME'.freeze
  PATH_INFO = 'PATH_INFO'.freeze
  # Page size list
  # @see Wallaby::Configuration::Pagination#page_size
  PERS = [10, 20, 50, 100].freeze
  CSV = 'csv'.freeze
  WILDCARD = 'QUERY'.freeze
  TITLE_NAMES = %w(name title string text).freeze

  # A constant of error path for error handling
  ERROR_PATH = 'error'.freeze
end
