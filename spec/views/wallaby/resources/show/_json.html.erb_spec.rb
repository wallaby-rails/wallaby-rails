require 'rails_helper'

partial_name = 'show/json'
describe partial_name do
  let(:partial)   { "wallaby/resources/#{partial_name}.html.erb" }
  let(:value)     do
    {
      "kind" => "user_renamed",
      "change" => ["jack", "john"]
    }
  end
  let(:metadata)  { {} }

  before do
    allow(view).to receive(:random_uuid) { '9877d72f-26fa-426b-8a1b-6ef012f9112b' }
    render partial, value: value, metadata: metadata
  end

  it 'renders the json' do
    expect(rendered).to eq "  <pre>{&quot;kind&quot;=&gt;&quot;user_renamed&quot;, &quot;change&quot;=&gt;[&quot;jack&quot;, &quot;john&quot;]}</pre>\n"
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders null' do
      expect(rendered).to eq "  <i class=\"text-muted\">&lt;null&gt;</i>\n"
    end
  end
end
