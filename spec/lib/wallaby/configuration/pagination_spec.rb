require 'rails_helper'

describe Wallaby::Configuration::Pagination do
  describe '#page_size' do
    it 'returns page_size' do
      expect(subject.page_size).to eq Wallaby::DEFAULT_PAGE_SIZE
      subject.page_size = 50
      expect(subject.page_size).to eq 50
    end
  end
end
