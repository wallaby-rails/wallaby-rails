# frozen_string_literal: true

require 'rails_helper'

# Security regression specs for unbounded pagination.
#
# Covers OWASP A04/A01: `?per=` and `?page=` come straight from the request and
# used to reach the query untouched, so a single request could materialise a whole
# table in memory (denial of service) and, on adapters where a negative limit
# means "unlimited", export it in bulk. See the security audit finding M-1.
describe Wallaby::ActiveRecord::ModelServiceProvider do
  subject { described_class.new model_class, model_decorator }

  let(:model_class) { AllPostgresType }
  let(:model_decorator) { Wallaby::ActiveRecord::ModelDecorator.new(model_class) }
  let(:query) { model_class.where(nil) }

  describe '#paginate' do
    it 'caps an oversized per at MAX_PER' do
      paginated = subject.paginate(query, parameters(per: 999_999_999, page: 1))
      expect(paginated.limit_value).to eq described_class::MAX_PER
    end

    it 'falls back to the default page size for a non-positive or non-numeric per' do
      [-1, 0, 'abc'].each do |per|
        paginated = subject.paginate(query, parameters(per: per, page: 1))
        expect(paginated.limit_value).to eq Wallaby::DEFAULT_PAGE_SIZE
      end
    end

    it 'never produces a negative offset' do
      paginated = subject.paginate(query, parameters(per: 10, page: -5))
      expect(paginated.offset_value).to eq 0
    end

    it 'tolerates non-scalar params' do
      paginated = subject.paginate(
        query, parameters(per: { 'x' => 'y' }, page: { 'x' => 'y' })
      )
      expect(paginated.limit_value).to eq Wallaby::DEFAULT_PAGE_SIZE
      expect(paginated.offset_value).to eq 0
    end

    it 'still paginates normally for in-range values' do
      paginated = subject.paginate(query, parameters(per: 8, page: 10))
      expect(paginated.limit_value).to eq 8
      expect(paginated.offset_value).to eq 72
    end
  end
end

# The paginator must display the same (clamped) page size that the query used.
describe Wallaby::ActiveRecord::ModelPaginationProvider do
  subject { described_class.new Product.where(nil), parameters(per: per) }

  context 'with an oversized per' do
    let(:per) { 999_999_999 }

    it 'reports the clamped page size' do
      expect(subject.page_size).to eq Wallaby::ActiveRecord::ModelServiceProvider::MAX_PER
    end
  end

  context 'with a negative per' do
    let(:per) { -1 }

    it 'reports the default page size' do
      expect(subject.page_size).to eq Wallaby::DEFAULT_PAGE_SIZE
    end
  end
end
