require 'rails_helper'

describe 'partial' do
  let(:partial)   { 'wallaby/resources/show/uuid.html.erb' }
  let(:value)     { "814865cd-5a1d-4771-9306-4268f188fe9e" }
  let(:metadata)  { Hash.new }

  before { render partial, value: value, metadata: metadata }

  it 'renders the uuid' do
    expect(rendered).to eq "  <code>814865cd-5a1d-4771-9306-4268f188fe9e</code>\n"
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders null' do
      expect(rendered).to eq "  <i class=\"text-muted\">&lt;null&gt;</i>\n"
    end
  end
end
