require 'rails_helper'

describe Wallaby::Her::PunditProvider do
  let(:context) { OpenStruct.new pundit_user: current_user }
  let(:current_user) { Staff.new }
  before { context.extend Pundit }

  describe '.available?' do
    it 'returns true' do
      expect(described_class.available?(nil)).to be_falsy
      expect(described_class.available?(OpenStruct.new)).to be_falsy
      expect(described_class.available?(context)).to be_truthy
    end
  end

  describe '.provider_name' do
    it 'returns a string' do
      expect(described_class.provider_name).to eq 'pundit'
    end
  end

  describe 'instance methods' do
    subject { described_class.new user: current_user }
    let(:target) { Her::Product.new }
    let(:target_class) { Her::Product }
    let(:scope) { Her::Product.all }
    let(:other_class) { Her::Order }

    before do
      stub_const 'Her::ProductPolicy', (Class.new(Struct.new(:user, :product)) do
        def index?; false; end

        def destroy?; false; end

        def show?; true; end

        def new?; true; end

        def create?; true; end

        def edit?; true; end

        def update?; true; end

        def attributes_for
          { featured: false }
        end

        def attributes_for_index
          { featured: true }
        end

        def permitted_attributes_for_edit
          ['name']
        end

        def permitted_attributes
          ['sku']
        end
      end)

      stub_const 'Her::ProductPolicy::Scope', (Class.new(Struct.new(:user, :scope)) do
        def resolve; scope.where(filtered: true); end
      end)
    end

    describe '#authorize' do
      it 'returns target' do
        expect { subject.authorize(:index, target_class) }.to raise_error Wallaby::Forbidden
        expect { subject.authorize(:index, target) }.to raise_error Wallaby::Forbidden
        expect(subject.authorize(:show, target)).to eq target
        expect(subject.authorize(:new, target)).to eq target
        expect(subject.authorize(:create, target)).to eq target
        expect(subject.authorize(:edit, target)).to eq target
        expect(subject.authorize(:update, target)).to eq target
        expect { subject.authorize(:destroy, target) }.to raise_error Wallaby::Forbidden
      end
    end

    describe '#authorized?' do
      it 'returns a boolean' do
        expect(subject.authorized?(:index, target_class)).to be_falsy
        expect(subject.authorized?(:index, target)).to be_falsy
        expect(subject.authorized?(:show, target)).to be_truthy
        expect(subject.authorized?(:new, target)).to be_truthy
        expect(subject.authorized?(:create, target)).to be_truthy
        expect(subject.authorized?(:edit, target)).to be_truthy
        expect(subject.authorized?(:update, target)).to be_truthy
        expect(subject.authorized?(:destroy, target)).to be_falsy
      end
    end

    describe '#unauthorized?' do
      it 'returns a boolean' do
        expect(subject.unauthorized?(:index, target_class)).to be_truthy
        expect(subject.unauthorized?(:index, target)).to be_truthy
        expect(subject.unauthorized?(:show, target)).to be_falsy
        expect(subject.unauthorized?(:new, target)).to be_falsy
        expect(subject.unauthorized?(:create, target)).to be_falsy
        expect(subject.unauthorized?(:edit, target)).to be_falsy
        expect(subject.unauthorized?(:update, target)).to be_falsy
        expect(subject.unauthorized?(:destroy, target)).to be_truthy
      end
    end

    describe '#accessible_for' do
      it 'returns scope' do
        product = Her::Product.new id: 111, name: 'Thursday'
        stub_request(:get, %r{/admin/products}).to_return do |request|
          params = parse_params_for request
          expect(params).to eq 'filtered' => 'true'
          { body: [product.attributes].to_json }
        end
        expect(subject.accessible_for(:index, scope)).to include product
        expect(subject.accessible_for(:show, scope)).to include product
        expect(subject.accessible_for(:new, scope)).to include product
        expect(subject.accessible_for(:create, scope)).to include product
        expect(subject.accessible_for(:edit, scope)).to include product
        expect(subject.accessible_for(:update, scope)).to include product
        expect(subject.accessible_for(:destroy, scope)).to include product

        expect(subject.accessible_for(:index, target_class)).to include product
        expect(subject.accessible_for(:show, target_class)).to include product
        expect(subject.accessible_for(:new, target_class)).to include product
        expect(subject.accessible_for(:create, target_class)).to include product
        expect(subject.accessible_for(:edit, target_class)).to include product
        expect(subject.accessible_for(:update, target_class)).to include product
        expect(subject.accessible_for(:destroy, target_class)).to include product

        expect(subject.accessible_for(:index, other_class)).to eq other_class
      end
    end

    describe '#attributes_for' do
      it 'returns target' do
        expect(subject.attributes_for(:index, target_class)).to eq featured: true
        expect(subject.attributes_for(:index, target)).to eq featured: true
        expect(subject.attributes_for(:show, target)).to eq featured: false
        expect(subject.attributes_for(:new, target)).to eq featured: false
        expect(subject.attributes_for(:create, target)).to eq featured: false
        expect(subject.attributes_for(:edit, target)).to eq featured: false
        expect(subject.attributes_for(:update, target)).to eq featured: false
        expect(subject.attributes_for(:destroy, target)).to eq featured: false
      end
    end

    describe '#permit_params' do
      it 'returns nil' do
        expect(subject.permit_params(:index, target_class)).to eq ['sku']
        expect(subject.permit_params(:index, target)).to eq ['sku']
        expect(subject.permit_params(:show, target)).to eq ['sku']
        expect(subject.permit_params(:new, target)).to eq ['sku']
        expect(subject.permit_params(:create, target)).to eq ['sku']
        expect(subject.permit_params(:edit, target)).to eq ['name']
        expect(subject.permit_params(:update, target)).to eq ['sku']
        expect(subject.permit_params(:destroy, target)).to eq ['sku']
      end
    end
  end
end
