# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::Sorting::NextBuilder do
  describe '#next_params' do
    it 'returns params with sort values' do
      params = parameters sort: 'name asc'
      subject = described_class.new(params, name: 'asc')
      expect { subject.next_params(:name) }.not_to(change { params })
      expect(subject.next_params(:name)).to eq parameters(sort: 'name desc')

      params = parameters sort: 'name asc'
      subject = described_class.new(params)
      expect { subject.next_params(:name) }.not_to(change { params })
      expect(subject.next_params(:name)).to eq parameters(sort: 'name desc')

      params = parameters sort: 'name desc'
      subject = described_class.new(params)
      expect { subject.next_params(:name) }.not_to(change { params })
      expect(subject.next_params(:name)).to eq parameters(sort: '')

      params = parameters
      subject = described_class.new(params)
      expect { subject.next_params(:name) }.not_to(change { params })
      expect(subject.next_params(:name)).to eq parameters(sort: 'name asc')

      params = parameters sort: 'name asc'
      subject = described_class.new(params)
      expect { subject.next_params(:email) }.not_to(change { params })
      expect(subject.next_params(:email)).to eq parameters(sort: 'name asc,email asc')

      params = parameters sort: 'name asc,email asc'
      subject = described_class.new(params)
      expect { subject.next_params(:email) }.not_to(change { params })
      expect(subject.next_params(:email)).to eq parameters(sort: 'name asc,email desc')

      params = parameters sort: 'name asc,email desc'
      subject = described_class.new(params)
      expect { subject.next_params(:email) }.not_to(change { params })
      expect(subject.next_params(:email)).to eq parameters(sort: 'name asc')

      params = parameters sort: 'name asc,email desc,invalid'
      subject = described_class.new(params)
      expect { subject.next_params(:email) }.not_to(change { params })
      expect(subject.next_params(:email)).to eq parameters(sort: 'name asc')
    end
  end
end
