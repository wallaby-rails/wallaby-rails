# frozen_string_literal: true

require 'rails_helper'

describe Wallaby::ActiveRecord::ModelServiceProvider::Validator do
  subject { described_class.new model_decorator }

  let(:model_decorator) { Wallaby::ActiveRecord::ModelDecorator.new AllPostgresType }
  let(:resource) { AllPostgresType.new }

  describe '#valid?' do
    describe 'range types' do
      describe 'daterange' do
        it 'turns array into range' do
          resource.daterange = ''...'2016-04-30'
          expect(subject).not_to be_valid(resource)
          expect(resource.errors[:daterange]).to eq ['required for range data']
        end
      end

      describe 'tsrange' do
        it 'turns array into range' do
          resource.tsrange = ''...'2016-04-30 10:23'
          expect(subject).not_to be_valid(resource)
          expect(resource.errors[:tsrange]).to eq ['required for range data']
        end
      end

      describe 'tstzrange' do
        it 'turns array into range' do
          resource.tstzrange = ''...'2016-04-30 10:23 +00:00'
          expect(subject).not_to be_valid(resource)
          expect(resource.errors[:tstzrange]).to eq ['required for range data']
        end
      end
    end
  end
end
