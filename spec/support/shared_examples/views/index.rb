# frozen_string_literal: true
RSpec.shared_examples 'index partial' do |field_name, options = {}|
  let(:partial) { "wallaby/resources/#{action}#{partial_name}.html.erb" }
  let(:page) { Nokogiri::HTML rendered }
  let(:object) { model_class.new field_name => value }
  let(:value) { options[:value] }

  let(:action) { options[:action] || 'index/' }
  let(:partial_name) { options[:partial_name] || field_name }
  let(:content_for) { options[:content_for] }
  let(:metadata) { options[:metadata].to_h }
  let(:model_class) { options[:model_class] || AllPostgresType }
  let(:expected_value) { (options[:expected_value] || value).to_s }

  before do
    render partial, object: view.decorate(object), value: value, metadata: metadata
  end

  unless options[:skip_general] || options[:skip_all]
    it 'renders the index partial' do
      expect(rendered).to include(options[:skip_escaping] ? expected_value.to_s : h(expected_value.to_s))
    end
  end

  if options[:code_value]
    it 'renders the index partial wrapped in code' do
      expect(rendered).to include "<code>#{h value}</code>"
    end
  end

  if options[:max_length]
    context "when value has more than #{options[:max_length]} characters" do
      let(:value) { options[:max_value] }

      it 'renders the index partial' do
        if options[:modal_value]
          expect(page.at_css('code, span:first').inner_html).to eq escape(value.to_s.truncate(options[:max_length]))
          expect(page.at_css('.modaler__title').inner_html).to eq escape(metadata[:label])
          expect(page.at_css('.modaler__body').inner_html).to include escape(value)
        else
          expect(rendered).to include h(value.to_s.truncate(options[:max_length]))
        end

        expect(rendered).to include "title=\"#{h value}\"" if options[:max_title]
      end
    end
  end

  unless options[:skip_nil] || options[:skip_all]
    context 'when value is nil' do
      let(:value) { nil }

      it 'renders the index partial' do
        expect(rendered).to include view.null
      end
    end
  end
end

RSpec.shared_examples 'index csv partial' do |field_name, options = {}|
  let(:partial) { "wallaby/resources/index/#{partial_name}.csv.erb" }
  let(:page) { Nokogiri::HTML rendered }
  let(:object) { model_class.new field_name => value }
  let(:value) { options[:value] }

  let(:partial_name) { options[:partial_name] || field_name }
  let(:content_for) { options[:content_for] }
  let(:metadata) { options[:metadata].to_h }
  let(:model_class) { options[:model_class] || AllPostgresType }
  let(:expected_value) { (options[:expected_value] || value).to_s }

  before do
    render partial, object: view.decorate(object), value: value, metadata: metadata
  end

  unless options[:skip_general] || options[:skip_all]
    it 'renders the index csv partial' do
      expect(rendered).to eq expected_value.to_s
    end
  end

  unless options[:skip_nil] || options[:skip_all]
    context 'when value is nil' do
      let(:value) { nil }

      it 'renders the index csv partial' do
        expect(rendered).to eq options[:expected_nil_value].to_s
      end
    end
  end
end
