require 'rails_helper'

describe Wallaby::Utils do
  describe '.to_resources_name' do
    it 'handles the namespace and returns resources name for a class name' do
      expect(described_class.to_resources_name 'Post').to eq 'posts'
      expect(described_class.to_resources_name 'Wallaby::Post').to eq 'wallaby::posts'
      expect(described_class.to_resources_name 'wallaby/posts').to eq 'wallaby::posts'
      expect(described_class.to_resources_name 'Person').to eq 'people'
      expect(described_class.to_resources_name 'Wallaby::Person').to eq 'wallaby::people'
      expect(described_class.to_resources_name 'wallaby/person').to eq 'wallaby::people'
    end
  end

  describe '.to_model_name' do
    it 'returns model name for a resources name' do
      expect(described_class.to_model_name 'posts').to eq 'Post'
      expect(described_class.to_model_name 'wallaby::posts').to eq 'Wallaby::Post'
      expect(described_class.to_model_name 'post').to eq 'Post'
      expect(described_class.to_model_name 'wallaby::post').to eq 'Wallaby::Post'
      expect(described_class.to_model_name 'people').to eq 'Person'
      expect(described_class.to_model_name 'wallaby::people').to eq 'Wallaby::Person'
    end
  end

  describe '.to_model_label' do
    it 'returns model label for a model class' do
      expect(described_class.to_model_label 'posts').to eq 'Post'
      expect(described_class.to_model_label 'wallaby::posts').to eq 'Wallaby / Post'
      expect(described_class.to_model_label 'post').to eq 'Post'
      expect(described_class.to_model_label 'wallaby::post').to eq 'Wallaby / Post'
      expect(described_class.to_model_label 'people').to eq 'Person'
      expect(described_class.to_model_label 'wallaby::people').to eq 'Wallaby / Person'

      expect(described_class.to_model_label 'person').to eq 'Person'
      expect(described_class.to_model_label 'wallaby::person').to eq 'Wallaby / Person'
    end
  end

  describe '.to_model_class' do
    it 'returns model class' do
      class ActiveProduct; end
      expect(described_class.to_model_class 'active_products').to eq ActiveProduct
    end

    context 'when resources_name is unknown' do
      expect{ described_class.to_model_class 'unknown' }.to raise_error Wallaby::ModelNotFound
    end
  end
end
