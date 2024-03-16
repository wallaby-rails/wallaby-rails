# frozen_string_literal: true

require 'rails_helper'
require 'parslet/convenience'
require 'parslet/rig/rspec'

describe Wallaby::Parser do
  describe '#parse' do
    it 'parses very complicated statement' do
      expect(subject.parse('"quoted key" nil null "" "nil" 123.45 "123.45" true "true" false "false" field1:!key1,key2,key3,true field2:>key21 field3:<>nil,123.45,true,false,"nil","true" fuzzy query "all good"')).to eq(
        [
          { string: 'quoted key' },
          { string: 'nil' },
          { string: 'null' },
          { string: [] },
          { string: 'nil' },
          { string: '123.45' },
          { string: '123.45' },
          { string: 'true' },
          { string: 'true' },
          { string: 'false' },
          { string: 'false' },
          { left: 'field1', op: ':!', right: [
            { string: 'key1' },
            { string: 'key2' },
            { string: 'key3' },
            { boolean: 'true' }
          ] },
          { left: 'field2', op: ':>', right: { string: 'key21' } },
          { left: 'field3', op: ':<>', right: [
            { null: 'nil' },
            { string: '123.45' },
            { boolean: 'true' },
            { boolean: 'false' },
            { string: 'nil' },
            { string: 'true' }
          ] },
          { string: 'fuzzy' },
          { string: 'query' },
          { string: 'all good' }
        ]
      )
    end

    context 'when empty string' do
      it 'parses' do
        expect(subject.parse('')).to eq(null: [])
      end
    end

    context 'when empty string in quotes' do
      it 'parses' do
        expect(subject.parse('""')).to eq(string: [])
      end
    end

    context 'when comma in keyword' do
      it 'parses' do
        expect(subject.parse('"a,b"')).to eq(string: 'a,b')
        expect(subject.parse('a,b')).to eq(string: 'a,b')
      end
    end

    context 'when date string' do
      it 'parses' do
        expect(subject.parse('2020-02-02')).to eq(string: '2020-02-02')
      end
    end

    context 'when date time string' do
      it 'parses' do
        expect(subject.parse('"2020-02-02 02:02"')).to eq(string: '2020-02-02 02:02')
        expect(subject.parse('2020-02-02 02:02')).to eq([{ string: '2020-02-02' }, { string: '02:02' }])
      end
    end

    context 'when time string' do
      it 'parses' do
        expect(subject.parse('"02:02"')).to eq(string: '02:02')
        expect(subject.parse('02:02')).to eq(string: '02:02')
      end
    end
  end

  describe 'colon query' do
    describe '#colon_query' do
      it 'parses' do
        expect(subject.colon_query.parse('field:fuzzy')).to eq(left: 'field', op: ':', right: { string: 'fuzzy' })
        expect(subject.colon_query.parse('field:"fuzzy search"')).to eq(left: 'field', op: ':', right: { string: 'fuzzy search' })
        expect(subject.colon_query.parse('field:"fuzzy search",extra')).to eq(left: 'field', op: ':', right: [{ string: 'fuzzy search' }, { string: 'extra' }])
        expect(subject.colon_query.parse('field:"fuzzy search",extra,"something else"')).to eq(left: 'field', op: ':', right: [{ string: 'fuzzy search' }, { string: 'extra' }, { string: 'something else' }])
        expect(subject.colon_query.parse('field:null,extra,"something else"')).to eq(left: 'field', op: ':', right: [{ null: 'null' }, { string: 'extra' }, { string: 'something else' }])
        expect(subject.colon_query.parse('field:true,extra,"something else"')).to eq(left: 'field', op: ':', right: [{ boolean: 'true' }, { string: 'extra' }, { string: 'something else' }])
        expect(subject.colon_query.parse('and1:cool')).to eq(left: 'and1', op: ':', right: { string: 'cool' })
      end

      context 'when value is the character that operator excludes' do
        it 'parses' do
          expect(subject.colon_query.parse('and1:')).to eq(left: 'and1', op: ':', right: { string: [] })
          expect(subject.colon_query.parse('and1::')).to eq(left: 'and1', op: ':', right: { string: ':' })
          expect(subject.colon_query.parse('and1:,')).to eq(left: 'and1', op: ':', right: [{ string: [] }, { string: [] }])
          expect(subject.colon_query.parse('and1:"')).to eq(left: 'and1', op: ':', right: { string: '"' })
          expect(subject.colon_query.parse('and1:0')).to eq(left: 'and1', op: ':', right: { string: '0' })
          expect(subject.colon_query.parse('and1:x')).to eq(left: 'and1', op: ':', right: { string: 'x' })
        end
      end

      context 'when not starting with letter' do
        it 'does not parse' do
          expect(subject.colon_query).not_to parse('02:02')
          expect(subject.colon_query).not_to parse('-2:02')
          expect(subject.colon_query).not_to parse('=2:02')
        end
      end

      context 'when in quotes' do
        it 'does not parse' do
          expect(subject.colon_query).not_to parse('"field:in_quote"')
        end
      end
    end

    describe '#name' do
      it 'parses' do
        expect(subject.name).to parse('name')
        expect(subject.name).to parse('name1')
        expect(subject.name).to parse('name-')
      end

      context 'when invalid name' do
        it 'does not parse' do
          expect(subject.name).not_to parse(':name')
          expect(subject.name).not_to parse('name:')
          expect(subject.name).not_to parse('0a')
          expect(subject.name).not_to parse('-a')
          expect(subject.name).not_to parse('"a')
        end
      end
    end

    describe '#operator' do
      it 'parses' do
        expect(subject.operator).to parse(':')
        expect(subject.operator).to parse(':!')
        expect(subject.operator).to parse(':<>')
      end

      context 'when invalid opeator' do
        it 'does not parse' do
          expect(subject.operator).not_to parse('::')
          expect(subject.operator).not_to parse(':"')
          expect(subject.operator).not_to parse(':\'')
          expect(subject.operator).not_to parse(':0')
          expect(subject.operator).not_to parse(':,')
          expect(subject.operator).not_to parse(':a')
        end
      end
    end

    describe '#values' do
      it 'parses' do
        expect(subject.values.parse('a')).to eq(string: 'a')
        expect(subject.values.parse('a,b,c')).to eq([{ string: 'a' }, { string: 'b' }, { string: 'c' }])

        expect(subject.values.parse('"a b",z,x')).to eq([{ string: 'a b' }, { string: 'z' }, { string: 'x' }])
        expect(subject.values.parse('z,x,"a b"')).to eq([{ string: 'z' }, { string: 'x' }, { string: 'a b' }])
        expect(subject.values.parse('"a b"')).to eq(string: 'a b')
        expect(subject.values.parse('""')).to eq(string: [])
        expect(subject.values.parse('"')).to eq(string: '"')

        expect(subject.values.parse('",null')).to eq([{ string: '"' }, { null: 'null' }])
        expect(subject.values.parse('",true')).to eq([{ string: '"' }, { boolean: 'true' }])
      end

      context 'when empty string' do
        it 'parses' do
          expect(subject.values.parse('""')).to eq(string: [])
          expect(subject.values.parse('')).to eq(string: [])
        end
      end

      context 'when quoted string' do
        it 'parses' do
          expect(subject.values.parse('"a , b"')).to eq(string: 'a , b')
          expect(subject.values.parse('"a \' , b",\'')).to eq([{ string: "a ' , b" }, { string: "'" }])
        end
      end
    end

    describe '#value' do
      it 'parses' do
        expect(subject.value).to parse('something')

        expect(subject.value).not_to parse(' something')
        expect(subject.value).not_to parse(',something')
      end
    end

    describe '#data' do
      it 'parses' do
        expect(subject.data.parse('nil')).to eq(null: 'nil')
        expect(subject.data.parse('true')).to eq(boolean: 'true')
        expect(subject.data.parse('false')).to eq(boolean: 'false')
        expect(subject.data.parse('')).to eq(string: [])

        expect(subject.data).not_to parse(' something')
        expect(subject.data).not_to parse(',something')
      end
    end
  end

  describe 'basic element' do
    describe '#quoted_string' do
      it 'parses' do
        expect(subject.quoted_string.parse('"something"')).to eq(string: 'something')
        expect(subject.quoted_string.parse("'something'")).to eq(string: 'something')

        expect(subject.quoted_string).not_to parse("something'")
      end
    end

    describe '#string' do
      it 'parses' do
        expect(subject.string).to parse("'something'")
        expect(subject.string).to parse("something'")

        expect(subject.string).not_to parse('')
        expect(subject.string).not_to parse(' ')
      end
    end
  end

  describe 'atomic element' do
    describe '#null' do
      it 'parses' do
        expect(subject.null).to parse('nil')
        expect(subject.null).to parse('nIl')
        expect(subject.null).to parse('null')
        expect(subject.null).to parse('nUlL')

        expect(subject.null).not_to parse('empty')
      end
    end

    describe '#boolean' do
      it 'parses' do
        expect(subject.boolean).to parse('true')
        expect(subject.boolean).to parse('tRue')
        expect(subject.boolean).to parse('True')
        expect(subject.boolean).to parse('false')
        expect(subject.boolean).to parse('faLse')
        expect(subject.boolean).to parse('False')

        expect(subject.boolean).not_to parse('true1')
        expect(subject.boolean).not_to parse('Yes')
        expect(subject.boolean).not_to parse('No')
        expect(subject.boolean).not_to parse('0')
        expect(subject.boolean).not_to parse('1')
        expect(subject.boolean).not_to parse('2')
      end
    end

    describe '#letter' do
      it 'parses' do
        expect(subject.letter).to parse('a')

        expect(subject.letter).not_to parse('0')
        expect(subject.letter).not_to parse('')
        expect(subject.letter).not_to parse('oo')
      end
    end

    describe '#digit' do
      it 'parses' do
        expect(subject.digit).to parse('1')

        expect(subject.digit).not_to parse('a')
        expect(subject.digit).not_to parse('')
        expect(subject.digit).not_to parse('11')
      end
    end

    describe '#dot' do
      it 'parses' do
        expect(subject.dot).to parse('.')

        expect(subject.dot).not_to parse('')
        expect(subject.dot).not_to parse('..')
      end
    end

    describe '#comma' do
      it 'parses' do
        expect(subject.comma).to parse(',')

        expect(subject.comma).not_to parse('')
        expect(subject.comma).not_to parse(',,')
      end
    end

    describe '#spaces' do
      it 'parses' do
        expect(subject.spaces).to parse(' ')
        expect(subject.spaces).to parse('  ')
        expect(subject.spaces).to parse("\n")
        expect(subject.spaces).to parse("\n\n")

        expect(subject.spaces).not_to parse('')
      end
    end

    describe '#colon' do
      it 'parses' do
        expect(subject.colon).to parse(':')

        expect(subject.colon).not_to parse('')
        expect(subject.colon).not_to parse('::')
      end
    end

    describe '#open_quote' do
      it 'parses' do
        expect(subject.open_quote).to parse('"')
        expect(subject.open_quote).to parse("'")

        expect(subject.open_quote).not_to parse('')
        expect(subject.open_quote).not_to parse("''")
        expect(subject.open_quote).not_to parse('""')
      end
    end
  end
end
