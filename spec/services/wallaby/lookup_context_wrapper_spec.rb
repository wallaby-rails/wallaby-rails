require 'rails_helper'

describe Wallaby::LookupContextWrapper do
  let(:original_lookup_context) { ActionView::LookupContext.new [] }
  subject { described_class.new original_lookup_context }

  describe '.find_template' do
    context 'when template exists' do
      it 'caches the result for original lookup_context' do
        expect(original_lookup_context).to receive :find_template
        subject.find_template 'target'
        expect(subject.instance_variable_get(:@templates)).to have_key 'target'
        subject.find_template 'target'
      end
    end

    context 'when template does not exist' do
      it 'returns blank template' do
        allow(original_lookup_context).to receive(:find_template).and_raise(ActionView::MissingTemplate.new ['paths'], 'path', ['prefixes'], 'partial', 'details')
        expect(subject.find_template 'target').to be_kind_of Wallaby::LookupContextWrapper::BlankTemplate
      end
    end
  end
end
