require 'rails_helper'

describe Wallaby::Her::ModelServiceProvider do
  describe 'actions' do
    subject { described_class.new model_class, model_decorator }
    let(:model_class) { Her::Product }
    let(:model_decorator) { Wallaby::Her::ModelDecorator.new model_class }
    let(:ability) { Ability.new nil }
    let(:authorizer) { Wallaby::ModelAuthorizer.new model_class, :cancancan, ability: ability }

    describe '#permit' do
      it 'returns the permitted params' do
        expect { subject.permit(parameters, :index, authorizer) }.to raise_error ActionController::ParameterMissing
        expect { subject.permit(parameters(her_product: {}), :index, authorizer) }.to raise_error ActionController::ParameterMissing
        expect(subject.permit(parameters(her_product: { name: 'some string' }), :index, authorizer)).to eq parameters!(name: 'some string')
      end
    end

    describe '#collection' do
      it 'returns the collection' do
        stub_request(:get, /products/).to_return(body: file_fixture('her/products.json'))
        expect(subject.collection(parameters, authorizer).length).to eq 100
      end
    end

    describe '#paginate' do
      it 'paginates the query' do
        stub_request(:get, /products/).to_return(body: file_fixture('her/products.json'))
        expect(subject.paginate(model_class.all, parameters(page: 10, per: 8)).length).to eq 100
      end
    end

    describe '#new' do
      it 'returns a resource' do
        resource = subject.new parameters!, authorizer
        expect(resource).to be_a model_class
        expect(resource).to be_new
        expect(resource.attributes.values.compact).to be_blank

        resource = subject.new parameters!(name: 'some string'), authorizer
        expect(resource).to be_a model_class
        expect(resource).to be_new
        expect(resource.attributes.values.compact).to be_blank
      end
    end

    describe '#find' do
      it 'returns a resource' do
        stub_request(:get, /products/).to_return(body: file_fixture('her/product.json'))
        resource = subject.find 'id', parameters!(name: 'some string'), authorizer
        expect(resource).to be_a model_class
        expect(resource.name).not_to eq 'some string'
      end

      context 'when it is not found' do
        it 'raises error' do
          stub_request(:get, /products/).to_return(status: 404)
          expect { subject.find 'id', parameters!, authorizer }.to raise_error Wallaby::ResourceNotFound
        end
      end
    end

    describe '#create' do
      it 'returns the resource' do
        stub_request(:post, /products/).with(body: { 'name' => 'string1' }).to_return(status: 200, body: { id: 'id1' }.to_json)
        resource = model_class.new
        resource = subject.create resource, parameters!(name: 'string1'), authorizer
        expect(resource).to be_a model_class
        expect(resource.id).to eq 'id1'
        expect(resource.errors).to be_blank
      end

      context 'when params are not filtered' do
        it 'returns the resource and its errors' do
          unfiltered = parameters(sku: 'string1')
          if version? '< 5.0'
            module ActionController
              class UnfilteredParameters < StandardError
                def message
                  'unable to convert unpermitted parameters to hash'
                end
              end
            end
          end
          expect(unfiltered).to receive(:to_h).and_raise(ActionController::UnfilteredParameters) if version? '< 5.1'
          resource = model_class.new
          resource = subject.create resource, unfiltered, authorizer
          expect(resource).to be_a model_class
          expect(resource.id).to be_blank
          expect(resource.errors[:base]).to include 'unable to convert unpermitted parameters to hash'
        end
      end

      context 'when server returns error' do
        it 'returns the resource and its errors' do
          stub_request(:post, /products/).with(body: { 'name' => 'string2' }).to_return(status: 400, body: { errors: { name: 'invalid name' } }.to_json)
          resource = model_class.new name: 'string1'
          resource = subject.create resource, parameters!(name: 'string2'), authorizer
          expect(resource).to be_a model_class
          expect(resource.id).to be_blank
          expect(resource.errors).to be_blank
          expect(resource.response_errors).to eq(name: 'invalid name')
        end
      end
    end

    describe '#update' do
      it 'returns the resource' do
        stub_request(:put, /products/).with(body: { 'id' => 'id1', 'name' => 'string2' }).to_return(status: 200, body: { id: 'id1' }.to_json)
        resource = model_class.new id: 'id1', name: 'string1'
        resource = subject.update resource, parameters!(name: 'string2'), authorizer
        expect(resource).to be_a model_class
        expect(resource.name).to eq 'string2'
        expect(resource.errors).to be_blank
      end

      context 'when server returns error' do
        it 'returns the resource and its errors' do
          stub_request(:put, /products/).with(body: { 'id' => 'id1', 'name' => 'string2' }).to_return(status: 400, body: { errors: { name: 'invalid name' } }.to_json)
          resource = model_class.new id: 'id1', name: 'string1'
          resource = subject.update resource, parameters!(name: 'string2'), authorizer
          expect(resource).to be_a model_class
          expect(resource.errors).to be_blank
          expect(resource.response_errors).to eq(name: 'invalid name')
        end
      end
    end

    describe '#destroy' do
      it 'returns is_success regardless whether the record exists' do
        stub_request(:delete, /products/).to_return(status: 200)
        resource = model_class.new id: 'id1'
        expect(subject.destroy(resource, {}, authorizer)).to be_truthy
      end
    end
  end
end
