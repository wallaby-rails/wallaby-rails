require 'rails_helper'

describe Wallaby::ModelDecorator do
  it 'responds to following methods' do
    instance_methods = described_class.instance_methods.map &:to_s
    [ '', 'index_', 'show_', 'form_' ].each do |prefix|
      expect(instance_methods).to include "#{ prefix }fields"
      expect(instance_methods).to include "#{ prefix }field_names"
      expect(instance_methods).to include "#{ prefix }metadata_of"
      expect(instance_methods).to include "#{ prefix }label_of"
      expect(instance_methods).to include "#{ prefix }type_of"
    end
  end

  describe 'subclasses' do
    it 'implements the following methods' do
      described_class.subclasses.each do |klass|
        instance = klass.new nil
        [ '', 'index_', 'show_', 'form_' ].each do |prefix|
          expect{ instance.send "#{ prefix }fields" }.not_to raise_error Wallaby::NotImplemented
        end
        expect{ instance.primary_key }.not_to raise_error Wallaby::NotImplemented
        expect{ instance.collection }.not_to raise_error Wallaby::NotImplemented
        expect{ instance.find_or_initialize nil }.not_to raise_error Wallaby::NotImplemented
        expect{ instance.guess_title nil }.not_to raise_error Wallaby::NotImplemented
      end
    end
  end
end