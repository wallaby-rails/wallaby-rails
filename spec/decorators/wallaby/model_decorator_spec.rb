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
    [ 'index_', 'show_', 'form_' ].each do |prefix|
      it 'ensures assigned hash becomes HashWithIndifferentAccess' do
        subject.send "#{ prefix }fields=", name: { type: 'string' }
        expect(subject.instance_variable_get "@#{ prefix }fields").to be_a HashWithIndifferentAccess
        expect(subject.instance_variable_get "@#{ prefix }fields").to eq 'name' => { 'type' => 'string' }
      end
    end
  end

  describe 'subclasses' do
    it 'implements the following methods' do
      described_class.subclasses.each do |klass|
        instance = klass.new nil
        [ '', 'index_', 'show_', 'form_' ].each do |prefix|
          expect{ instance.send "#{ prefix }fields" }.not_to raise_error Wallaby::NotImplemented
        end
        expect{ instance.form_active_errors nil }.not_to raise_error Wallaby::NotImplemented
        expect{ instance.primary_key }.not_to raise_error Wallaby::NotImplemented
        expect{ instance.guess_title nil }.not_to raise_error Wallaby::NotImplemented
      end
    end
  end
end
