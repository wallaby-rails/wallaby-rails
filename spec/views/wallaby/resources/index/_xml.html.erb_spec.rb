require 'rails_helper'

partial_name = 'index/xml'
describe partial_name do
  let(:partial)   { "wallaby/resources/#{partial_name}.html.erb" }
  let(:metadata)  { {} }
  let(:value)     do
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
    allow(view).to receive(:random_uuid) { '9877d72f-26fa-426b-8a1b-6ef012f9112b' }
    render partial, value: value, metadata: metadata
  end

  it 'renders the text' do
    expect(rendered).to eq "    <code>&lt;?xml version=&quot;1....</code>\n    <a data-toggle=\"modal\" data-target=\"#9877d72f-26fa-426b-8a1b-6ef012f9112b\" href=\"javascript:;\"><i class=\"glyphicon glyphicon-circle-arrow-up\"></i></a><div id=\"9877d72f-26fa-426b-8a1b-6ef012f9112b\" class=\"modal fade\" tabindex=\"-1\" role=\"dialog\"><div class=\"modal-dialog modal-lg\"><div class=\"modal-content\"><div class=\"modal-header\"><button name=\"button\" type=\"button\" class=\"close\" data-dismiss=\"modal\" aria-label=\"Close\"><span aria-hidden=\"true\">&times;</span></button><h4 class=\"modal-title\"></h4></div><div class=\"modal-body\"><pre>&lt;?xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot;?&gt;\n&lt;note&gt;\n  &lt;to&gt;Tove&lt;/to&gt;\n  &lt;from&gt;Jani&lt;/from&gt;\n  &lt;heading&gt;Reminder&lt;/heading&gt;\n  &lt;body&gt;Don&#39;t forget me this weekend!&lt;/body&gt;\n&lt;/note&gt;\n</pre></div></div></div></div>\n"
  end

  context 'when max is set to 200' do
    let(:metadata)  { Hash max: 200 }
    it 'renders the xml' do
      expect(rendered).to eq "    <code>&lt;?xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot;?&gt;\n&lt;note&gt;\n  &lt;to&gt;Tove&lt;/to&gt;\n  &lt;from&gt;Jani&lt;/from&gt;\n  &lt;heading&gt;Reminder&lt;/heading&gt;\n  &lt;body&gt;Don&#39;t forget me this weekend!&lt;/body&gt;\n&lt;/note&gt;\n</code>\n"
    end
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders null' do
      expect(rendered).to eq "  <i class=\"text-muted\">&lt;null&gt;</i>\n"
    end
  end
end
