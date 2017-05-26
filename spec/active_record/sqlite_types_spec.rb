require 'rails_helper'

describe 'Sqlite Types' do
  it 'returns the expected native types' do
    native_types = ActiveRecord::ConnectionAdapters::SQLite3Adapter::NATIVE_DATABASE_TYPES.keys.map(&:to_s)

    expect(native_types.length).to eq 11
    expect(native_types.sort).to eq %w[binary boolean date datetime decimal float integer primary_key string text time]
  end

  it 'supports the following types' do
    supporting_types = AllSqliteType.connection.type_map.try do |type_map|
      type_map.instance_variable_get('@mapping').keys.map do |key|
        key.source.gsub(/\^|(\\.*\Z)/, '')
      end.compact.uniq
    end

    expect(supporting_types.length).to eq 16
    expect(supporting_types.sort).to eq %w[binary blob boolean char clob date datetime decimal double float int number numeric text time timestamp]
  end
end
