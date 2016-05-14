require 'rails_helper'

describe Wallaby::PaginatableHelper do
  describe '#paginatable?' do
    it 'returns true' do
      stub_const 'Kaminari', Class.new

      collection = double 'collection', present: true, total_pages: true
      expect(helper.paginatable? collection).to be_truthy
    end

    it 'returns false' do
      collection = []
      hide_const 'Kaminari'
      expect(helper.paginatable? collection).to be_falsy

      stub_const 'Kaminari', Class.new
      expect(helper.paginatable? collection).to be_falsy

      collection = double 'collection', present: true
      expect(helper.paginatable? collection).to be_falsy
    end
  end

  describe '#custom_pagination_stats' do
    it 'returns the count for collection' do
      expect(helper.custom_pagination_stats []).to eq "Showing <b>0</b>"
      expect(helper.custom_pagination_stats [1]).to eq "Showing <b>1</b>"
    end
  end
end
