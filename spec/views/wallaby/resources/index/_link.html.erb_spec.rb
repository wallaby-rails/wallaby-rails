# frozen_string_literal: true
require 'rails_helper'

field_name = 'string'
type = type_from __FILE__
describe field_name do
  it_behaves_like \
    "#{type} partial", field_name,
    partial_name: 'link',
    value: 'https://reinteractive.com/',
    metadata: { title: 'Rails Developers', html_options: { target: '_blank' } },
    skip_escaping: true,
    expected_value: '<a target="_blank" href="https://reinteractive.com/">Rails Developers</a>'
end
