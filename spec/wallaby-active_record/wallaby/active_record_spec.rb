# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Wallaby::ActiveRecord do
  it 'has a version number' do
    expect(Wallaby::ActiveRecordGem::VERSION).not_to be nil
  end
end
