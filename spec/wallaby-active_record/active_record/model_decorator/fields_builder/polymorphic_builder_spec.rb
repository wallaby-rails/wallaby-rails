# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::ActiveRecord::ModelDecorator::FieldsBuilder::PolymorphicBuilder do
  subject { described_class.new }

  context 'when not polymorphic' do
    let(:model_class) do
      Class.new(ActiveRecord::Base) do
        self.table_name = 'products'
        def self.name
          'Product'
        end
      end
    end

    it 'returns class' do
      metadata = {}
      model_class.belongs_to :category
      expect { subject.update(metadata, model_class.reflections['category']) }.to change { metadata }.to(class: Category)
    end
  end

  context 'when polymorphic' do
    let(:model_class) do
      Class.new(ActiveRecord::Base) do
        self.table_name = 'pictures'
        def self.name
          'Picture'
        end
      end
    end

    it 'returns metadata' do
      metadata = {}
      model_class.belongs_to :imageable, polymorphic: true
      subject.update(metadata, model_class.reflections['imageable'])
      expect(metadata[:is_polymorphic]).to be_truthy
      expect(metadata[:polymorphic_type]).to eq 'imageable_type'
      expect(metadata[:polymorphic_list]).to eq [Product]
    end
  end
end
