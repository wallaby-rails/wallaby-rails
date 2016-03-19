require 'rails_helper'

describe 'partial' do
  let(:partial)   { 'wallaby/resources/show/hstore.html.erb' }
  let(:value)     do
    {
      'key' => 'very long long text'
    }
  end
  let(:metadata)  { Hash.new }

  before { render partial, value: value, metadata: metadata }

  it 'renders the hstore' do
    expect(rendered).to eq "  <pre>{&quot;key&quot;=&gt;&quot;very long long text&quot;}</pre>\n"
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders null' do
      expect(rendered).to eq "  <i class=\"text-muted\">&lt;null&gt;</i>\n"
    end
  end
end
