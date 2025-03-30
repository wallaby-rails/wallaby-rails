# frozen_string_literal: true

class BaseSqlite < ActiveRecord::Base
  self.abstract_class = true
  connects_to database: { writing: :sqlite, reading: :sqlite }
end
