# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::ModelPaginator do
  describe 'class methods' do
    describe '.model_class' do
      it 'returns nil' do
        expect(described_class.model_class).to be_nil
      end
    end
  end

  context 'with descendants' do
    let(:model_class) { Product }
    let(:klass) { stub_const 'ProductPaginator', Class.new(described_class) }

    describe 'class methods' do
      describe '.model_class' do
        it 'returns model class' do
          expect(klass.model_class).to eq model_class
        end
      end
    end
  end
end
