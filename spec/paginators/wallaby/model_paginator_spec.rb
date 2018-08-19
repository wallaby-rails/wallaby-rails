require 'rails_helper'

describe Wallaby::ModelPaginator, clear: :object_space do
  describe 'class methods' do
    describe '.model_class' do
      it 'returns nil' do
        expect(described_class.model_class).to be_nil
      end
    end
  end

  context 'descendants' do
    let(:model_class) { Product }
    let(:klass) { stub_const 'ProductPaginator', Class.new(Wallaby::ModelPaginator) }

    describe 'class methods' do
      describe '.model_class' do
        it 'returns model class' do
          expect(klass.model_class).to eq model_class
        end
      end
    end
  end
end
