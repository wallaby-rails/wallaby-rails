require 'rails_helper'

describe Wallaby::Cell, type: :helper do
  subject { described_class.new helper, object: AllPostgresType.new }

  describe '#concat' do
    it 'buffers the string' do
      subject.concat 'test'
      expect(subject.buffer).to eq 'test'

      subject.concat ' continue'
      expect(subject.buffer).to eq 'test continue'
    end
  end

  describe '#respond_to_missing?' do
    it 'responds to view methods' do
      expect(subject.respond_to?(:raw)).to be_truthy
      expect(subject.respond_to?(:local_assigns)).to be_truthy
      expect(subject.respond_to?(:unknown)).to be_falsy
    end
  end
end

describe Wallaby::Resources::Index::StringHtml, type: :helper do
  subject { described_class.new helper, object: AllPostgresType.new, value: value, metadata: {}, field_name: 'string' }
  let(:value) { 'test' }

  describe '#render_complete' do
    it 'renders' do
      expect(subject.render_complete).to eq value
    end
  end
end
