require 'rails_helper'

describe Wallaby::Custom::ModelServiceProvider do
  describe 'actions' do
    subject { described_class.new model_class, model_decorator }
    let(:model_class) { Zipcode }
    let(:model_decorator) { Wallaby::Custom::ModelDecorator.new model_class }
    let(:authorizer) { Wallaby::ModelAuthorizer.new model_class, :default, {} }
    let(:resource) { model_class.new }

    before do
      Wallaby.configuration.custom_models = ['Zipcode']
    end

    describe '#permit' do
      it 'raises not implemented' do
        expect { subject.permit(parameters, :index, authorizer) }.to raise_error Wallaby::NotImplemented
      end
    end

    describe '#collection' do
      it 'raises not implemented' do
        expect { subject.collection(parameters, authorizer) }.to raise_error Wallaby::NotImplemented
      end
    end

    describe '#paginate' do
      it 'raises not implemented' do
        expect { subject.paginate([], parameters(page: 10, per: 8)) }.to raise_error Wallaby::NotImplemented
      end
    end

    describe '#new' do
      it 'raises not implemented' do
        expect { subject.new parameters!, authorizer }.to raise_error Wallaby::NotImplemented
      end
    end

    describe '#find' do
      it 'raises not implemented' do
        expect { subject.find 'id', parameters!(name: 'some string'), authorizer }.to raise_error Wallaby::NotImplemented
      end
    end

    describe '#create' do
      it 'raises not implemented' do
        expect { subject.create resource, parameters!(name: 'string1'), authorizer }.to raise_error Wallaby::NotImplemented
      end
    end

    describe '#update' do
      it 'raises not implemented' do
        expect { subject.update resource, parameters!(name: 'string2'), authorizer }.to raise_error Wallaby::NotImplemented
      end
    end

    describe '#destroy' do
      it 'raises not implemented' do
        expect { subject.destroy(resource, {}, authorizer) }.to raise_error Wallaby::NotImplemented
      end
    end
  end
end
