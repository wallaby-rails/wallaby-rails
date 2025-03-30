# frozen_string_literal: true

class BaseMysql < ActiveRecord::Base
  self.abstract_class = true
  connects_to database: { writing: :mysql, reading: :mysql }
end
