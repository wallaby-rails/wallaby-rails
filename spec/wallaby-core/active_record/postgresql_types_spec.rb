# frozen_string_literal: true

require 'rails_helper'

describe 'PostgreSQL Types' do
  let(:version_expected) do
    {
      5 => {
        0 => {
          size_of_column_methods: 30,
          column_methods: %w[bigserial bit bit_varying box cidr circle citext daterange hstore inet int4range int8range json jsonb line lseg ltree macaddr money numrange path point polygon primary_key serial tsrange tstzrange tsvector uuid xml],
          size_of_native_types: 38,
          native_types: %w[binary bit bit_varying boolean box cidr circle citext date daterange datetime decimal float hstore inet int4range int8range integer json jsonb line lseg ltree macaddr money numrange path point polygon primary_key string text time tsrange tstzrange tsvector uuid xml],
          size_of_all_types: 40,
          all_types: %w[bigserial binary bit bit_varying boolean box cidr circle citext date daterange datetime decimal float hstore inet int4range int8range integer json jsonb line lseg ltree macaddr money numrange path point polygon primary_key serial string text time tsrange tstzrange tsvector uuid xml],
          size_of_supporting_types: 40,
          supporting_types: %w[bit bool box bpchar bytea char cidr circle citext date float4 float8 hstore inet int2 int4 int8 interval json jsonb line lseg ltree macaddr money name numeric oid path point polygon text time timestamp timestamptz tsvector uuid varbit varchar xml]
        },
        1 => {
          size_of_column_methods: 32,
          column_methods: %w[bigserial bit bit_varying box cidr circle citext daterange hstore inet int4range int8range interval json jsonb line lseg ltree macaddr money numrange oid path point polygon primary_key serial tsrange tstzrange tsvector uuid xml],
          size_of_native_types: 40,
          native_types: %w[binary bit bit_varying boolean box cidr circle citext date daterange datetime decimal float hstore inet int4range int8range integer interval json jsonb line lseg ltree macaddr money numrange oid path point polygon primary_key string text time tsrange tstzrange tsvector uuid xml],
          size_of_all_types: 42,
          all_types: %w[bigserial binary bit bit_varying boolean box cidr circle citext date daterange datetime decimal float hstore inet int4range int8range integer interval json jsonb line lseg ltree macaddr money numrange oid path point polygon primary_key serial string text time tsrange tstzrange tsvector uuid xml],
          size_of_supporting_types: 40,
          supporting_types: %w[bit bool box bpchar bytea char cidr circle citext date float4 float8 hstore inet int2 int4 int8 interval json jsonb line lseg ltree macaddr money name numeric oid path point polygon text time timestamp timestamptz tsvector uuid varbit varchar xml]
        },
        2 => {
          size_of_column_methods: 31,
          column_methods: %w[bigserial bit bit_varying box cidr circle citext daterange hstore inet int4range int8range interval jsonb line lseg ltree macaddr money numrange oid path point polygon primary_key serial tsrange tstzrange tsvector uuid xml],
          size_of_native_types: 40,
          native_types: %w[binary bit bit_varying boolean box cidr circle citext date daterange datetime decimal float hstore inet int4range int8range integer interval json jsonb line lseg ltree macaddr money numrange oid path point polygon primary_key string text time tsrange tstzrange tsvector uuid xml],
          size_of_all_types: 42,
          all_types: %w[bigserial binary bit bit_varying boolean box cidr circle citext date daterange datetime decimal float hstore inet int4range int8range integer interval json jsonb line lseg ltree macaddr money numrange oid path point polygon primary_key serial string text time tsrange tstzrange tsvector uuid xml],
          size_of_supporting_types: 40,
          supporting_types: %w[bit bool box bpchar bytea char cidr circle citext date float4 float8 hstore inet int2 int4 int8 interval json jsonb line lseg ltree macaddr money name numeric oid path point polygon text time timestamp timestamptz tsvector uuid varbit varchar xml]
        }
      }
    }
  end

  let(:expected) { minor version_expected }

  it 'supports the following column and native types' do
    column_methods = ActiveRecord::ConnectionAdapters::PostgreSQL::ColumnMethods.instance_methods.map(&:to_s)
    native_types = ActiveRecord::ConnectionAdapters::PostgreSQLAdapter::NATIVE_DATABASE_TYPES.keys.map(&:to_s)
    all_types = column_methods | native_types

    if version? '~> 5.0.0'
      expect(column_methods.length).to eq 30
      expect(column_methods.sort).to eq %w[bigserial bit bit_varying box cidr circle citext daterange hstore inet int4range int8range json jsonb line lseg ltree macaddr money numrange path point polygon primary_key serial tsrange tstzrange tsvector uuid xml]

      expect(native_types.length).to eq 38
      expect(native_types.sort).to eq %w[binary bit bit_varying boolean box cidr circle citext date daterange datetime decimal float hstore inet int4range int8range integer json jsonb line lseg ltree macaddr money numrange path point polygon primary_key string text time tsrange tstzrange tsvector uuid xml]

      expect(all_types.length).to eq 40
      expect(all_types.sort).to eq %w[bigserial binary bit bit_varying boolean box cidr circle citext date daterange datetime decimal float hstore inet int4range int8range integer json jsonb line lseg ltree macaddr money numrange path point polygon primary_key serial string text time tsrange tstzrange tsvector uuid xml]
    elsif version? '~> 5.1.0'
      expect(column_methods.length).to eq 32
      expect(column_methods.sort).to eq %w[bigserial bit bit_varying box cidr circle citext daterange hstore inet int4range int8range interval json jsonb line lseg ltree macaddr money numrange oid path point polygon primary_key serial tsrange tstzrange tsvector uuid xml]

      expect(native_types.length).to eq 40
      expect(native_types.sort).to eq %w[binary bit bit_varying boolean box cidr circle citext date daterange datetime decimal float hstore inet int4range int8range integer interval json jsonb line lseg ltree macaddr money numrange oid path point polygon primary_key string text time tsrange tstzrange tsvector uuid xml]

      expect(all_types.length).to eq 42
      expect(all_types.sort).to eq %w[bigserial binary bit bit_varying boolean box cidr circle citext date daterange datetime decimal float hstore inet int4range int8range integer interval json jsonb line lseg ltree macaddr money numrange oid path point polygon primary_key serial string text time tsrange tstzrange tsvector uuid xml]
    elsif version? '~> 5.2.0'
      expect(column_methods.length).to eq 31
      expect(column_methods.sort).to eq %w[bigserial bit bit_varying box cidr circle citext daterange hstore inet int4range int8range interval jsonb line lseg ltree macaddr money numrange oid path point polygon primary_key serial tsrange tstzrange tsvector uuid xml]

      expect(native_types.length).to eq 40
      expect(native_types.sort).to eq %w[binary bit bit_varying boolean box cidr circle citext date daterange datetime decimal float hstore inet int4range int8range integer interval json jsonb line lseg ltree macaddr money numrange oid path point polygon primary_key string text time tsrange tstzrange tsvector uuid xml]

      expect(all_types.length).to eq 42
      expect(all_types.sort).to eq %w[bigserial binary bit bit_varying boolean box cidr circle citext date daterange datetime decimal float hstore inet int4range int8range integer interval json jsonb line lseg ltree macaddr money numrange oid path point polygon primary_key serial string text time tsrange tstzrange tsvector uuid xml]
    elsif version? '~> 4.2.0'
      expect(column_methods.length).to eq 21
      expect(column_methods.sort).to eq %w[bit bit_varying cidr citext daterange hstore inet int4range int8range json jsonb ltree macaddr money numrange point tsrange tstzrange tsvector uuid xml]

      expect(native_types.length).to eq 34
      expect(native_types.sort).to eq %w[bigint bigserial binary bit bit_varying boolean cidr citext date daterange datetime decimal float hstore inet int4range int8range integer json jsonb ltree macaddr money numrange point primary_key string text time tsrange tstzrange tsvector uuid xml]

      expect(all_types.length).to eq 34
      expect(all_types.sort).to eq %w[bigint bigserial binary bit bit_varying boolean cidr citext date daterange datetime decimal float hstore inet int4range int8range integer json jsonb ltree macaddr money numrange point primary_key string text time tsrange tstzrange tsvector uuid xml]
    end
  end

  it 'supports the following types' do
    supporting_types = AllPostgresType.connection.send(:type_map).try do |type_map|
      type_map.instance_variable_get(:@mapping).keys.map do |key|
        key.is_a?(String) ? key : nil
      end.compact.uniq
    end

    expect(supporting_types.length).to eq 40
    expect(supporting_types.sort).to eq %w[bit bool box bpchar bytea char cidr circle citext date float4 float8 hstore inet int2 int4 int8 interval json jsonb line lseg ltree macaddr money name numeric oid path point polygon text time timestamp timestamptz tsvector uuid varbit varchar xml]
  end

  if Rails::VERSION::MAJOR >= 5
    describe 'point' do
      after do
        AllPostgresType.attribute :point, :point
      end

      it 'raises if point value is invalid' do
        record = nil

        expect { record = AllPostgresType.new point: ['', '4.0'] }.not_to raise_error
        expect { record.point }.to raise_error ArgumentError
        expect { record.changes }.to raise_error ArgumentError
        expect { record.save }.to raise_error ArgumentError

        expect { record = AllPostgresType.new point: ['3.0', ''] }.not_to raise_error
        expect { record.point }.to raise_error ArgumentError
        expect { record.changes }.to raise_error ArgumentError
        expect { record.save }.to raise_error ArgumentError

        expect { AllPostgresType.create point: ['', '4.0'] }.to raise_error ArgumentError
        expect { AllPostgresType.create point: ['3.0', ''] }.to raise_error ArgumentError
        expect { AllPostgresType.create point: ['3.0', '4.0'] }.not_to raise_error
      end

      context 'with legacy point' do
        before do
          AllPostgresType.attribute :point, :legacy_point
        end

        it 'raises if legacy point value is invalid' do
          record = nil

          expect { record = AllPostgresType.new point: ['', '4.0'] }.not_to raise_error
          expect { record.point }.to raise_error ArgumentError
          expect { record.changes }.to raise_error ArgumentError
          expect { record.save }.to raise_error ArgumentError

          expect { record = AllPostgresType.new point: ['3.0', ''] }.not_to raise_error
          expect { record.point }.to raise_error ArgumentError
          expect { record.changes }.to raise_error ArgumentError
          expect { record.save }.to raise_error ArgumentError

          expect { AllPostgresType.create point: ['', '4.0'] }.to raise_error ArgumentError
          expect { AllPostgresType.create point: ['3.0', ''] }.to raise_error ArgumentError
          expect { AllPostgresType.create point: ['3.0', '4.0'] }.not_to raise_error
        end
      end
    end
  end

  it 'raises if date/time range value is invalid' do
    record = nil

    if Rails::VERSION::MAJOR >= 5
      expect { record = AllPostgresType.new daterange: ['', '2016-03-29'] }.not_to raise_error
      expect { record.daterange }.not_to raise_error

      expect { record = AllPostgresType.new daterange: ['2016-03-29', ''] }.not_to raise_error
      expect { record.daterange }.not_to raise_error

      expect { record = AllPostgresType.new tsrange: ['', '2016-03-29 12:59:59'] }.not_to raise_error
      expect { record.tsrange }.not_to raise_error

      expect { record = AllPostgresType.new tsrange: ['2016-03-29 12:59:59', ''] }.not_to raise_error
      expect { record.tsrange }.not_to raise_error

      expect { record = AllPostgresType.new tstzrange: ['', '2016-03-29 12:59:59 +00:00'] }.not_to raise_error
      expect { record.tstzrange }.not_to raise_error

      expect { record = AllPostgresType.new tstzrange: ['2016-03-29 12:59:59 +00:00', ''] }.not_to raise_error
      expect { record.tstzrange }.not_to raise_error
    elsif Rails::VERSION::MAJOR == 4
      expect { record = AllPostgresType.new daterange: ['', '2016-03-29'] }.to raise_error ArgumentError, 'bad value for range'
      expect { record = AllPostgresType.new daterange: ['2016-03-29', ''] }.to raise_error ArgumentError, 'bad value for range'
      expect { record = AllPostgresType.new tsrange: ['', '2016-03-29 12:59:59'] }.to raise_error ArgumentError, 'bad value for range'
      expect { record = AllPostgresType.new tsrange: ['2016-03-29 12:59:59', ''] }.to raise_error ArgumentError, 'bad value for range'
      expect { record = AllPostgresType.new tstzrange: ['', '2016-03-29 12:59:59 +00:00'] }.to raise_error ArgumentError, 'bad value for range'
      expect { record = AllPostgresType.new tstzrange: ['2016-03-29 12:59:59 +00:00', ''] }.to raise_error ArgumentError, 'bad value for range'
    end
  end
end
