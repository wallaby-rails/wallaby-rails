require 'rails_helper'

partial_name = 'index/json'
describe partial_name do
  let(:partial)   { "wallaby/resources/#{partial_name}.html.erb" }
  let(:metadata)  { {} }
  let(:value)     do
    {
      'kind' => 'user_renamed',
      'change' => %w[jack john]
    }
  end

  before do
    allow(view).to receive(:random_uuid) { '9877d72f-26fa-426b-8a1b-6ef012f9112b' }
    render partial, value: value, metadata: metadata
  end

  it 'renders the json' do
    expect(rendered).to eq "    <code>{&quot;kind&quot;:&quot;user_ren...</code>\n    <a data-toggle=\"modal\" data-target=\"#9877d72f-26fa-426b-8a1b-6ef012f9112b\" href=\"javascript:;\"><i class=\"fa fa-clone\"></i></a><div id=\"9877d72f-26fa-426b-8a1b-6ef012f9112b\" class=\"modal fade\" tabindex=\"-1\" role=\"dialog\"><div class=\"modal-dialog modal-lg\"><div class=\"modal-content\"><div class=\"modal-header\"><button name=\"button\" type=\"button\" class=\"close\" data-dismiss=\"modal\" aria-label=\"Close\"><span aria-hidden=\"true\">&times;</span></button><h4 class=\"modal-title\"></h4></div><div class=\"modal-body\"><pre>{&quot;kind&quot;:&quot;user_renamed&quot;,&quot;change&quot;:[&quot;jack&quot;,&quot;john&quot;]}</pre></div></div></div></div>\n"
  end

  context 'when value is less than 20 characters' do
    let(:value) { { 'a' => 1 } }
    it 'renders the json' do
      expect(rendered).to eq "    <code>{&quot;a&quot;:1}</code>\n"
    end
  end

  context 'when max is set to 50' do
    let(:metadata) { Hash max: 50 }
    it 'renders the json' do
      expect(rendered).to eq "    <code>{&quot;kind&quot;:&quot;user_renamed&quot;,&quot;change&quot;:[&quot;jack&quot;,&quot;john&quot;]}</code>\n"
    end
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders null' do
      expect(rendered).to eq "  <i class=\"text-muted\">&lt;null&gt;</i>\n"
    end
  end
end
