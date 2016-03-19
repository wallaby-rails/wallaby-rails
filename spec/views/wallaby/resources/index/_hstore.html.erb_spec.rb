require 'rails_helper'

describe 'partial' do
  let(:partial)   { 'wallaby/resources/index/hstore.html.erb' }
  let(:value)     do
    {
      'key' => 'very long long text'
    }
  end
  let(:metadata)  { Hash.new }

  before do
    allow(view).to receive(:random_uuid) { '9877d72f-26fa-426b-8a1b-6ef012f9112b' }
    render partial, value: value, metadata: metadata
  end

  it 'renders the hstore' do
    expect(rendered).to eq "    <code>{&quot;key&quot;:&quot;very long...</code>\n    <a data-toggle=\"modal\" data-target=\"#9877d72f-26fa-426b-8a1b-6ef012f9112b\" href=\"javascript:;\"><i class=\"glyphicon glyphicon-circle-arrow-up\"></i></a><div id=\"9877d72f-26fa-426b-8a1b-6ef012f9112b\" class=\"modal fade\" tabindex=\"-1\" role=\"dialog\"><div class=\"modal-dialog modal-lg\"><div class=\"modal-content\"><div class=\"modal-header\"><button name=\"button\" type=\"button\" class=\"close\" data-dismiss=\"modal\" aria-label=\"Close\"><span aria-hidden=\"true\">&times;</span></button><h4 class=\"modal-title\"></h4></div><div class=\"modal-body\"><pre>{&quot;key&quot;:&quot;very long long text&quot;}</pre></div></div></div></div>\n"
  end

  context 'when value is less than 20 characters' do
    let(:value) { { 'a' => 1 } }
    it 'renders the hstore' do
      expect(rendered).to eq "    <code>{&quot;a&quot;:1}</code>\n"
    end
  end

  context 'when max is set to 30' do
    let(:metadata) { Hash max: 30 }
    it 'renders the hstore' do
      expect(rendered).to eq "    <code>{&quot;key&quot;:&quot;very long long text&quot;}</code>\n"
    end
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders null' do
      expect(rendered).to eq "  <i class=\"text-muted\">&lt;null&gt;</i>\n"
    end
  end
end
