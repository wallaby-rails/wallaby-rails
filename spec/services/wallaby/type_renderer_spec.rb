require 'rails_helper'

describe Wallaby::TypeRenderer, type: :helper do
  describe '.render' do
    let(:form) { Wallaby::FormBuilder.new object_name, object, helper, {} }
    let(:object_name) { object.model_name.param_key }
    let(:object) { Wallaby::ResourceDecorator.new Product.new(name: value) }
    let(:value) { 'product name' }

    before { helper.params[:action] = 'edit' }

    it 'checks the arguments', prefixes: ['wallaby/resources/form'] do
      expect { described_class.render helper }.to raise_error ArgumentError
      expect { described_class.render helper, 'integer', field_name: 'name' }.to raise_error ArgumentError
      expect { described_class.render helper, 'integer', field_name: 'name', form: instance_double('form', object: Product.new) }.to raise_error ArgumentError
      expect { described_class.render helper, 'integer', field_name: 'name', form: form }.not_to raise_error
    end

    describe 'partials', prefixes: ['wallaby/resources/form'] do
      it 'renders a type partial' do
        expect(described_class.render(helper, 'integer', field_name: 'name', form: form)).to match 'type="number"'
      end

      context 'when partial does not exists' do
        it 'raises missing template error' do
          expect { described_class.render(helper, 'unknown', field_name: 'name', form: form) }.to raise_error ActionView::MissingTemplate
        end
      end

      context 'with custom fields' do
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
          expect(described_class.render(helper, 'string', field_name: 'custom', form: form)).to eq "<div class=\"form-group \">\n  <label for=\"product_custom\">Custom</label>\n  <div class=\"row\">\n    <div class=\"col-12\">\n      <input class=\"form-control\" type=\"text\" value=\"custom_value\" name=\"product[custom]\" id=\"product_custom\" />\n    </div>\n  </div>\n  \n  \n</div>\n"
        end
      end
    end
  end
end
