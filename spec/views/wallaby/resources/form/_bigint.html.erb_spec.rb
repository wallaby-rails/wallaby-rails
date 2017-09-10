require 'rails_helper'

partial_name = 'form/bigint'
describe partial_name do
  let(:partial) { "wallaby/resources/#{partial_name}.html.erb" }
  let(:page) { Nokogiri::HTML rendered }
  let(:form) { Wallaby::FormBuilder.new object.model_name.param_key, object, view, {} }
  let(:object) { AllPostgresType.new field_name => value }
  let(:field_name) { :bigint }
  let(:value) { BigDecimal.new(42)**20 }
  let(:metadata) { {} }

  before { render partial, form: form, object: object, field_name: field_name, value: value, metadata: metadata }

  it 'renders the bigint form' do
    input = page.at_css('.form-control')
    expect(input['name']).to eq "all_postgres_type[#{field_name}]"
    expect(input['value']).to eq value.to_s
  end

  context 'when has errors' do
    let!(:object) do
      AllPostgresType.new(field_name => value).tap do |record|
        record.errors.add field_name, error_message
      end
    end
    let(:error_message) { 'something wrong' }

    it 'renders the errors' do
      input = page.at_css('.form-control')
      expect(input['name']).to eq "all_postgres_type[#{field_name}]"
      expect(input['value']).to eq value.to_s

      form_group = page.at_css('.form-group')
      expect(form_group['class']).to include 'error'
      error = page.at_css('ul.errors li')
      expect(error.content).to eq error_message
    end
  end

  context 'when value is nil' do
    let(:value) { nil }

    it 'renders empty input' do
      expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"all_postgres_type_bigint\">Bigint</label>\n  <div class=\"row\">\n    <div class=\"col-xs-6 col-sm-4\">\n      <input class=\"form-control\" type=\"number\" name=\"all_postgres_type[bigint]\" id=\"all_postgres_type_bigint\" />\n    </div>\n  </div>\n  \n</div>\n"
    end
  end
end
