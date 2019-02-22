require 'rails_helper'

describe Wallaby::CustomPartialRenderer, type: :helper do
  subject { described_class.new helper.lookup_context }

  describe '#render' do
    it 'renders cell', prefixes: ['wallaby/resources/index'] do
      expect(subject.render(helper, { partial: 'integer', locals: { value: 100 } }, -> {})).to eq '100'
    end

    it 'renders partial', prefixes: ['wallaby/resources/show'] do
      expect(subject.render(helper, { partial: 'integer', locals: { value: 100 } }, -> {})).to eq "100\n"
    end
  end
end
