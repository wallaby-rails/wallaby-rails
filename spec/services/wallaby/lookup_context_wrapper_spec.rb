require 'rails_helper'

describe Wallaby::LookupContextWrapper do
  let(:original_lookup_context) { double 'Original lookup context' }
  subject { described_class.new original_lookup_context }

  describe '.find_template' do
    it 'cache the result for original lookup_context' do
      allow(original_lookup_context).to receive(:find_template)
      subject.find_template 'target'
      expect(subject.instance_variable_get(:@templates)).to have_key 'target'
    end
  end
end