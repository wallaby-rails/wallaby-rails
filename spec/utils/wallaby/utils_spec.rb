require 'rails_helper'

describe Wallaby::Utils, clear: :object_space do
  describe '.engine_name_from' do
    # @see spec/dummy/config/routes.rb
    it 'returns the name/alias of an engine' do
      expect(described_class.engine_name_from('SCRIPT_NAME' => '')).to eq ''
      expect(described_class.engine_name_from('SCRIPT_NAME' => '/admin')).to eq 'wallaby_engine'
      expect(described_class.engine_name_from('SCRIPT_NAME' => '/admin_else')).to eq 'manager_engine'
      expect(described_class.engine_name_from('SCRIPT_NAME' => '/core/admin')).to eq 'core_nested_engine'
      expect(described_class.engine_name_from('SCRIPT_NAME' => '/main/admin')).to eq 'main_engine'
    end
  end

  describe '.anonymous_class?' do
    it 'checks whether a class is anonymous' do
      expect(described_class.anonymous_class?(Product)).to be_falsy
      expect(described_class.anonymous_class?(Class.new)).to be_truthy
    end
  end

  describe '.translate_class' do
    it 'translates a message for a method' do
      expect(described_class.translate_class(Wallaby::Map::ModelClassMapper.new(ActiveRecord::Base), :missing_model_class, model: Product)).to eq "[WALLABY] Please define self.model_class for Product or set it as global.\n          @see Wallaby.configuration.mapping"
      expect(described_class.translate_class(Wallaby::Map::ModelClassMapper, :missing_model_class, model: Product)).to eq "[WALLABY] Please define self.model_class for Product or set it as global.\n          @see Wallaby.configuration.mapping"
    end
  end

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
        expect { described_class.to_model_class('unknown_future') }.to raise_error Wallaby::ModelNotFound
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

  describe '.find_filter_name' do
    it 'returns filter name' do
      expect(described_class.find_filter_name(nil, {})).to eq :all
      expect(described_class.find_filter_name(:featured, {})).to eq :featured
      expect(described_class.find_filter_name(nil, featured: { default: true })).to eq :featured
    end
  end

  describe '.to_field_label' do
    it 'returns label' do
      expect(described_class.to_field_label(:something, {})).to eq 'Something'
      expect(described_class.to_field_label(:something, label: 'Else')).to eq 'Else'
    end
  end
end
