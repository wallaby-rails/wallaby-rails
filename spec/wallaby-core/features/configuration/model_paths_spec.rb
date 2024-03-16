# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::Configuration do
  it 'has default value' do
    expect(subject.model_paths).to eq ['app/models']
  end

  it 'sets the model_paths' do
    subject.model_paths = 'app/core'
    expect(subject.model_paths).to eq ['app/core']

    subject.model_paths = 'app/core', 'app/others'
    expect(subject.model_paths).to eq ['app/core', 'app/others']

    subject.model_paths = ['app/core', 'app/models']
    expect(subject.model_paths).to eq ['app/core', 'app/models']

    # reset
    subject.model_paths = nil
    expect(subject.model_paths).to eq ['app/models']
  end

  context 'when non-String list is provided' do
    it 'raises ArgumentError' do
      expect { subject.model_paths = %r{app/(core|models)} }.to raise_error ArgumentError
      expect { subject.model_paths = %i[app/core app/models] }.to raise_error ArgumentError
    end
  end
end
