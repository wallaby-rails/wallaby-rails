# frozen_string_literal: true

module Wallaby
  EMPTY_STRING = ''.html_safe.freeze # :nodoc:
  EMPTY_HASH = {}.freeze # :nodoc:
  EMPTY_ARRAY = [].freeze # :nodoc:
  SPACE = ' ' # :nodoc:
  SLASH = '/' # :nodoc:
  COLONS = '::' # :nodoc:
  COMMA = ',' # :nodoc:
  DOT = '.' # :nodoc:
  HASH = '#' # :nodoc:
  HYPHEN = '-' # :nodoc:
  UNDERSCORE = '_' # :nodoc:
  PCT = '%' # :nodoc:

  # Default page size for {Configuration::Pagination#page_size}
  DEFAULT_PAGE_SIZE = 20
  # Default max charactoers to display for {Configuration::Metadata#max}
  DEFAULT_MAX = 20
  # Default provider name for authorizer sorting.
  DEFAULT_PROVIDER = 'default'

  # HTTP error types that Wallaby handles
  ERRORS = %i[
    bad_request
    forbidden
    internal_server_error
    not_found
    not_implemented
    unauthorized
    unprocessable_entity
  ].freeze
  MODEL_ACTIONS = %i[index new create show edit update destroy].freeze
  FORM_ACTIONS = { new: 'form', create: 'form', edit: 'form', update: 'form' }.with_indifferent_access.freeze
  SAVE_ACTIONS = %w[create update].freeze

  SCRIPT_NAME = 'SCRIPT_NAME' # :nodoc:
  PATH_INFO = 'PATH_INFO' # :nodoc:
  # Page size list
  # @see Configuration::Pagination#page_size
  PERS = [10, 20, 50, 100].freeze
  CSV = 'csv' # :nodoc:
  WILDCARD = 'QUERY' # :nodoc:

  # A constant of error path for error handling
  ERROR_PATH = 'error'

  CONTROLLER = 'Controller' # :nodoc:
  DECORATOR = 'Decorator' # :nodoc:
  SERVICER = 'Servicer' # :nodoc:
  AUTHORIZER = 'Authorizer' # :nodoc:
  PAGINATOR = 'Paginator' # :nodoc:
  FINDER = 'Finder' # :nodoc:
end
