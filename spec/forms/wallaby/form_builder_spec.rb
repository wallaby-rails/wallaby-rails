require 'rails_helper'

describe 'Wallaby::FormBuilder', type: :helper do
  subject { Wallaby::FormBuilder.new object_name, object, helper, {} }
  let(:object_name) { object.model_name.param_key }
  let(:object) { Product.new }

  describe '#error_class' do
    it 'returns error class if error' do
      expect(subject.error_class :name).to be_nil
      object.errors.add :name, 'not valid'
      expect(subject.error_class :name).to eq 'has-error'
    end
  end

  describe '#error_messages' do
    it 'returns error messages if any' do
      expect(subject.error_messages :name).to be_nil
      object.errors.add :name, 'not valid'
      object.errors.add :name, 'not unique'
      expect(subject.error_messages :name).to eq "<ul class=\"text-danger\"><li><small>not valid</small></li><li><small>not unique</small></li></ul>"
    end
  end

  describe '#has_error?' do
    it 'returns true if error' do
      expect(subject.send :has_error?, :name).to be_falsy
      object.errors.add :name, 'not valid'
      expect(subject.send :has_error?, :name).to be_truthy
    end
  end
end
