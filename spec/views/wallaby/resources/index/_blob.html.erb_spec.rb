# frozen_string_literal: true

require 'rails_helper'

field_name = Rails::VERSION::MAJOR >= 5 ? field_name_from(__FILE__) : 'string'
type = type_from __FILE__
describe field_name do
  it_behaves_like \
    "#{type} partial", field_name,
    partial_name: 'blob',
    value: '010111',
    model_class: AllMysqlType,
    skip_general: true do
    it 'renders the blob' do
      expect(rendered).to include view.muted('blob')
    end
  end
end
