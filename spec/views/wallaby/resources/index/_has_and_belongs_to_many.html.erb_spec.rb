require 'rails_helper'

field_name = 'products'
type = type_from __FILE__
describe field_name, current_user: true do
  it_behaves_like \
    "#{type} partial", field_name,
    value: [
      Product.new(id: 1, name: 'Hiking shoes'),
      Product.new(id: 2, name: 'Hiking pole'),
      Product.new(id: 3, name: 'Hiking jacket')
    ],
    model_class: Tag,
    partial_name: 'has_and_belongs_to_many',
    skip_general: true,
    skip_nil: true do
    it 'renders the has_and_belongs_to' do
      expect(page.at_css('.modaler > a').content).to eq '1 more'
      expect(page.at_css('.modaler__title').inner_html).to eq escape(metadata[:label])
      expect(page.css('.modaler__body a').length).to eq 3

      expect(page.at_css('.modaler__body').inner_html).to match view.show_link(value[0])
      expect(page.at_css('.modaler__body').inner_html).to match view.show_link(value[1])
      expect(page.at_css('.modaler__body').inner_html).to match view.show_link(value[2])

      expect(page.css('.modaler__body a')[0].content).to eq value[0].name
      expect(page.css('.modaler__body a')[1].content).to eq value[1].name
      expect(page.css('.modaler__body a')[2].content).to eq value[2].name
    end

    context 'when value size is no more than 2' do
      let(:value) do
        [
          Product.new(id: 1, name: 'Hiking shoes'),
          Product.new(id: 2, name: 'Hiking pole')
        ]
      end

      it 'renders the has_and_belongs_to' do
        expect(rendered).to include view.show_link(value.first)
        expect(rendered).to include view.show_link(value.second)
      end
    end

    context 'when value is []' do
      let(:value) { [] }

      it 'renders null' do
        expect(rendered).to include view.null
      end
    end
  end
end
