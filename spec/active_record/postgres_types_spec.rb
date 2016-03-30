require 'rails_helper'

describe 'Postgres Types' do
  it 'returns the expected native types' do
    native_types = ActiveRecord::ConnectionAdapters::PostgreSQLAdapter::NATIVE_DATABASE_TYPES.keys.map &:to_s

    expect(native_types.size).to eq 34
    expect(native_types.sort).to eq [ "bigint", "bigserial", "binary", "bit", "bit_varying", "boolean", "cidr", "citext", "date", "daterange", "datetime", "decimal", "float", "hstore", "inet", "int4range", "int8range", "integer", "json", "jsonb", "ltree", "macaddr", "money", "numrange", "point", "primary_key", "string", "text", "time", "tsrange", "tstzrange", "tsvector", "uuid", "xml" ]
  end

  it 'fails if point value is invalid' do
    expect{ AllPostgresType.new point: [ '', '4.0' ] }.to raise_error ArgumentError
    expect{ AllPostgresType.create point: [ '', '4.0' ] }.to raise_error ArgumentError
    expect{ AllPostgresType.create point: [ '3.0', '' ] }.to raise_error ActiveRecord::StatementInvalid
    expect{ AllPostgresType.create point: [ '3.0', '4.0' ] }.not_to raise_error
  end

  it 'fails if date/time range value is invalid' do
    expect{ AllPostgresType.new daterange: [ '', '2016-03-29' ] }.to raise_error ArgumentError
    expect{ AllPostgresType.new daterange: [ '2016-03-29', '' ] }.to raise_error ArgumentError
    expect{ AllPostgresType.new tsrange: [ '', '2016-03-29 12:59:59' ] }.to raise_error ArgumentError
    expect{ AllPostgresType.new tsrange: [ '2016-03-29 12:59:59', '' ] }.to raise_error ArgumentError
    expect{ AllPostgresType.new tstzrange: [ '', '2016-03-29 12:59:59 +00:00' ] }.to raise_error ArgumentError
    expect{ AllPostgresType.new tstzrange: [ '2016-03-29 12:59:59 +00:00', '' ] }.to raise_error ArgumentError
  end
end
