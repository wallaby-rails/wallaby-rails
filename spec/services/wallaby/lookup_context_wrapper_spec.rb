require 'rails_helper'

describe Wallaby::LookupContextWrapper do
  let(:original_lookup_context) { ActionView::LookupContext.new(Wallaby::Engine.root + 'app/views') }
  subject { described_class.new original_lookup_context }

  describe '.find_template' do
    context 'when template exists' do
      it 'caches the result for original lookup_context' do
        template = subject.find_template('string', ['wallaby/resources/index'], true)
        expect(template.virtual_path).to eq 'wallaby/resources/index/_string'
      end
    end

    context 'when template does not exist' do
      it 'returns blank template' do
        expect(subject.find_template('target')).to be_kind_of Wallaby::LookupContextWrapper::BlankTemplate
      end
    end
  end
end
