# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::ModelAuthorizationProvider do
  describe '.provider_name' do
    it 'returns symbole' do
      expect(described_class.provider_name).to eq 'model'
    end
  end

  describe '.available?' do
    it 'raises not implemented error' do
      expect { described_class.available?(nil) }.to raise_error Wallaby::NotImplemented
    end
  end

  describe '.options_from' do
    it 'raises not implemented error' do
      expect { described_class.options_from(nil) }.to raise_error Wallaby::NotImplemented
    end
  end

  describe '#user' do
    it 'raises not implemented error' do
      subject = described_class.new(user: 'string user')
      expect(subject.user).to eq 'string user'
    end
  end

  describe '#authorize' do
    it 'raises not implemented error' do
      subject = described_class.new
      expect { subject.authorize(nil, nil) }.to raise_error Wallaby::NotImplemented
    end
  end

  describe '#authorized?' do
    it 'raises not implemented error' do
      subject = described_class.new
      expect { subject.authorized?(nil, nil) }.to raise_error Wallaby::NotImplemented
    end
  end

  describe '#unauthorized?' do
    it 'raises not implemented error' do
      subject = described_class.new
      expect { subject.unauthorized?(nil, nil) }.to raise_error Wallaby::NotImplemented
    end
  end

  describe '#accessible_for' do
    it 'raises not implemented error' do
      subject = described_class.new
      expect { subject.accessible_for(nil, nil) }.to raise_error Wallaby::NotImplemented
    end
  end

  describe '#attributes_for' do
    it 'raises not implemented error' do
      subject = described_class.new
      expect { subject.attributes_for(nil, nil) }.to raise_error Wallaby::NotImplemented
    end
  end

  describe '#permit_params' do
    it 'raises not implemented error' do
      subject = described_class.new
      expect { subject.permit_params(nil, nil) }.to raise_error Wallaby::NotImplemented
    end
  end
end
