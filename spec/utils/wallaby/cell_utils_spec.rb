require 'rails_helper'

describe Wallaby::CellUtils, type: :helper do
  describe '.render' do
    it 'renders a cell' do
      expect(described_class.render(helper, '/wallaby/app/views/wallaby/resources/index/integer_html.rb', value: 1_000_000)).to eq '1000000'
      expect(described_class.render(helper, 'app/views/custom/index/integer_html.rb', value: 1_000_000)).to eq '1 Million'
    end
  end

  describe '.cell?' do
    it 'checks if file ends with `.rb`' do
      expect(described_class.cell?('/wallaby/app/views/wallaby/resources/index/integer_html.rb')).to be_truthy
      expect(described_class.cell?('/wallaby/app/views/wallaby/resources/index/integer.html.erb')).to be_falsy
    end
  end
end
