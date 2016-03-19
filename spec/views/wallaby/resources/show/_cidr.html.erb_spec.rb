require 'rails_helper'

describe 'partial' do
  let(:partial)   { 'wallaby/resources/show/cidr.html.erb' }
  let(:value)     { IPAddr.new '192.168.2.0/24' }
  let(:metadata)  { Hash.new }

  before { render partial, value: value, metadata: metadata }

  it 'renders the cidr' do
    expect(rendered).to eq "  <code>192.168.2.0</code>\n  <a target=\"_blank\" class=\"text-info\" href=\"http://ip-api.com/#192.168.2.0\"><i class=\"glyphicon glyphicon-new-window\"></i></a>\n"
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders null' do
      expect(rendered).to eq "  <i class=\"text-muted\">&lt;null&gt;</i>\n"
    end
  end
end
