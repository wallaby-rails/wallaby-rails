# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::ModelDecorator do
  subject { described_class.new model_class }

  let(:model_class) { nil }

  describe '#resources_name' do
    let(:model_class) { instance_double 'model', to_s: 'Core::Post' }

    it 'returns resources name for model class' do
      expect(subject.resources_name).to eq 'core::posts'
    end
  end

  describe '#index/show/form_fields=' do
    %w[index_ show_ form_].each do |prefix|
      it 'ensures assigned hash becomes ::ActiveSupport::HashWithIndifferentAccess' do
        subject.send :"#{prefix}fields=", name: { type: 'string' }
        expect(subject.instance_variable_get(:"@#{prefix}fields")).to be_a ::ActiveSupport::HashWithIndifferentAccess
        expect(subject.instance_variable_get(:"@#{prefix}fields")).to eq 'name' => { 'type' => 'string' }
      end
    end
  end

  describe '#all_fields' do
    it { expect(subject.all_fields).to be_a Wallaby::AllFields }
  end

  describe 'other fields' do
    it 'generates the methods' do
      subject.some_fields = { name: { type: 'string' } }
      expect(subject).to respond_to :some_fields
      expect(subject).to respond_to :some_field_names
      expect(subject).to respond_to :some_field_names=
      expect(subject.some_fields).to eq({ 'name' => { 'type' => 'string' } })

      subject.other_field_names = ['name']
      expect(subject).to respond_to :other_fields
      expect(subject).to respond_to :other_field_names
      expect(subject).to respond_to :other_field_names=
      expect(subject.other_field_names).to eq(['name'])
    end
  end
end
