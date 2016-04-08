require 'rails_helper'

describe Wallaby::DecoratorFinder, clear: :object_space do
  describe '.find_model' do
    let(:model_class) { Category }

    it 'returns Wallaby::ModelDecorator by default' do
      model_decorator = described_class.find_model model_class
      expect(model_decorator).to be_a Wallaby::ModelDecorator
      expect(model_decorator.model_class).to eq model_class
    end

    context 'when there is anonymous sub class' do
      it 'returns Wallaby::ModelDecorator' do
        decorator_class = Class.new(Wallaby::ResourceDecorator) do
          def self.model_class
            Category
          end
        end
        expect(Wallaby::ResourceDecorator.subclasses).to include decorator_class
        model_decorator = described_class.find_model model_class
        expect(model_decorator).to be_a Wallaby::ModelDecorator
        expect(model_decorator.model_class).to eq model_class
      end
    end

    context 'when there is a sub class' do
      let!(:decorator_class) do
        stub_const 'CategoryDecorator', Class.new(Wallaby::ResourceDecorator)
      end

      it 'returns sub classes' do
        expect(Wallaby::ResourceDecorator.subclasses).to include decorator_class
        model_decorator = described_class.find_model model_class
        expect(model_decorator).to eq decorator_class
        expect(model_decorator.model_class).to eq model_class
      end
    end
  end

  describe '.find_resource' do
    let(:model_class) { Order }

    it 'returns Wallaby::ResourceDecorator by default' do
      model_decorator = described_class.find_resource model_class
      expect(model_decorator).to eq Wallaby::ResourceDecorator
    end

    context 'when there is anonymous sub class' do
      it 'returns Wallaby::ResourceDecorator' do
        decorator_class = Class.new(Wallaby::ResourceDecorator) do
          def self.model_class
            Order
          end
        end
        expect(Wallaby::ResourceDecorator.subclasses).to include decorator_class
        model_decorator = described_class.find_resource model_class
        expect(model_decorator).to eq Wallaby::ResourceDecorator
      end
    end

    context 'when there is a sub class' do
      let!(:decorator_class) do
        stub_const 'OrderDecorator', Class.new(Wallaby::ResourceDecorator)
      end

      it 'returns sub classes' do
        expect(Wallaby::ResourceDecorator.subclasses).to include decorator_class
        model_decorator = described_class.find_resource model_class
        expect(model_decorator).to eq decorator_class
        expect(model_decorator.model_class).to eq model_class
      end
    end
  end
end
