require 'rails_helper'

describe Wallaby::ModelUtils do
  describe '.to_resources_name' do
    it 'handles the namespace and returns resources name for a class name' do
      expect(described_class.to_resources_name('Post')).to eq 'posts'
      expect(described_class.to_resources_name('Wallaby::Post')).to eq 'wallaby::posts'
      expect(described_class.to_resources_name('wallaby/posts')).to eq 'wallaby::posts'
      expect(described_class.to_resources_name('Person')).to eq 'people'
      expect(described_class.to_resources_name('Wallaby::Person')).to eq 'wallaby::people'
      expect(described_class.to_resources_name('wallaby/person')).to eq 'wallaby::people'
      expect(described_class.to_resources_name('Wallabies::Person')).to eq 'wallabies::people'
      expect(described_class.to_resources_name('wallabies/person')).to eq 'wallabies::people'
    end

    context 'when model_class is blank' do
      it 'returns blank string' do
        expect(described_class.to_resources_name(nil)).to eq ''
        expect(described_class.to_resources_name('')).to eq ''
        expect(described_class.to_resources_name(' ')).to eq ''

        expect(described_class.to_resources_name(false)).to eq ''
        expect(described_class.to_resources_name([])).to eq ''
        expect(described_class.to_resources_name({})).to eq ''
      end
    end
  end

  describe '.to_model_label' do
    it 'returns model label for a model class' do
      expect(described_class.to_model_label('posts')).to eq 'Post'
      expect(described_class.to_model_label('wallaby::posts')).to eq 'Wallaby / Post'
      expect(described_class.to_model_label('post')).to eq 'Post'
      expect(described_class.to_model_label('wallaby::post')).to eq 'Wallaby / Post'
      expect(described_class.to_model_label('people')).to eq 'Person'
      expect(described_class.to_model_label('wallaby::people')).to eq 'Wallaby / Person'
      expect(described_class.to_model_label('wallabies::people')).to eq 'Wallabies / Person'

      expect(described_class.to_model_label('person')).to eq 'Person'
      expect(described_class.to_model_label('wallaby::person')).to eq 'Wallaby / Person'
      expect(described_class.to_model_label('wallabies::person')).to eq 'Wallabies / Person'
    end

    context 'when model_class is blank' do
      it 'returns blank string' do
        expect(described_class.to_model_label(nil)).to eq ''
        expect(described_class.to_model_label('')).to eq ''
        expect(described_class.to_model_label(' ')).to eq ''

        expect(described_class.to_model_label(false)).to eq ''
        expect(described_class.to_model_label([])).to eq ''
        expect(described_class.to_model_label({})).to eq ''
      end
    end
  end

  describe '.to_model_name' do
    it 'returns model name for a resources name' do
      expect(described_class.to_model_name('posts')).to eq 'Post'
      expect(described_class.to_model_name('wallaby::posts')).to eq 'Wallaby::Post'
      expect(described_class.to_model_name('post')).to eq 'Post'
      expect(described_class.to_model_name('wallaby::post')).to eq 'Wallaby::Post'
      expect(described_class.to_model_name('people')).to eq 'Person'
      expect(described_class.to_model_name('wallaby::people')).to eq 'Wallaby::Person'
      expect(described_class.to_model_name('wallabies::people')).to eq 'Wallabies::Person'
    end

    context 'when resources_name is blank' do
      it 'returns blank string' do
        expect(described_class.to_model_name(nil)).to eq ''
        expect(described_class.to_model_name('')).to eq ''
        expect(described_class.to_model_name(' ')).to eq ''

        expect(described_class.to_model_name(false)).to eq ''
        expect(described_class.to_model_name([])).to eq ''
        expect(described_class.to_model_name({})).to eq ''
      end
    end
  end

  describe '.to_model_class' do
    it 'returns model class' do
      stub_const 'ActiveProduct', Class.new
      expect(described_class.to_model_class('active_products')).to eq ActiveProduct
      expect(described_class.to_model_class('ActiveProduct')).to eq ActiveProduct
    end

    context 'when resources_name is unknown' do
      it 'raises ModelNotFound error' do
        expect(described_class.to_model_class('unknown_future')).to be_nil
      end
    end

    context 'when resources_name is blank' do
      it 'returns nil' do
        expect(described_class.to_model_class(nil)).to be_nil
        expect(described_class.to_model_class('')).to be_nil
        expect(described_class.to_model_class(' ')).to be_nil

        expect(described_class.to_model_class(false)).to be_nil
        expect(described_class.to_model_class([])).to be_nil
        expect(described_class.to_model_class({})).to be_nil
      end
    end
  end
end
