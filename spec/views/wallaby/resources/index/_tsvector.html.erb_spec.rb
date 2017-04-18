require 'rails_helper'

partial_name = 'index/tsvector'
describe partial_name do
  let(:partial)   { "wallaby/resources/#{ partial_name }.html.erb" }
  let(:value)     { "'a' 'and' 'ate' 'cat' 'fat' 'mat' 'on' 'rat' 'sat'" }
  let(:metadata)  { {} }

  before do
    allow(view).to receive(:random_uuid) { '9877d72f-26fa-426b-8a1b-6ef012f9112b' }
    render partial, value: value, metadata: metadata
  end

  it 'renders the tsvector' do
    expect(rendered).to eq "    <span>&#39;a&#39; &#39;and&#39; &#39;ate&#39; &#39;...</span>\n    <a data-toggle=\"modal\" data-target=\"#9877d72f-26fa-426b-8a1b-6ef012f9112b\" href=\"javascript:;\"><i class=\"glyphicon glyphicon-circle-arrow-up\"></i></a><div id=\"9877d72f-26fa-426b-8a1b-6ef012f9112b\" class=\"modal fade\" tabindex=\"-1\" role=\"dialog\"><div class=\"modal-dialog modal-lg\"><div class=\"modal-content\"><div class=\"modal-header\"><button name=\"button\" type=\"button\" class=\"close\" data-dismiss=\"modal\" aria-label=\"Close\"><span aria-hidden=\"true\">&times;</span></button><h4 class=\"modal-title\"></h4></div><div class=\"modal-body\">&#39;a&#39; &#39;and&#39; &#39;ate&#39; &#39;cat&#39; &#39;fat&#39; &#39;mat&#39; &#39;on&#39; &#39;rat&#39; &#39;sat&#39;</div></div></div></div>\n"
  end

  context 'when max is set to 50' do
    let(:metadata)  { Hash max: 50 }
    it 'renders the tsvector' do
      expect(rendered).to eq "    &#39;a&#39; &#39;and&#39; &#39;ate&#39; &#39;cat&#39; &#39;fat&#39; &#39;mat&#39; &#39;on&#39; &#39;rat&#39; &#39;sat&#39;\n"
    end
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders null' do
      expect(rendered).to eq "  <i class=\"text-muted\">&lt;null&gt;</i>\n"
    end
  end
end
