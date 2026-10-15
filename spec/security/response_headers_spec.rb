# frozen_string_literal: true

require 'rails_helper'

# Security regression specs: the CSV export file name is derived from the
# request (`params[:resources]`) and interpolated into `Content-Disposition`.
# It must be reduced to characters that cannot break out of the header token.
# See the security audit finding L-4.
describe Wallaby::ResourcesResponder do
  describe '.sanitize_file_name' do
    it 'keeps only Content-Disposition safe characters' do
      expect(described_class.sanitize_file_name('products')).to eq 'products'
      expect(described_class.sanitize_file_name('order_items.csv')).to eq 'order_items.csv'
    end

    it 'neutralises CRLF, quotes and separators that could inject a header' do
      expect(described_class.sanitize_file_name("products\r\nX-Evil: 1\"")).to eq 'products--X-Evil--1-'
    end
  end
end
