require 'rails_helper'

describe Wallaby::FormHelper do
  describe '#form_type_partial_render' do
    let(:form) { Wallaby::FormBuilder.new object_name, object, helper, {} }
    let(:object_name) { object.model_name.param_key }
    let(:object) { Wallaby::ResourceDecorator.new Product.new(name: 'product_name') }

    it 'checks the arguments', prefixes: [ 'wallaby/resources/form' ] do
      expect{ helper.form_type_partial_render }.to raise_error ArgumentError
      expect{ helper.form_type_partial_render 'integer', field_name: 'name' }.to raise_error ArgumentError
      expect{ helper.form_type_partial_render 'integer', field_name: 'name', form: double(object: Product.new) }.to raise_error ArgumentError

      expect{ helper.form_type_partial_render 'integer', field_name: 'name', form: form }.not_to raise_error
    end

    describe 'partials', prefixes: [ 'wallaby/resources/form' ] do
      it 'renders a type partial' do
        expect(helper.form_type_partial_render 'integer', field_name: 'name', form: form).to match 'type="number"'
      end

      context 'when partial does not exists' do
        it 'renders string partial' do
          expect(helper.form_type_partial_render 'unknown', field_name: 'name', form: form).to eq "<div class=\"form-group \">\n  <label for=\"product_name\">Name</label>\n  <input class=\"form-control\" type=\"text\" value=\"product_name\" name=\"product[name]\" id=\"product_name\" />\n  \n</div>\n"
          expect(helper.form_type_partial_render 'unknown', field_name: 'name', form: form).to match 'type="text"'
        end
      end
    end
  end

  describe '#model_choices', :current_user do
    it 'returns a list of choise for select' do
      Product.create! name: 'Coconut'
      Product.create! name: 'Banana'
      model_decorator = Wallaby::ActiveRecord.model_decorator.new Product
      expect(helper.model_choices(model_decorator).map &:first).to eq [ "Coconut", "Banana"]
    end
  end
end
