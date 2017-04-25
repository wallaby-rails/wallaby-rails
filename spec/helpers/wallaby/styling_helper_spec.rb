require 'rails_helper'

describe Wallaby::StylingHelper do
  describe '#icon' do
    it 'returns icon html' do
      expect(helper.icon('info')).to eq '<i class="glyphicon glyphicon-info"></i>'
    end
  end

  describe '#itooltip' do
    it 'returns itooltip html' do
      expect(helper.itooltip('this is a title')).to eq '<i title="this is a title" data-toggle="tooltip" data-placement="top" class="glyphicon glyphicon-info-sign"></i>'
    end
  end

  describe '#ilink_to' do
    it 'returns icon link html' do
      expect(helper.ilink_to('/path')).to eq '<a href="/path"><i class="glyphicon glyphicon-info-sign"></i></a>'
    end
  end

  describe '#imodal' do
    it 'returns modal html' do
      allow(helper).to receive(:random_uuid) { 'random_uuid' }
      expect(helper.imodal('this is a title', 'this is the body')).to eq '<a data-toggle="modal" data-target="#random_uuid" href="javascript:;"><i class="glyphicon glyphicon-circle-arrow-up"></i></a><div id="random_uuid" class="modal fade" tabindex="-1" role="dialog"><div class="modal-dialog modal-lg"><div class="modal-content"><div class="modal-header"><button name="button" type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button><h4 class="modal-title">this is a title</h4></div><div class="modal-body">this is the body</div></div></div></div>'
    end
  end

  describe '#null' do
    it 'returns null html' do
      expect(helper.null).to eq '<i class="text-muted">&lt;null&gt;</i>'
    end
  end

  describe '#na' do
    it 'returns na html' do
      expect(helper.na).to eq '<i class="text-muted">&lt;n/a&gt;</i>'
    end
  end
end
