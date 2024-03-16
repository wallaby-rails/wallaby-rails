# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::Custom::ModelPaginationProvider, type: :helper do
  subject { described_class.new Product, {} }

  describe '#paginatable?' do
    it 'returns false' do
      expect(subject).not_to be_paginatable
    end
  end
end
