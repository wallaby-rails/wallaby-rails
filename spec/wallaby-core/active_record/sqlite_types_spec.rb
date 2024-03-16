# frozen_string_literal: true

require 'rails_helper'
require 'active_record/connection_adapters/sqlite3_adapter'

describe 'Sqlite Types' do
  let(:version_expected) do
    {
      '>= 5.2' => {
        size_of_native_types: 12,
        native_types: %w[binary boolean date datetime decimal float integer json primary_key string text time],
        size_of_supporting_types: 17,
        supporting_types: %w[binary blob boolean char clob date datetime decimal double float int json number numeric text time timestamp]
      }
    }
  end

  let(:general) do
    {
      size_of_native_types: 11,
      native_types: %w[binary boolean date datetime decimal float integer primary_key string text time],
      size_of_supporting_types: 16,
      supporting_types: %w[binary blob boolean char clob date datetime decimal double float int number numeric text time timestamp]
    }
  end

  let(:expected) { minor version_expected, general }

  it 'returns the expected native types' do
    native_types = ActiveRecord::ConnectionAdapters::SQLite3Adapter::NATIVE_DATABASE_TYPES.keys.map(&:to_s)

    expect(native_types.length).to eq expected[:size_of_native_types]
    expect(native_types.sort).to eq expected[:native_types]
  end

  it 'supports the following types' do
    supporting_types = AllSqliteType.connection.send(:type_map).try do |type_map|
      type_map.instance_variable_get(:@mapping).keys.map do |key|
        key.source.gsub(/\^|(\\.*\Z)/, '')
      end.compact.uniq
    end

    expect(supporting_types.length).to eq expected[:size_of_supporting_types]
    expect(supporting_types.sort).to eq expected[:supporting_types]
  end
end
