require 'rails_helper'

describe Wallaby::Cell, type: :helper do
  subject { described_class.new helper, object: AllPostgresType.new }

  describe 'attributes' do
    it 'reads and writes to attributes' do
      field_name = 'string'
      value = 'a string'
      object = AllPostgresType.new field_name => value
      metadata = {}
      form = Wallaby::FormBuilder.new 'all_postgres_type', object, helper, {}
      subject = described_class.new helper, object: object, field_name: field_name, value: value, metadata: metadata, form: form
      expect(subject.object).to eq object
      expect(subject.field_name).to eq field_name
      expect(subject.value).to eq value
      expect(subject.metadata).to eq metadata
      expect(subject.form).to eq form

      subject.object = 'object'
      expect(subject.object).to eq 'object'
      subject.field_name = 'field_name'
      expect(subject.field_name).to eq 'field_name'
      subject.value = 'value'
      expect(subject.value).to eq 'value'
      subject.metadata = 'metadata'
      expect(subject.metadata).to eq 'metadata'
      subject.form = 'form'
      expect(subject.form).to eq 'form'
    end
  end

  describe '#at' do
    it 'sets/gets value' do
      subject.at 'test', 'something'
      expect(subject.at('test')).to eq 'something'
    end
  end

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
      expect(subject).to respond_to(:raw)
      expect(subject).to respond_to(:local_assigns)
      expect(subject).not_to respond_to(:unknown)
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
