require 'rails_helper'

describe 'Mysql Types' do
  it 'returns the expected native types' do
    native_types = ActiveRecord::ConnectionAdapters::AbstractMysqlAdapter::NATIVE_DATABASE_TYPES.keys.map &:to_s

    expect(native_types.length).to eq 12
    expect(native_types.sort).to eq [ "binary", "boolean", "date", "datetime", "decimal", "float", "integer", "json", "primary_key", "string", "text", "time" ]
  end

  it 'supports the following types' do
    supporting_types = AllMysqlType.connection.type_map.try do |type_map|
      type_map.instance_variable_get('@mapping').keys.map do |key|
        key.source.gsub %r(\^|(\\.*\Z)), ''
      end.compact.uniq
    end

    expect(supporting_types.length).to eq 31
    expect(supporting_types.sort).to eq [ "bigint", "binary", "bit", "blob", "boolean", "char", "clob", "date", "datetime", "decimal", "double", "enum", "float", "int", "json", "longblob", "longtext", "mediumblob", "mediumint", "mediumtext", "number", "numeric", "set", "smallint", "text", "time", "timestamp", "tinyblob", "tinyint", "tinytext", "year" ]
  end
end
