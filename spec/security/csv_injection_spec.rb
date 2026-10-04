# frozen_string_literal: true

require 'rails_helper'

# Security regression specs for CSV formula injection.
#
# Covers OWASP A03: exported fields must not begin with a spreadsheet formula
# character. See the audit finding H2.
describe Wallaby::IndexHelper, type: :helper do
  describe '#csv_escape' do
    it 'prefixes values starting with = with a single quote' do
      expect(helper.csv_escape('=1+1')).to eq "'=1+1"
    end

    it 'prefixes values starting with + with a single quote' do
      expect(helper.csv_escape('+1')).to eq "'+1"
    end

    it 'prefixes values starting with - with a single quote' do
      expect(helper.csv_escape('-1')).to eq "'-1"
    end

    it 'prefixes values starting with @ with a single quote' do
      expect(helper.csv_escape('@SUM(A1)')).to eq "'@SUM(A1)"
    end

    it 'prefixes values starting with a tab with a single quote' do
      expect(helper.csv_escape("\tpayload")).to eq "'\tpayload"
    end

    it 'prefixes values starting with a carriage return with a single quote' do
      expect(helper.csv_escape("\rpayload")).to eq "'\rpayload"
    end

    it 'leaves ordinary strings untouched' do
      expect(helper.csv_escape('ordinary')).to eq 'ordinary'
    end

    it 'leaves non-string values untouched' do
      expect(helper.csv_escape(42)).to eq 42
      expect(helper.csv_escape(nil)).to be_nil
    end
  end
end
