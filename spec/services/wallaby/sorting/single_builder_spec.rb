require 'rails_helper'

describe Wallaby::Sorting::SingleBuilder do
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
      expect(subject.next_params(:email)).to eq parameters(sort: 'email asc')

      params = parameters sort: 'name desc'
      subject = described_class.new(params)
      expect { subject.next_params(:email) }.not_to(change { params })
      expect(subject.next_params(:email)).to eq parameters(sort: 'email asc')

      params = parameters sort: 'invalid'
      subject = described_class.new(params)
      expect { subject.next_params(:email) }.not_to(change { params })
      expect(subject.next_params(:email)).to eq parameters(sort: 'email asc')
    end
  end
end
