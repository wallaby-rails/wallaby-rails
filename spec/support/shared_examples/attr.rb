RSpec.shared_examples 'has attribute with default value' do |attr_name, default_value, valid_value = 'default'|
  it 'modifies the attribute' do
    expect(subject.send("#{attr_name}=", valid_value)).to eq valid_value
    expect(subject.send(attr_name)).to eq valid_value
  end

  it 'returns default_value' do
    expect(subject.send(attr_name)).to eq default_value
  end
end

RSpec.shared_examples 'has accessible attribute' do |attr_name, valid_value = 'default_value'|
  it 'accesses the attribute' do
    expect(subject.send(attr_name)).to be_nil
    expect(subject.send("#{attr_name}=", valid_value)).to eq valid_value
    expect(subject.send(attr_name)).to eq valid_value
  end
end
