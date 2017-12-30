require 'rails_helper'

describe 'Mysql Types' do
  let(:version_expected) do
    {
      5 => {
        0 => {
          size_of_column_methods: 13,
          column_methods: %w(blob json longblob longtext mediumblob mediumtext primary_key tinyblob tinytext unsigned_bigint unsigned_decimal unsigned_float unsigned_integer),
          size_of_native_types: 12,
          native_types: %w(binary boolean date datetime decimal float integer json primary_key string text time),
          size_of_all_types: 23,
          all_types: %w(binary blob boolean date datetime decimal float integer json longblob longtext mediumblob mediumtext primary_key string text time tinyblob tinytext unsigned_bigint unsigned_decimal unsigned_float unsigned_integer),
          size_of_supporting_types: 31,
          supporting_types: %w(bigint binary bit blob boolean char clob date datetime decimal double enum float int json longblob longtext mediumblob mediumint mediumtext number numeric set smallint text time timestamp tinyblob tinyint tinytext year)
        },
        1 => {
          size_of_column_methods: 13,
          column_methods: %w(blob json longblob longtext mediumblob mediumtext primary_key tinyblob tinytext unsigned_bigint unsigned_decimal unsigned_float unsigned_integer),
          size_of_native_types: 13,
          native_types: %w(binary boolean date datetime decimal float integer json primary_key string text time timestamp),
          size_of_all_types: 24,
          all_types: %w(binary blob boolean date datetime decimal float integer json longblob longtext mediumblob mediumtext primary_key string text time timestamp tinyblob tinytext unsigned_bigint unsigned_decimal unsigned_float unsigned_integer),
          size_of_supporting_types: 31,
          supporting_types: %w(bigint binary bit blob boolean char clob date datetime decimal double enum float int json longblob longtext mediumblob mediumint mediumtext number numeric set smallint text time timestamp tinyblob tinyint tinytext year)
        },
        2 => {
          size_of_column_methods: 11,
          column_methods: %w(blob longblob longtext mediumblob mediumtext tinyblob tinytext unsigned_bigint unsigned_decimal unsigned_float unsigned_integer),
          size_of_native_types: 13,
          native_types: %w(binary boolean date datetime decimal float integer json primary_key string text time timestamp),
          size_of_all_types: 24,
          all_types: %w(binary blob boolean date datetime decimal float integer json longblob longtext mediumblob mediumtext primary_key string text time timestamp tinyblob tinytext unsigned_bigint unsigned_decimal unsigned_float unsigned_integer),
          size_of_supporting_types: 31,
          supporting_types: %w(bigint binary bit blob boolean char clob date datetime decimal double enum float int json longblob longtext mediumblob mediumint mediumtext number numeric set smallint text time timestamp tinyblob tinyint tinytext year)
        }
      }
    }
  end

  let(:expected) { minor version_expected }

  it 'returns the expected native types' do
    column_methods = ActiveRecord::ConnectionAdapters::MySQL::ColumnMethods.instance_methods.map(&:to_s)
    expect(column_methods.length).to eq expected[:size_of_column_methods]
    expect(column_methods.sort).to eq expected[:column_methods]

    native_types = ActiveRecord::ConnectionAdapters::AbstractMysqlAdapter::NATIVE_DATABASE_TYPES.keys.map(&:to_s)

    expect(native_types.length).to eq expected[:size_of_native_types]
    expect(native_types.sort).to eq expected[:native_types]

    all_types = column_methods | native_types
    expect(all_types.length).to eq expected[:size_of_all_types]
    expect(all_types.sort).to eq expected[:all_types]
  end

  it 'supports the following types' do
    supporting_types = AllMysqlType.connection.send(:type_map).try do |type_map|
      type_map.instance_variable_get('@mapping').keys.map do |key|
        key.source.gsub(/\^|(\\.*\Z)/, '')
      end.compact.uniq
    end

    expect(supporting_types.length).to eq expected[:size_of_supporting_types]
    expect(supporting_types.sort).to eq expected[:supporting_types]
  end
end
