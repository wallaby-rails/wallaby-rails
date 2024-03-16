# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::ClassArray do
  it 'stores Class key/value as String' do
    subject = described_class.new [Class, Module]
    expect(subject.internal).to eq %w[Class Module]
    expect(subject).to eq [Class, Module]
  end

  describe '#[]= & #[]' do
    it 'assigns and return' do
      subject[0] = Module
      expect(subject[0]).to eq Module
      expect(subject.internal).to eq ['Module']
      expect(subject).to eq [Module]
    end
  end

  describe '#concat' do
    it 'concat and returns new ClassArray' do
      new_array = subject.concat([Class])
      expect(new_array).to be_kind_of described_class
      expect(new_array.internal).to eq ['Class']
      expect(new_array).to eq [Class]
    end
  end

  describe '#<<' do
    it 'appends the item' do
      subject << Module
      expect(subject[0]).to eq Module
      expect(subject.internal).to eq ['Module']
      expect(subject).to eq [Module]

      subject << Class
      expect(subject[1]).to eq Class
      expect(subject.internal).to eq %w[Module Class]
      expect(subject).to eq [Module, Class]
    end
  end

  describe '#freeze' do
    it 'is frozen' do
      subject.freeze
      expect { subject[Array] = Wallaby::Custom }.to raise_error(/can't modify frozen Array/)
    end
  end
end
