# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::ModelPaginationProvider do
  subject { described_class.new AllPostgresType.all, parameters }

  %w[paginatable? first_page? prev_page? last_page? next_page? from to total page_size page_number last_page_number prev_page_number next_page_number number_of_pages].each do |method|
    describe "##{method}" do
      it 'raises not implemented' do
        expect { subject.public_send method }.to raise_error Wallaby::NotImplemented
      end
    end
  end

  describe '#first_page_number' do
    it 'returns 1' do
      expect(subject.first_page_number).to eq 1
    end
  end
end
