require 'rails_helper'

describe Wallaby::Her::ModelPaginationProvider do
  describe '#paginatable?' do
    subject { described_class.new [], {} }

    it { expect(subject).not_to be_paginatable }
  end
end
