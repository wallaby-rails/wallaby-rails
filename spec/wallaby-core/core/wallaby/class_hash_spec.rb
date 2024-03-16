# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::ClassHash do
  it 'stores Class key/value as String' do
    subject = described_class.new Class => Module
    expect(subject.internal).to eq ['Class', true] => ['Module', true]
    expect(subject).to eq Class => Module
  end

  describe '#[]= & #[]' do
    it 'assigns and return' do
      subject[Class] = Module
      expect(subject[Class]).to eq Module
      expect(subject['Class']).to be_nil
      expect(subject.internal).to eq ['Class', true] => ['Module', true]
      expect(subject).to eq Class => Module

      subject[Class] = 'Module'
      expect(subject[Class]).to eq 'Module'
      expect(subject['Class']).to be_nil
      expect(subject).to eq Class => 'Module'

      subject['Class'] = 'Module'
      expect(subject[Class]).to eq 'Module'
      expect(subject['Class']).to eq 'Module'
      expect(subject.internal).to eq ['Class', true] => ['Module', false], ['Class', false] => ['Module', false]
      expect(subject).to eq Class => 'Module', 'Class' => 'Module'
    end
  end

  describe '#merge' do
    it 'merges and returns new ClassHash' do
      new_hash = subject.merge(Class => Module)
      expect(new_hash).to be_kind_of described_class
      expect(new_hash.internal).to eq ['Class', true] => ['Module', true]
      expect(new_hash).to eq Class => Module
    end
  end

  describe '#freeze' do
    it 'is frozen' do
      subject.freeze
      expect { subject[Array] = Wallaby::Custom }.to raise_error(/can't modify frozen Hash/)
    end
  end
end
