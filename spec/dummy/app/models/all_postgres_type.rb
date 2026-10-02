# frozen_string_literal: true

class AllPostgresType < ActiveRecord::Base
  # NOTE: Pinned to PostgreSQL so its PostgreSQL-only columns work regardless of
  # which adapter `DB` selects for the default connection.
  establish_connection :postgresql
end
