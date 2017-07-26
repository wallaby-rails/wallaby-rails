require 'rails_helper'

describe Wallaby::FormHelper do
  describe '#form_type_partial_render' do
    let(:form) { Wallaby::FormBuilder.new object_name, object, helper, {} }
    let(:object_name) { object.model_name.param_key }
    let(:object) { Wallaby::ResourceDecorator.new Product.new(name: 'product_name') }

    it 'checks the arguments', prefixes: ['wallaby/resources/form'] do
      expect { helper.form_type_partial_render }.to raise_error ArgumentError
      expect { helper.form_type_partial_render 'integer', field_name: 'name' }.to raise_error ArgumentError
      expect { helper.form_type_partial_render 'integer', field_name: 'name', form: double(object: Product.new) }.to raise_error ArgumentError

      expect { helper.form_type_partial_render 'integer', field_name: 'name', form: form }.not_to raise_error
    end

    describe 'partials', prefixes: ['wallaby/resources/form'] do
      it 'renders a type partial' do
        expect(helper.form_type_partial_render('integer', field_name: 'name', form: form)).to match 'type="number"'
      end

      context 'when partial does not exists' do
        it 'renders string partial' do
          expect(helper.form_type_partial_render('unknown', field_name: 'name', form: form)).to eq "<div class=\"form-group \">\n  <label for=\"product_name\">Name</label>\n  <input class=\"form-control\" type=\"text\" value=\"product_name\" name=\"product[name]\" id=\"product_name\" />\n  \n</div>\n"
          expect(helper.form_type_partial_render('unknown', field_name: 'name', form: form)).to match 'type="text"'
        end
      end

      context 'for custom fields' do
        let(:decorator_class) do
          class FormProductDecorator < Wallaby::ResourceDecorator
            def self.model_class; Product; end

            form_fields[:custom] = { type: 'string', name: 'Custom Field' }

            def custom
              name
            end
          end
          FormProductDecorator
        end

        let(:object) do
          decorator_class.new Product.new(name: 'custom_value')
        end

        it 'renders the custom field' do
          expect(helper.form_type_partial_render('string', field_name: 'custom', form: form)).to eq "<div class=\"form-group \">\n  <label for=\"product_custom\">Custom</label>\n  <input class=\"form-control\" type=\"text\" value=\"custom_value\" name=\"product[custom]\" id=\"product_custom\" />\n  \n</div>\n"
        end
      end
    end
  end

  describe '#model_choices', :current_user do
    it 'returns a list of choise for select' do
      Product.create! name: 'Coconut'
      Product.create! name: 'Banana'
      expect(helper.model_choices(Product).map(&:first)).to eq %w(Coconut Banana)
    end
  end
end
