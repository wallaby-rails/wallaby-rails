require 'rails_helper'

describe 'partial' do
  let(:partial)   { 'wallaby/resources/index/text.html.erb' }
  let(:value)     { '<b>this is a text for more than 20 characters</b>' }
  let(:metadata)  { Hash.new }

  before do
    allow(view).to receive(:random_uuid) { '9877d72f-26fa-426b-8a1b-6ef012f9112b' }
    render partial, value: value, metadata: metadata
  end

  it 'renders the text' do
    expect(rendered).to eq "    <span>&lt;b&gt;this is a text...</span>\n    <a data-toggle=\"modal\" data-target=\"#9877d72f-26fa-426b-8a1b-6ef012f9112b\" href=\"javascript:;\"><i class=\"glyphicon glyphicon-circle-arrow-up\"></i></a><div id=\"9877d72f-26fa-426b-8a1b-6ef012f9112b\" class=\"modal fade\" tabindex=\"-1\" role=\"dialog\"><div class=\"modal-dialog modal-lg\"><div class=\"modal-content\"><div class=\"modal-header\"><button name=\"button\" type=\"button\" class=\"close\" data-dismiss=\"modal\" aria-label=\"Close\"><span aria-hidden=\"true\">&times;</span></button><h4 class=\"modal-title\"></h4></div><div class=\"modal-body\">&lt;b&gt;this is a text for more than 20 characters&lt;/b&gt;</div></div></div></div>\n"
  end

  context 'when value is less than 20 characters' do
    let(:value) { '<b>1234567890123</b>' }
    it 'renders the text' do
      expect(rendered).to eq "    &lt;b&gt;1234567890123&lt;/b&gt;\n"
    end
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders null' do
      expect(rendered).to eq "  <i class=\"text-muted\">&lt;null&gt;</i>\n"
    end
  end
end
