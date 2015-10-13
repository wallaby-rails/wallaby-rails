require 'rails_helper'

describe Wallaby::ActiveRecord::ModelDecorator::FieldsBuilder do
  subject { described_class.new post_model }
  let(:post_model) { double 'Post', primary_key: 'id' }

  describe '#general_fields' do
    it 'returns a hash using column names as keys' do
      id    = double 'id',    name: 'id',     type: :integer
      uuid  = double 'uuid',  name: 'uuid',   type: :string
      title = double 'title', name: 'title',  type: :string
      allow(post_model).to receive(:columns).and_return([ id, uuid, title ])
      allow(post_model).to receive(:human_attribute_name).and_return('fake_title')
      expect(subject.send :general_fields).to eq({
        "id"    => { type: :integer,  label: "fake_title" },
        "title" => { type: :string,   label: "fake_title" },
        "uuid"  => { type: :string,   label: "fake_title" }
      })
    end
  end

  describe '#extract_type_from' do
    it 'returns the type for general associations' do
      types = %w( has_many has_one belongs_to has_and_belongs_to_many )
      allow(post_model).to receive(:pluralize_table_names)
      ActiveRecord::Reflection::AssociationReflection.subclasses.each_with_index do |klass, index|
        association = klass.new 'fake', nil, {}, post_model
        expect(subject.send :extract_type_from, association).to eq types[index]
      end
    end

    it 'returns the type for through associations' do
      has_many_association = double 'ActiveRecord::Reflection::HasManyReflection', class: double('class', name: 'HasManyReflection')
      expect(subject.send :extract_type_from, has_many_association).to eq 'has_many'

      through_association = double 'Through',
        class: double('class', name: 'ActiveRecord::Reflection::ThroughReflection'),
        delegate_reflection: has_many_association
      expect(subject.send :extract_type_from, through_association).to eq 'has_many'
    end
  end
end