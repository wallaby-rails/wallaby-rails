require 'rails_helper'

describe Wallaby::ActiveRecord::ModelDecorator::TitleFieldFinder do
  subject { described_class.new model_class, fields }

  let(:model_class) do
    Class.new ActiveRecord::Base do
      def self.name
        'Product'
      end
    end
  end

  describe '#find' do
    context 'when the model has no string columns' do
      let(:fields) do
        {
          'stock' => { name: 'stock', type: 'integer', label: 'Stock' }
        }
      end

      it 'returns primary_key' do
        expect(model_class.primary_key).to eq 'id'
        expect(subject.find).to eq model_class.primary_key
      end
    end

    context 'when the model has string columns' do
      let(:fields) do
        {
          'id'    => { name: 'id',     type: 'integer', label: 'ID' },
          'uuid'  => { name: 'uuid',   type: 'string',  label: 'UUID' },
          'name'  => { name: 'name',   type: 'string',  label: 'Name' },
          'title' => { name: 'title',  type: 'string',  label: 'Title' }
        }
      end

      it 'returns only the first string column name' do
        expect(subject.find).to eq 'name'
      end
    end
  end
end
