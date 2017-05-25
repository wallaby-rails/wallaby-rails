require 'rails_helper'

describe Wallaby::ModelDecorator do
  subject { described_class.new model_class }
  let(:model_class) { nil }

  describe '#resources_name' do
    let(:model_class) { double to_s: 'Core::Post' }

    it 'returns resources name for model class' do
      expect(subject.resources_name).to eq 'core::posts'
    end
  end

  describe '#index/show/form_fields=' do
    %w[index_ show_ form_].each do |prefix|
      it 'ensures assigned hash becomes HashWithIndifferentAccess' do
        subject.send "#{prefix}fields=", name: { type: 'string' }
        expect(subject.instance_variable_get("@#{prefix}fields")).to be_a HashWithIndifferentAccess
        expect(subject.instance_variable_get("@#{prefix}fields")).to eq 'name' => { 'type' => 'string' }
      end
    end
  end

  describe 'subclasses' do
    it 'implements the following methods' do
      described_class.subclasses.each do |klass|
        instance = klass.new Product
        ['', 'index_', 'show_', 'form_'].each do |prefix|
          expect { instance.send "#{prefix}fields" }.not_to raise_error
        end
        expect { instance.form_active_errors Product.new }.not_to raise_error
        expect { instance.primary_key }.not_to raise_error
        expect { instance.guess_title Product.new name: 'abc' }.not_to raise_error
      end
    end
  end
end
