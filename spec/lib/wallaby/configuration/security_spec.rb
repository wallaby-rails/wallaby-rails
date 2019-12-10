require 'rails_helper'

describe Wallaby::Configuration::Security do
  describe 'attributes' do
    it 'has the following attributes' do
      %i(logout_path logout_method email_method).each do |attr|
        expect(subject).to respond_to attr
        expect(subject).to respond_to "#{attr}="
      end
    end
  end

  describe '#current_user' do
    it 'assigns current_user if block is given' do
      block = -> { 'doing nothing' }
      subject.current_user(&block)
      expect(subject.current_user).to eq block
    end

    it 'returns default block if no block is given' do
      expect(subject.current_user).to eq described_class::DEFAULT_CURRENT_USER
    end
  end

  describe '#current_user?' do
    it 'returns false' do
      expect(subject).not_to be_current_user
    end

    context 'when current_user is changed' do
      it 'returns true' do
        subject.current_user { 'custom user' }
        expect(subject).to be_current_user
      end
    end
  end

  describe '#authenticate' do
    it 'assigns authenticate if block is given' do
      block = -> { 'doing nothing' }
      subject.authenticate(&block)
      expect(subject.authenticate).to eq block
    end

    it 'returns default block if no block is given' do
      expect(subject.authenticate).to eq described_class::DEFAULT_AUTHENTICATE
    end
  end

  describe '#authenticate?' do
    it 'returns false' do
      expect(subject).not_to be_authenticate
    end

    context 'when authenticate is changed' do
      it 'returns true' do
        subject.authenticate { false }
        expect(subject).to be_authenticate
      end
    end
  end
end
