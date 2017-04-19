require 'rails_helper'

describe Wallaby::ResourcesHelper do
  describe '#extract' do
    let(:resource) { Product.new }

    it 'returns origin resource' do
      new_resource = Wallaby::ResourceDecorator.new resource
      expect(helper.extract new_resource).to eq resource
      expect(helper.extract resource).to eq resource
    end
  end
  describe '#decorate' do
    it 'returns a decorator' do
      expect(decorate Product.new).to be_a Wallaby::ResourceDecorator
      decorated = Wallaby::ResourceDecorator.new Product.new
      expect(decorate decorated).to be_a Wallaby::ResourceDecorator
      expect(decorate decorated).to eq decorated
    end

    context 'when resources is enumerable' do
      it 'returns decorators' do
        expect(decorate [ Product.new ]).to all be_a Wallaby::ResourceDecorator
        decorated = Wallaby::ResourceDecorator.new Product.new
        expect(decorate [ decorated ]).to all be_a Wallaby::ResourceDecorator
        expect(decorate [ decorated ]).to eq [ decorated ]
      end
    end
  end

  describe '#type_partial_render', prefixes: [ 'wallaby/resources/index' ] do
    let(:object) { Wallaby::ResourceDecorator.new Product.new(name: 'product_name') }

    it 'checks the arguments' do
      expect { helper.type_partial_render }.to raise_error ArgumentError
      expect { helper.type_partial_render 'integer', field_name: 'name' }.to raise_error ArgumentError
      expect { helper.type_partial_render 'integer', field_name: 'name', object: Product.new }.to raise_error ArgumentError

      expect { helper.type_partial_render 'integer', field_name: 'name', object: object }.not_to raise_error
    end

    describe 'partials' do
      it 'renders a type partial' do
        expect(helper.type_partial_render 'integer', object: object, field_name: 'name').to eq "0\n"
      end

      context 'when partial does not exists' do
        it 'renders string partial' do
          expect(helper.type_partial_render 'unknown', object: object, field_name: 'name').to eq "    product_name\n"
        end
      end

      context 'for custom show fields' do
        let(:decorator_class) do
          class FormProductDecorator < Wallaby::ResourceDecorator
            def self.model_class; Product; end

            self.show_fields[:custom] = { type: 'string', name: 'Custom Field' }

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
          expect(helper.type_partial_render 'string', object: object, field_name: 'custom').to eq "    custom_value\n"
          expect(helper.type_partial_render 'string', { object: object, field_name: 'custom' }, :show_metadata_of).to eq "    custom_value\n"
        end
      end

      context 'for custom index fields' do
        let(:decorator_class) do
          class FormProductDecorator < Wallaby::ResourceDecorator
            def self.model_class; Product; end

            self.index_fields[:custom] = { type: 'string', name: 'Custom Field' }

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
          expect(helper.type_partial_render 'string', { object: object, field_name: 'custom' }, :index_metadata_of).to eq "    custom_value\n"
          expect(helper.index_type_partial_render 'string', object: object, field_name: 'custom').to eq "    custom_value\n"
        end
      end
    end
  end

  describe '#show_title' do
    it 'returns a title for decorated resources' do
      expect { helper.show_title }.to raise_error ArgumentError
    end
  end
end
