require 'rails_helper'

partial_name = 'form/has_and_belongs_to_many'
describe partial_name, :current_user do
  let(:partial) { "wallaby/resources/#{partial_name}.html.erb" }
  let(:page) { Nokogiri::HTML rendered }
  let(:form) { Wallaby::FormBuilder.new object.model_name.param_key, object, view, {} }
  let!(:object) { Product.create! field_name => value }
  let(:field_name) { metadata[:name] }
  let!(:value) { targets }
  let!(:targets) { [Tag.create!(id: 1, name: 'Toy')] }
  let(:metadata)    do
    {
      name: 'tags', type: 'has_and_belongs_to_many', label: 'Tags',
      is_association: true, is_polymorphic: false, is_through: false, has_scope: false, foreign_key: 'tag_ids', polymorphic_type: nil, polymorphic_list: [], class: Tag
    }
  end

  before { render partial, form: form, object: object, field_name: field_name, value: value, metadata: metadata }

  it 'renders the has_many form' do
    init = page.at_css('[data-init]')
    expect(init['data-wildcard']).to eq 'QUERY'
    expect(init['data-url']).to eq '/admin/tags?per=20&q=QUERY'

    selected = page.at_css('[data-init] ul li input')
    expect(selected['id']).to be_blank
    expect(selected['name']).to eq 'product[tag_ids][]'
    expect(selected['multiple']).to eq 'multiple'
    expect(selected['value']).to eq targets.first.id.to_s
  end

  context 'when value is empty array' do
    let(:object) { Product.new }
    let(:value) { [] }

    it 'renders the has_many form' do
      selected = page.at_css('[data-init] ul li input')
      expect(selected).to be_blank
    end
  end

  context 'when value is nil' do
    let(:object) { Product.new }
    let(:value) { nil }

    it 'renders the has_many form' do
      selected = page.at_css('[data-init] ul li input')
      expect(selected).to be_blank
    end
  end
end
