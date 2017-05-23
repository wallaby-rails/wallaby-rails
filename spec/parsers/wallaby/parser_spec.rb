require 'rails_helper'
require 'parslet/rig/rspec'

describe Wallaby::Parser do
  it 'parses' do
    expect(subject.parse('"quoted key" field1:!key1,key2,key3 field2:>key21 fuzzy query "all good"')).to eq(
      [
        { keyword: 'quoted key' },
        { left: 'field1', op: ':!', right: [
          { keyword: 'key1' },
          { keyword: 'key2' },
          { keyword: 'key3' }
        ] },
        { left: 'field2', op: ':>', right: { keyword: 'key21' } },
        { keyword: 'fuzzy' },
        { keyword: 'query' },
        { keyword: 'all good' }
      ]
    )
  end

  describe 'colon_query' do
    it 'parses colon_query' do
      expect(subject.colon_query.parse('field:fuzzy')).to eq(left: 'field', op: ':', right: { keyword: 'fuzzy' })
      expect(subject.colon_query.parse('field:"fuzzy search"')).to eq(left: 'field', op: ':', right: { keyword: 'fuzzy search' })
      expect(subject.colon_query.parse('field:"fuzzy search",extra')).to eq(left: 'field', op: ':', right: [{ keyword: 'fuzzy search' }, { keyword: 'extra' }])
      expect(subject.colon_query.parse('field:"fuzzy search",extra,"something else"')).to eq(left: 'field', op: ':', right: [{ keyword: 'fuzzy search' }, { keyword: 'extra' }, { keyword: 'something else' }])
    end
  end

  describe 'name' do
    it 'parses name' do
      expect(subject.name).to parse('name')
      expect(subject.name).not_to parse(' :name')
      expect(subject.name).not_to parse('name ')
      expect(subject.name).not_to parse('name:')
    end
  end

  describe 'operator' do
    it 'parses operator' do
      expect(subject.operator).to parse(':')
      expect(subject.operator).to parse(':!')
      expect(subject.operator).to parse(':<>')
      expect(subject.operator).to parse(':<: ')
      expect(subject.operator).not_to parse(':"')
      expect(subject.operator).not_to parse(': ')
      expect(subject.operator).not_to parse(':0')
      expect(subject.operator).not_to parse(':a')
    end
  end

  describe 'keywords' do
    it 'parses keywords' do
      expect(subject.keywords.parse('a,b,c')).to eq([{ keyword: 'a' }, { keyword: 'b' }, { keyword: 'c' }])
      expect(subject.keywords.parse('a')).to eq(keyword: 'a')
      expect(subject.keywords.parse('"a b",z,x')).to eq([{ keyword: 'a b' }, { keyword: 'z' }, { keyword: 'x' }])
      expect(subject.keywords.parse('z,x,"a b"')).to eq([{ keyword: 'z' }, { keyword: 'x' }, { keyword: 'a b' }])
      expect(subject.keywords.parse('"a b"')).to eq(keyword: 'a b')
      expect(subject.keywords.parse('""')).to eq(keyword: [])
      expect(subject.keywords.parse('"')).to eq(keyword: '"')
    end
  end

  describe 'quoted_keyword' do
    it 'parses quoted_keyword' do
      expect(subject.quoted_keyword.parse('"something"')).to eq(keyword: 'something')
      expect(subject.quoted_keyword.parse("'something'")).to eq(keyword: 'something')
      expect(subject.quoted_keyword).not_to parse("something'")
    end
  end

  describe 'keyword' do
    it 'parses keyword' do
      expect(subject.keyword).to parse('something')
      expect(subject.keyword).not_to parse(' something')
      expect(subject.keyword).not_to parse(',something')
    end
  end

  describe 'comma' do
    it 'parses comma' do
      expect(subject.comma.parse(',')).to eq(',')
    end
  end

  describe 'space' do
    it 'parses spaces' do
      expect(subject.space.parse(' ')).to eq(' ')
      expect(subject.space.parse('  ')).to eq('  ')
      expect(subject.space.parse("\n")).to eq("\n")
      expect(subject.space.parse("\n\n")).to eq("\n\n")
    end
  end

  describe 'colon' do
    it 'parses colon' do
      expect(subject.colon.parse(':')).to eq(':')
    end
  end

  describe 'open_quote' do
    it 'parses open_quote' do
      expect(subject.open_quote.parse('"')).to eq('"')
      expect(subject.open_quote.parse("'")).to eq("'")
    end
  end

  describe 'colon_query' do
    it 'parses colon_query' do
      expect(subject.colon_query).to parse('name:')
      expect(subject.colon_query).to parse('name:pair')
      expect(subject.colon_query).to parse('name:""')
      expect(subject.colon_query).to parse('name:"pair"')
      expect(subject.colon_query).to parse('name:" "')
      expect(subject.colon_query).to parse('name:"first last"')
    end
  end
end
