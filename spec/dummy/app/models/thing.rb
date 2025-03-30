# frozen_string_literal: true

class Thing < ApplicationRecord
  self.inheritance_column = 'sti_type'
end
