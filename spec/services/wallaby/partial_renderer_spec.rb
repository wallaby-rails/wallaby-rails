require 'rails_helper'

describe Wallaby::PartialRenderer, type: :helper do
  describe '.render_form' do
    let(:form) { Wallaby::FormBuilder.new object_name, object, helper, {} }
    let(:object_name) { object.model_name.param_key }
    let(:object) { Wallaby::ResourceDecorator.new Product.new(name: 'product_name') }

    it 'checks the arguments', prefixes: ['wallaby/resources/form'] do
      expect { described_class.render_form helper }.to raise_error ArgumentError
      expect { described_class.render_form helper, 'integer', field_name: 'name' }.to raise_error ArgumentError
      expect { described_class.render_form helper, 'integer', field_name: 'name', form: double(object: Product.new) }.to raise_error ArgumentError

      expect { described_class.render_form helper, 'integer', field_name: 'name', form: form }.not_to raise_error
    end

    describe 'partials', prefixes: ['wallaby/resources/form'] do
      it 'renders a type partial' do
        expect(described_class.render_form(helper, 'integer', field_name: 'name', form: form)).to match 'type="number"'
      end

      context 'when partial does not exists' do
        it 'renders string partial' do
          expect(described_class.render_form(helper, 'unknown', field_name: 'name', form: form)).to eq "<div class=\"form-group \">\n  <label for=\"product_name\">Name</label>\n  <div class=\"row\">\n    <div class=\"col-xs-12\">\n      <input class=\"form-control\" type=\"text\" value=\"product_name\" name=\"product[name]\" id=\"product_name\" />\n    </div>\n  </div>\n  \n  \n</div>\n"
          expect(described_class.render_form(helper, 'unknown', field_name: 'name', form: form)).to match 'type="text"'
        end
      end

      context 'for custom fields' do
        let(:decorator_class) do
          stub_const 'FormProductDecorator', (Class.new Wallaby::ResourceDecorator do
            def self.model_class; Product; end

            form_fields[:custom] = { type: 'string', name: 'Custom Field' }

            def custom
              name
            end
          end)
        end

        let(:object) do
          decorator_class.new Product.new(name: 'custom_value')
        end

        it 'renders the custom field' do
          expect(described_class.render_form(helper, 'string', field_name: 'custom', form: form)).to eq "<div class=\"form-group \">\n  <label for=\"product_custom\">Custom</label>\n  <div class=\"row\">\n    <div class=\"col-xs-12\">\n      <input class=\"form-control\" type=\"text\" value=\"custom_value\" name=\"product[custom]\" id=\"product_custom\" />\n    </div>\n  </div>\n  \n  \n</div>\n"
        end
      end
    end
  end
end
