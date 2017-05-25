require 'rails_helper'

describe 'Authorization' do
  it 'aliases the read to index/show' do
    ability = Ability.new nil
    ability.cannot :read, AllPostgresType
    expect(ability.can?(:index, AllPostgresType)).to be_falsy
    expect(ability.can?(:show, AllPostgresType)).to be_falsy
    expect(ability.can?(:read, AllPostgresType)).to be_falsy

    ability = Ability.new nil
    ability.cannot :index, AllPostgresType
    expect(ability.can?(:index, AllPostgresType)).to be_falsy
    expect(ability.can?(:show, AllPostgresType)).to be_truthy
    expect(ability.can?(:read, AllPostgresType)).to be_truthy

    ability = Ability.new nil
    ability.cannot :show, AllPostgresType
    expect(ability.can?(:index, AllPostgresType)).to be_truthy
    expect(ability.can?(:show, AllPostgresType)).to be_falsy
    expect(ability.can?(:read, AllPostgresType)).to be_truthy
  end

  it 'aliases the create to new' do
    ability = Ability.new nil
    ability.cannot :create, AllPostgresType
    expect(ability.can?(:create, AllPostgresType)).to be_falsy
    expect(ability.can?(:new, AllPostgresType)).to be_falsy

    ability = Ability.new nil
    ability.cannot :new, AllPostgresType
    expect(ability.can?(:create, AllPostgresType)).to be_truthy
    expect(ability.can?(:new, AllPostgresType)).to be_falsy
  end

  it 'aliases the update to edit' do
    ability = Ability.new nil
    ability.cannot :update, AllPostgresType
    expect(ability.can?(:update, AllPostgresType)).to be_falsy
    expect(ability.can?(:edit, AllPostgresType)).to be_falsy

    ability = Ability.new nil
    ability.cannot :edit, AllPostgresType
    expect(ability.can?(:update, AllPostgresType)).to be_truthy
    expect(ability.can?(:edit, AllPostgresType)).to be_falsy
  end
end
