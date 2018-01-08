require 'rails_helper'

describe Wallaby::BaseHelper, :current_user, type: :helper do
  describe '#body_class' do
    before do
      # @see Wallaby::BaseController#current_resources_name
      def helper.current_resources_name
        params[:resources]
      end
    end

    it 'returns body class' do
      helper.params[:action] = 'index'
      expect(helper.body_class).to eq 'index'
    end

    context 'when resources name is blank' do
      it 'returns body class' do
        expect(helper.body_class).to eq ''
      end
    end

    context 'when resources name is present' do
      it 'returns body class' do
        helper.params[:resources] = 'wallaby::posts'
        expect(helper.body_class).to eq 'wallaby__posts'
      end
    end

    context 'when custom_body_class is present' do
      it 'returns body class' do
        helper.content_for :custom_body_class, 'body'
        expect(helper.body_class).to eq 'body'
      end
    end
  end

  describe '#model_classes' do
    context 'when root only' do
      it 'returns an array' do
        classes = [Product, Order]
        expect(helper.model_classes(classes).map(&:klass)).to eq [Product, Order]
        expect(helper.model_classes(classes).map(&:children).flatten).to be_blank
      end
    end

    context 'when tree structure' do
      it 'returns a tree' do
        classes = [Order, Category, Staff, Customer, Person]
        expect(helper.model_classes(classes).map(&:klass)).to eq [Order, Category, Person]
        expect(helper.model_classes(classes).last.children.map(&:klass)).to eq [Staff, Customer]
      end
    end
  end

  describe '#model_tree' do
    context 'when root only' do
      it 'returns html' do
        classes = [Product, Order]
        expect(helper.model_tree(model_classes(classes))).to eq '<ul class="dropdown-menu"><li><a title="Order" href="/admin/orders">Order</a></li><li><a title="Product" href="/admin/products">Product</a></li></ul>'
      end
    end

    context 'when tree structure' do
      it 'returns html' do
        classes = [Product, Order, Person, Staff, Customer]
        expect(helper.model_tree(model_classes(classes))).to eq '<ul class="dropdown-menu"><li><a title="Order" href="/admin/orders">Order</a></li><li><a title="Person" href="/admin/people">Person</a><ul class="dropdown-menu"><li><a title="Customer" href="/admin/customers">Customer</a></li><li><a title="Staff" href="/admin/staffs">Staff</a></li></ul></li><li><a title="Product" href="/admin/products">Product</a></li></ul>'
      end
    end
  end
end
