require 'rails_helper'

describe 'PostgreSQL Types' do
  it 'returns the expected native types' do
    native_types = ActiveRecord::ConnectionAdapters::PostgreSQLAdapter::NATIVE_DATABASE_TYPES.keys.map &:to_s

    expect(native_types.length).to eq 34
    expect(native_types.sort).to eq [ "bigint", "bigserial", "binary", "bit", "bit_varying", "boolean", "cidr", "citext", "date", "daterange", "datetime", "decimal", "float", "hstore", "inet", "int4range", "int8range", "integer", "json", "jsonb", "ltree", "macaddr", "money", "numrange", "point", "primary_key", "string", "text", "time", "tsrange", "tstzrange", "tsvector", "uuid", "xml" ]
  end

  describe 'point' do
    after { AllPostgresType.attribute :point, :point }
    it 'fails if point value is invalid' do
      record = nil

      expect{ record = AllPostgresType.new point: [ '', '4.0' ] }.not_to raise_error
      expect{ record.point }.to raise_error ArgumentError

      expect{ record = AllPostgresType.new point: [ '3.0', '' ] }.not_to raise_error
      expect{ record.point }.to raise_error ArgumentError

      expect{ AllPostgresType.create point: [ '', '4.0' ] }.to raise_error ArgumentError
      expect{ AllPostgresType.create point: [ '3.0', '' ] }.to raise_error ArgumentError
      expect{ AllPostgresType.create point: [ '3.0', '4.0' ] }.not_to raise_error
    end

    context 'legacy point' do
      before { AllPostgresType.attribute :point, :legacy_point }
      it 'fails if legacy point value is invalid' do
        record = nil

        expect{ record = AllPostgresType.new point: [ '', '4.0' ] }.not_to raise_error
        expect{ record.point }.to raise_error ArgumentError

        expect{ record = AllPostgresType.new point: [ '3.0', '' ] }.not_to raise_error
        expect{ record.point }.to raise_error ArgumentError

        expect{ AllPostgresType.create point: [ '', '4.0' ] }.to raise_error ArgumentError
        expect{ AllPostgresType.create point: [ '3.0', '' ] }.to raise_error ArgumentError
        expect{ AllPostgresType.create point: [ '3.0', '4.0' ] }.not_to raise_error
      end
    end
  end

  it 'fails if date/time range value is invalid' do
    expect{ AllPostgresType.new daterange: [ '', '2016-03-29' ] }.to raise_error ArgumentError
    expect{ AllPostgresType.new daterange: [ '2016-03-29', '' ] }.to raise_error ArgumentError
    expect{ AllPostgresType.new tsrange: [ '', '2016-03-29 12:59:59' ] }.to raise_error ArgumentError
    expect{ AllPostgresType.new tsrange: [ '2016-03-29 12:59:59', '' ] }.to raise_error ArgumentError
    expect{ AllPostgresType.new tstzrange: [ '', '2016-03-29 12:59:59 +00:00' ] }.to raise_error ArgumentError
    expect{ AllPostgresType.new tstzrange: [ '2016-03-29 12:59:59 +00:00', '' ] }.to raise_error ArgumentError
  end

  it 'supports the following types' do
    supporting_types = AllPostgresType.connection.type_map.try do |type_map|
      type_map.instance_variable_get('@mapping').keys.map do |key|
        key.is_a?(String) ? key : nil
      end.compact.uniq
    end

    expect(supporting_types.length).to eq 40
    expect(supporting_types.sort).to eq [ "bit", "bool", "box", "bpchar", "bytea", "char", "cidr", "circle", "citext", "date", "float4", "float8", "hstore", "inet", "int2", "int4", "int8", "interval", "json", "jsonb", "line", "lseg", "ltree", "macaddr", "money", "name", "numeric", "oid", "path", "point", "polygon", "text", "time", "timestamp", "timestamptz", "tsvector", "uuid", "varbit", "varchar", "xml" ]
  end
end
