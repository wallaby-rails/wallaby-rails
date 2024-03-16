# frozen_string_literal: true

require 'rails_helper'

describe 'Authorization' do
  it 'aliases the read to index/show' do
    ability = Ability.new nil
    ability.cannot :read, AllPostgresType
    expect(ability).not_to be_can(:index, AllPostgresType)
    expect(ability).not_to be_can(:show, AllPostgresType)
    expect(ability).not_to be_can(:read, AllPostgresType)

    ability = Ability.new nil
    ability.cannot :index, AllPostgresType
    expect(ability).not_to be_can(:index, AllPostgresType)
    expect(ability).to be_can(:show, AllPostgresType)
    expect(ability).to be_can(:read, AllPostgresType)

    ability = Ability.new nil
    ability.cannot :show, AllPostgresType
    expect(ability).to be_can(:index, AllPostgresType)
    expect(ability).not_to be_can(:show, AllPostgresType)
    expect(ability).to be_can(:read, AllPostgresType)
  end

  it 'aliases the create to new' do
    ability = Ability.new nil
    ability.cannot :create, AllPostgresType
    expect(ability).not_to be_can(:create, AllPostgresType)
    expect(ability).not_to be_can(:new, AllPostgresType)

    ability = Ability.new nil
    ability.cannot :new, AllPostgresType
    expect(ability).to be_can(:create, AllPostgresType)
    expect(ability).not_to be_can(:new, AllPostgresType)
  end

  it 'aliases the update to edit' do
    ability = Ability.new nil
    ability.cannot :update, AllPostgresType
    expect(ability).not_to be_can(:update, AllPostgresType)
    expect(ability).not_to be_can(:edit, AllPostgresType)

    ability = Ability.new nil
    ability.cannot :edit, AllPostgresType
    expect(ability).to be_can(:update, AllPostgresType)
    expect(ability).not_to be_can(:edit, AllPostgresType)
  end
end
