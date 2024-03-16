# frozen_string_literal: true

require 'rails_helper'
require 'active_record/connection_adapters/mysql2_adapter'

describe 'Mysql Types' do
  it 'returns the expected native types' do
    if version?('~> 5.0.0') || version?('~> 5.1.0')
      column_methods = ActiveRecord::ConnectionAdapters::MySQL::ColumnMethods.instance_methods.map(&:to_s)
      expect(column_methods.length).to eq 13
      expect(column_methods.sort).to eq %w[blob json longblob longtext mediumblob mediumtext primary_key tinyblob tinytext unsigned_bigint unsigned_decimal unsigned_float unsigned_integer]
    elsif version? '~> 5.2.0'
      column_methods = ActiveRecord::ConnectionAdapters::MySQL::ColumnMethods.instance_methods.map(&:to_s)
      expect(column_methods.length).to eq 11
      expect(column_methods.sort).to eq %w[blob longblob longtext mediumblob mediumtext tinyblob tinytext unsigned_bigint unsigned_decimal unsigned_float unsigned_integer]
    end

    native_types = ActiveRecord::ConnectionAdapters::AbstractMysqlAdapter::NATIVE_DATABASE_TYPES.keys.map(&:to_s)
    all_types = column_methods | native_types

    if version? '~> 5.0.0'
      expect(native_types.length).to eq 12
      expect(native_types.sort).to eq %w[binary boolean date datetime decimal float integer json primary_key string text time]

      expect(all_types.length).to eq 23
      expect(all_types.sort).to eq %w[binary blob boolean date datetime decimal float integer json longblob longtext mediumblob mediumtext primary_key string text time tinyblob tinytext unsigned_bigint unsigned_decimal unsigned_float unsigned_integer]
    elsif version?('~> 5.1.0') || version?('~> 5.2.0')
      expect(native_types.length).to eq 13
      expect(native_types.sort).to eq %w[binary boolean date datetime decimal float integer json primary_key string text time timestamp]

      expect(all_types.length).to eq 24
      expect(all_types.sort).to eq %w[binary blob boolean date datetime decimal float integer json longblob longtext mediumblob mediumtext primary_key string text time timestamp tinyblob tinytext unsigned_bigint unsigned_decimal unsigned_float unsigned_integer]
    elsif version? '~> 4.2.0'
      expect(native_types.length).to eq 11
      expect(native_types.sort).to eq %w[binary boolean date datetime decimal float integer primary_key string text time]
    end
  end

  it 'supports the following types' do
    supporting_types = AllMysqlType.connection.send(:type_map).try do |type_map|
      type_map = type_map.instance_variable_get(:@parent) if version? '> 7.0.0'
      type_map.instance_variable_get(:@mapping).keys.map do |key|
        key.source.gsub(/\^|(\\.*\Z)/, '')
      end.compact.uniq
    end

    if version? '> 5.0.0'
      expect(supporting_types.length).to eq 31
      expect(supporting_types.sort).to eq %w[bigint binary bit blob boolean char clob date datetime decimal double enum float int json longblob longtext mediumblob mediumint mediumtext number numeric set smallint text time timestamp tinyblob tinyint tinytext year]
    elsif version? '~> 4.2.0'
      expect(supporting_types.length).to eq 30
      expect(supporting_types.sort).to eq %w[bigint binary bit blob boolean char clob date datetime decimal double enum float int longblob longtext mediumblob mediumint mediumtext number numeric set smallint text time timestamp tinyblob tinyint tinytext year]
    end
  end
end
