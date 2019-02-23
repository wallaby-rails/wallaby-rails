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

    it 'renders cell before partial', prefixes: ['custom/index'] do
      expect(subject.render(helper, { partial: 'integer', locals: { value: 1000000 } }, -> {})).to eq '1 Million'
    end

    it 'renders cell by precedence', prefixes: ['custom/index', 'wallaby/resources/index'] do
      expect(subject.render(helper, { partial: 'integer', locals: { value: 1000000 } }, -> {})).to eq '1 Million'
    end
  end
end
