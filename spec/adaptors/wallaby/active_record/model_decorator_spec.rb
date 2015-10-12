require 'rails_helper'

describe Wallaby::ActiveRecord::ModelDecorator do
  subject { described_class.new post_model }
  let(:post_model) { double 'Post', primary_key: 'id' }

  describe '#primary_key' do
    it 'returns model primary_key' do
      expect(subject.primary_key).to eq 'id'
    end
  end

  describe '#collection' do
    xit 'returns a collection'
  end

  describe '#find_or_initialize' do
    xit 'finds the record by id'
    xit 'builds a new record'
  end

  describe '#guess_title' do
    it 'returns a label for the model' do
      resource = double 'resource', title: 'guessing'
      allow(subject).to receive(:possible_title_column).and_return(double 'column', name: 'title')
      expect(resource).to receive(:title)
      expect(subject.guess_title resource).to eq 'guessing'
    end

    it 'returns nil if no possible column found' do
      resource = double 'resource', title: 'guessing'
      allow(subject).to receive(:possible_title_column).and_return(nil)
      expect(resource).not_to receive(:title)
      expect(subject.guess_title resource).to be_nil
    end
  end

  describe '#possible_title_columns' do
    it 'returns only string columns' do
      id    = double 'id', type: :integer
      title = double 'title', type: :string
      allow(post_model).to receive(:columns).and_return([ id, title ])
      expect(subject.send :possible_title_columns).to eq [ title ]
    end
  end

  describe '#possible_title_column' do
    it 'returns only string columns' do
      id    = double 'id',    name: 'id',     type: :integer
      uuid  = double 'uuid',  name: 'uuid',   type: :string
      title = double 'title', name: 'title',  type: :string
      allow(post_model).to receive(:columns).and_return([ id, uuid, title ])
      expect(subject.send :possible_title_column).to eq title
    end
  end
end