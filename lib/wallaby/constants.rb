module Wallaby
  SCRIPT_NAME = 'SCRIPT_NAME'.freeze
  PATH_INFO = 'PATH_INFO'.freeze
  EMPTY_STRING = ''.freeze
  EMPTY_HASH = {}.freeze
  EMPTY_ARRAY = [].freeze
  SPACE = ' '.freeze
  SLASH = '/'.freeze
  COLONS = '::'.freeze
  COMMA = ','.freeze
  DOT = '.'.freeze
  CSV = 'csv'.freeze
  PERS = [10, 20, 50, 100].freeze
  DEFAULT_PAGE_SIZE = 20
  DEFAULT_MAX = 20
  ERRORS = %i(
    bad_request
    forbidden
    internal_server_error
    not_found
    unauthorized
    unprocessable_entity
  ).freeze
  WILDCARD = 'QUERY'.freeze
  MODEL_ACTIONS = %i(index new create show edit update destroy).freeze
  FORM_ACTIONS =
    ActiveSupport::HashWithIndifferentAccess.new(new: 'form', create: 'form', edit: 'form', update: 'form').freeze
  SAVE_ACTIONS = %w(create update).freeze
  TITLE_NAMES = %w(name title string text).freeze
  DEFAULT = 'default'.freeze
end
