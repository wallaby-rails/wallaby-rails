require 'rails_helper'

describe 'partial' do
  let(:partial)   { 'wallaby/resources/show/macaddr.html.erb' }
  let(:value)     { '32:01:16:6d:05:ef' }
  let(:metadata)  { Hash.new }

  before { render partial, value: value, metadata: metadata }

  it 'renders the macaddr' do
    expect(rendered).to eq "  <code>32:01:16:6d:05:ef</code>\n"
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders null' do
      expect(rendered).to eq "  <i class=\"text-muted\">&lt;null&gt;</i>\n"
    end
  end
end
