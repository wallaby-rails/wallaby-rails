# frozen_string_literal: true

require 'rails_helper'

describe 'Validation module' do
  # rubocop:disable Rails/SkipsModelValidations, Rails/ActiveRecordAliases
  it 'clears exisiting validation errors when valid? is called' do
    resource = AllPostgresType.new
    resource.errors.add :base, 'errors'
    expect(resource.errors[:base]).to eq ['errors']
    resource.valid?
    expect(resource.errors[:base]).to be_blank

    resource.errors.add :base, 'errors'
    expect(resource.errors[:base]).to eq ['errors']
    expect(resource.save).to be_truthy
    expect(resource.errors[:base]).to be_blank

    resource.errors.add :base, 'errors'
    expect(resource.errors[:base]).to eq ['errors']
    expect(resource.update(string: '1')).to be_truthy
    expect(resource.errors[:base]).to be_blank
    expect(resource.string).to eq '1'

    # skip validation
    resource.errors.add :base, 'errors'
    expect(resource.errors[:base]).to eq ['errors']
    expect(resource.update_attribute(:string, '2')).to be_truthy
    expect(resource.errors[:base]).to eq ['errors']
    expect(resource.string).to eq '2'

    if resource.respond_to?(:update_attributes)
      expect(resource.update_attributes(string: '3')).to be_truthy
      expect(resource.errors[:base]).to be_blank
      expect(resource.string).to eq '3'
    end

    if resource.respond_to?(:update_attributes!)
      resource.errors.add :base, 'errors'
      expect(resource.errors[:base]).to eq ['errors']
      expect(resource.update_attributes!(string: '4')).to be_truthy
      expect(resource.errors[:base]).to be_blank
      expect(resource.string).to eq '4'
    end

    # skip validation
    resource.errors.clear
    resource.errors.add :base, 'errors'
    expect(resource.errors[:base]).to eq ['errors']
    expect(resource.update_column(:string, '5')).to be_truthy
    expect(resource.errors[:base]).to eq ['errors']
    expect(resource.string).to eq '5'

    # skip validation
    expect(resource.update_columns(string: '6')).to be_truthy
    expect(resource.errors[:base]).to eq ['errors']
    expect(resource.string).to eq '6'
  end
  # rubocop:enable Rails/SkipsModelValidations, Rails/ActiveRecordAliases
end
