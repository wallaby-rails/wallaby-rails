require 'rails_helper'
require 'parslet/rig/rspec'

describe Wallaby::ActiveRecord::ModelServiceProvider::Querier::Transformer do
  describe 'simple keywords' do
    it 'transforms' do
      expect(subject.apply(keyword: 'something')).to eq('something')
      expect(subject.apply([{ keyword: 'something' }, { keyword: 'else' }])).to eq(%w(something else))
    end

    context 'when no rules found' do
      it 'returns nil' do
        expect(subject.apply(keyword: [])).to be_nil
        expect(subject.apply([{ keyword: [] }, { keyword: [] }])).to eq([nil, nil])
      end
    end
  end

  describe 'simple colon_queries' do
    it 'transforms' do
      expect(subject.apply(left: 'field', op: ':', right: { keyword: 'key' })).to eq(left: 'field', op: :eq, right: 'key')
      expect(subject.apply(left: 'field', op: ':', right: [{ keyword: 'key1' }, { keyword: 'key2' }])).to eq(left: 'field', op: :in, right: %w(key1 key2))
    end

    describe 'general colon_queries' do
      it 'transforms' do
        expect(subject.apply(left: 'field', op: ':', right: { keyword: 'key' })).to eq(left: 'field', op: :eq, right: 'key')
        expect(subject.apply(left: 'field', op: ':=', right: { keyword: 'key' })).to eq(left: 'field', op: :eq, right: 'key')
        expect(subject.apply(left: 'field', op: ':!', right: { keyword: 'key' })).to eq(left: 'field', op: :not_eq, right: 'key')
        expect(subject.apply(left: 'field', op: ':!=', right: { keyword: 'key' })).to eq(left: 'field', op: :not_eq, right: 'key')
        expect(subject.apply(left: 'field', op: ':~', right: { keyword: 'key' })).to eq(left: 'field', op: :matches, right: '%key%')
        expect(subject.apply(left: 'field', op: ':^', right: { keyword: 'key' })).to eq(left: 'field', op: :matches, right: 'key%')
        expect(subject.apply(left: 'field', op: ':$', right: { keyword: 'key' })).to eq(left: 'field', op: :matches, right: '%key')
        expect(subject.apply(left: 'field', op: ':!~', right: { keyword: 'key' })).to eq(left: 'field', op: :does_not_match, right: '%key%')
        expect(subject.apply(left: 'field', op: ':!^', right: { keyword: 'key' })).to eq(left: 'field', op: :does_not_match, right: 'key%')
        expect(subject.apply(left: 'field', op: ':!$', right: { keyword: 'key' })).to eq(left: 'field', op: :does_not_match, right: '%key')
        expect(subject.apply(left: 'field', op: ':>', right: { keyword: 'key' })).to eq(left: 'field', op: :gt, right: 'key')
        expect(subject.apply(left: 'field', op: ':>=', right: { keyword: 'key' })).to eq(left: 'field', op: :gteq, right: 'key')
        expect(subject.apply(left: 'field', op: ':<', right: { keyword: 'key' })).to eq(left: 'field', op: :lt, right: 'key')
        expect(subject.apply(left: 'field', op: ':<=', right: { keyword: 'key' })).to eq(left: 'field', op: :lteq, right: 'key')
        expect(subject.apply(left: 'field', op: ':', right: [{ keyword: 'key1' }, { keyword: 'key2' }])).to eq(left: 'field', op: :in, right: %w(key1 key2))
        expect(subject.apply(left: 'field', op: ':=', right: [{ keyword: 'key1' }, { keyword: 'key2' }])).to eq(left: 'field', op: :in, right: %w(key1 key2))
        expect(subject.apply(left: 'field', op: ':!', right: [{ keyword: 'key1' }, { keyword: 'key2' }])).to eq(left: 'field', op: :not_in, right: %w(key1 key2))
        expect(subject.apply(left: 'field', op: ':!=', right: [{ keyword: 'key1' }, { keyword: 'key2' }])).to eq(left: 'field', op: :not_in, right: %w(key1 key2))
        expect(subject.apply(left: 'field', op: ':<>', right: [{ keyword: 'key1' }, { keyword: 'key2' }])).to eq(left: 'field', op: :not_in, right: %w(key1 key2))
        expect(subject.apply(left: 'field', op: ':()', right: [{ keyword: 'key1' }, { keyword: 'key2' }])).to eq(left: 'field', op: :between, right: 'key1'..'key2')
        expect(subject.apply(left: 'field', op: ':!()', right: [{ keyword: 'key1' }, { keyword: 'key2' }])).to eq(left: 'field', op: :not_between, right: 'key1'..'key2')
      end
    end

    context 'when op is not found' do
      it 'transforms' do
        expect(subject.apply(left: 'field', op: ':::', right: { keyword: 'key' })).to be_nil
      end
    end
  end
end
