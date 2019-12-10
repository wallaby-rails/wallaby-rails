RSpec.shared_examples 'form partial' do |field_name, options = {}|
  let(:partial) { "wallaby/resources/form/#{partial_name}.html.erb" }
  let(:page) { Nokogiri::HTML rendered }
  let(:form) { Wallaby::FormBuilder.new object.model_name.param_key, object, view, {} }
  let(:object) { model_class.new field_name => value }
  let(:value) { options[:value] }

  let(:partial_name) { options[:partial_name] || field_name }
  let(:content_for) { options[:content_for] }
  let(:type) { options[:type] || 'text' }
  let(:metadata) { options[:metadata].to_h }
  let(:model_class) { options[:model_class] || AllPostgresType }
  let(:resources_name) { Wallaby::ModelUtils.to_resources_name(model_class).singularize }
  let(:input_selector) { options[:input_selector] || '.form-group .row div input' }
  let(:expected_value) { (options[:expected_value] || value).to_s }

  before do
    expect(view).to receive :content_for if content_for # rubocop:disable RSpec/ExpectInHook
    render partial, form: form, object: object, field_name: field_name, value: value, metadata: metadata
  end

  unless options[:skip_general] || options[:skip_all]
    it 'renders the form' do
      input = page.at_css(input_selector)
      expect(input['name']).to eq "#{resources_name}[#{field_name}]"
      expect(input['type']).to eq type
      expect(input['value']).to eq expected_value unless options[:skip_value_check]
    end
  end

  unless options[:skip_nil] || options[:skip_all]
    context 'when value is nil' do
      let(:value) { nil }

      it 'renders the belongs_to form' do
        input = page.at_css(input_selector)
        expect(input['value']).to be_blank
      end
    end
  end

  unless options[:skip_errors] || options[:skip_all]
    context 'when has errors' do
      let(:error_message) { 'something wrong' }
      let(:object) do
        model_class.new(field_name => value).tap do |instance|
          instance.errors.add field_name, error_message
        end
      end

      it 'renders the errors' do
        form_group = page.at_css('.form-group')
        expect(form_group['class']).to include 'error'
        error = page.at_css('ul.errors li')
        expect(error.content).to eq error_message
      end
    end
  end
end
