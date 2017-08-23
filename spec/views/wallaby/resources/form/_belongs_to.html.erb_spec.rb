require 'rails_helper'

partial_name = 'form/belongs_to'
describe partial_name, :current_user do
  let(:partial) { "wallaby/resources/#{partial_name}.html.erb" }
  let(:page) { Nokogiri::HTML rendered }
  let(:form) { Wallaby::FormBuilder.new object.model_name.param_key, object, view, {} }
  let!(:object) { Product.create! field_name => value }
  let(:field_name) { metadata[:name] }
  let!(:value) { target }
  let!(:target) { Category.create! id: 1, name: 'Mens' }
  let(:metadata) do
    {
      name: 'category', type: 'belongs_to', label: 'Category',
      is_association: true, is_polymorphic: false, is_through: false, has_scope: false, foreign_key: 'category_id', polymorphic_type: nil, polymorphic_list: [], class: Category
    }
  end

  before { render partial, form: form, object: object, field_name: field_name, value: value, metadata: metadata }

  it 'renders the belongs_to form' do
    init = page.at_css('[data-init]')
    expect(init['data-wildcard']).to eq 'QUERY'
    expect(init['data-url']).to eq '/admin/categories?per=20&q=QUERY'

    selected = page.css('[data-init] ul li input')
    expect(selected.length).to eq 1

    first = selected.first
    expect(first['id']).to be_blank
    expect(first['name']).to eq 'product[category_id]'
    expect(first['multiple']).to be_blank
    expect(first['value']).to eq target.id.to_s
  end

  context 'when value is nil' do
    let(:object) { Product.new }
    let(:value) { nil }

    it 'renders the belongs_to form' do
      selected = page.at_css('[data-init] ul li input')
      expect(selected).to be_blank
    end
  end

  context 'when it is polymorphic' do
    let(:object) { Picture.new imageable: value }
    let(:field_name) { :imageable_id }
    let(:target) { Product.new id: 1, name: 'Snowboard' }
    let(:metadata) do
      {
        name: 'imageable', type: 'belongs_to', label: 'Imageable', is_association: true,
        is_polymorphic: true, is_through: false, has_scope: false, foreign_key: 'imageable_id', polymorphic_type: 'imageable_type', polymorphic_list: [Product], class: nil
      }
    end

    it 'renders the polymorphic form' do
      selected_klass = page.at_css('[data-init] select option[selected]')
      expect(selected_klass['value']).to eq target.class.name
      selected = page.css('[data-init] ul li input')
      expect(selected.length).to eq 1
      expect(selected.first['value']).to eq target.id.to_s
    end

    context 'when value is nil' do
      let(:object) { Picture.new }
      let(:value) { nil }

      it 'renders the polymorphic form' do
        selected_klass = page.at_css('[data-init] select option[selected]')
        expect(selected_klass).to be_blank
        selected = page.at_css('[data-init] ul li input')
        expect(selected).to be_blank
      end
    end
  end
end
