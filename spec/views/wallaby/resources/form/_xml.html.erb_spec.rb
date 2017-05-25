require 'rails_helper'

partial_name = 'form/xml'
describe partial_name do
  let(:partial)     { "wallaby/resources/#{partial_name}.html.erb" }
  let(:form)        { Wallaby::FormBuilder.new object.model_name.param_key, object, view, {} }
  let(:object)      { AllPostgresType.new field_name => value }
  let(:field_name)  { :xml }
  let(:metadata)    { {} }
  let(:value) do
    <<-XML
    <?xml version="1.0" encoding="UTF-8"?>
    <note>
    <to>Tove</to>
    <from>Jani</from>
    <heading>Reminder</heading>
    <body>Don't forget me this weekend!</body>
    </note>
    XML
  end

  before do
    expect(view).to receive :content_for
    render partial, form: form, object: object, field_name: field_name, value: value, metadata: metadata
  end

  it 'renders the xml form' do
    expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"all_postgres_type_xml\">Xml</label>\n  <textarea class=\"form-control\" data-init=\"codemirror\" data-mode=\"xml\" name=\"all_postgres_type[xml]\" id=\"all_postgres_type_xml\">\n    &lt;?xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot;?&gt;\n    &lt;note&gt;\n    &lt;to&gt;Tove&lt;/to&gt;\n    &lt;from&gt;Jani&lt;/from&gt;\n    &lt;heading&gt;Reminder&lt;/heading&gt;\n    &lt;body&gt;Don&#39;t forget me this weekend!&lt;/body&gt;\n    &lt;/note&gt;\n</textarea>\n  \n</div>\n\n"
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders empty input' do
      expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"all_postgres_type_xml\">Xml</label>\n  <textarea class=\"form-control\" data-init=\"codemirror\" data-mode=\"xml\" name=\"all_postgres_type[xml]\" id=\"all_postgres_type_xml\">\n</textarea>\n  \n</div>\n\n"
    end
  end
end
