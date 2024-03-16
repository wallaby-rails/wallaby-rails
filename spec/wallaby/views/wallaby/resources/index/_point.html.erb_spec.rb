# frozen_string_literal: true

require 'rails_helper'

class PointSpecific
  include ActiveModel::Model
  attr_accessor :point
end

field_name = field_name_from __FILE__
type = type_from __FILE__
describe field_name, type: :helper do
  it_behaves_like \
    "#{type} partial", field_name,
    value: [3, 4],
    model_class: PointSpecific,
    skip_general: true do
    it 'renders the point' do
      expect(rendered).to eq "(<span class=\"x\">3</span>, <span class=\"y\">4</span>)\n"
    end
  end
end
