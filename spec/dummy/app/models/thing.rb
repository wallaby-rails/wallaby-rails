# frozen_string_literal: true

class Thing < ActiveRecord::Base
  self.inheritance_column = 'sti_type'
end
