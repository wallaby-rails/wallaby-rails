# frozen_string_literal: true

RSpec.shared_examples 'has attribute with default value' do |attr_name, default_value, valid_value = Class, &block|
  instance_exec(&block) if block

  it 'modifies the attribute' do
    subject.send :"#{attr_name}=", valid_value
    expect(subject.send(attr_name)).to eq valid_value
  end

  it 'returns default_value' do
    result = default_value.is_a?(Proc) ? default_value.call : default_value
    expect(subject.send(attr_name)).to eq result
  end
end
