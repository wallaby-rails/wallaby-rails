require 'rails_helper'

describe Wallaby::ActiveRecord::ModelDecorator::SearchQueryBuilder do
  subject { described_class.new model_class, fields }
  let(:model_class) do
    Class.new ActiveRecord::Base do
      def self.name
        'Product'
      end
    end
  end

  describe '#build' do
    let(:fields) do
      {
        'sku' => { name: 'sku', type: 'string' },
      }
    end
    let(:keyword) { '123' }
    it 'returns a query' do
      expect(subject.build keyword).to be_a ActiveRecord::Relation
      expect(subject.build(keyword).where_values).to eq ["UPPER(sku) LIKE '%123%'"]
    end
  end

  describe '#search_queries' do
    context 'when field is number' do
      let(:fields) do
        {
          'id' => { name: 'id', type: 'integer' },
          'price' => { name: 'price', type: 'float' },
        }
      end
      context 'and keyword is number' do
        let(:keyword) { '1.0' }
        it 'returns a query' do
          query = subject.send :search_queries, keyword
          expect(query['id = ?']).to eq keyword
          expect(query['price = ?']).to eq keyword
        end
      end

      context 'and keyword is not number' do
        let(:keyword) { 'not_a_number' }
        it 'returns empty query' do
          query = subject.send :search_queries, keyword
          expect(query).to be_blank
        end
      end
    end

    context 'when field is boolean' do
      let(:fields) { { 'featured' => { name: 'featured', type: 'boolean' } } }
      context 'and keyword is boolean' do
        let(:keyword) { 'true' }
        it 'returns a query' do
          query = subject.send :search_queries, keyword
          expect(query['featured = ?']).to eq keyword
        end
      end

      context 'and keyword is not boolean' do
        let(:keyword) { 'true_or_false' }
        it 'returns empty query' do
          query = subject.send :search_queries, keyword
          expect(query).to be_blank
        end
      end
    end

    context 'when field is dates' do
      let(:fields) do
        {
          'published_at' => { name: 'published_at', type: 'datetime' },
          'start_date' => { name: 'start_date', type: 'date' },
          'start_time' => { name: 'start_time', type: 'time' },
        }
      end
      context 'and keyword is date' do
        let(:keyword) { '2012-12-02T11:23:46Z' }
        it 'returns a query' do
          query = subject.send :search_queries, keyword
          expect(query['published_at = ?']).to eq keyword
          expect(query['start_date = ?']).to eq keyword
          expect(query['start_time = ?']).to eq keyword
        end
      end

      context 'and keyword is not date' do
        let(:keyword) { 'not_a_date' }
        it 'returns empty query' do
          query = subject.send :search_queries, keyword
          expect(query).to be_blank
        end
      end
    end

    context 'when field is string' do
      let(:fields) do
        {
          'first_name' => { name: 'first_name', type: 'string' },
          'description' => { name: 'description', type: 'text' },
        }
      end
      let(:keyword) { 'keyword' }
      it 'returns a query' do
        query = subject.send :search_queries, keyword
        expect(query['UPPER(first_name) LIKE ?']).to eq '%KEYWORD%'
        expect(query['UPPER(description) LIKE ?']).to eq '%KEYWORD%'
      end
    end

    context 'when field is something else' do
      let(:fields) do
        {
          'description' => { name: 'description', type: 'unknown' },
        }
      end
      let(:keyword) { 'keyword' }
      it 'returns blank query' do
        query = subject.send :search_queries, keyword
        expect(query).to be_blank
      end
    end
  end
end