require 'rails_helper'

describe Wallaby::ModelDecorator do
  describe '#resources_name' do
    it 'returns resources name for model class' do
      mocked_class = double to_s: 'Core::Post'
      decorator = described_class.new mocked_class
      expect(decorator.resources_name).to eq 'core::posts'
    end
  end

  describe 'subclasses' do
    it 'implements the following methods' do
      described_class.subclasses.each do |klass|
        instance = klass.new nil
        expect{ instance.collection }.not_to raise_error Wallaby::NotImplemented
        expect{ instance.find_or_initialize nil }.not_to raise_error Wallaby::NotImplemented
        [ '', 'index_', 'show_', 'form_' ].each do |prefix|
          expect{ instance.send "#{ prefix }fields" }.not_to raise_error Wallaby::NotImplemented
        end
        expect{ instance.param_key }.not_to raise_error Wallaby::NotImplemented
        expect{ instance.form_strong_param_names }.not_to raise_error Wallaby::NotImplemented
        expect{ instance.form_active_errors nil }.not_to raise_error Wallaby::NotImplemented
        expect{ instance.primary_key }.not_to raise_error Wallaby::NotImplemented
        expect{ instance.guess_title nil }.not_to raise_error Wallaby::NotImplemented
      end
    end
  end
end
