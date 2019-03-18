require 'rails_helper'

describe Wallaby::StylingHelper do
  describe '#html_options' do
    it 'constructs the HTML options' do
      expect(helper.html_classes('css_class')).to eq html_options: { class: 'css_class' }
      expect(helper.html_classes(['css_class'])).to eq html_options: { class: ['css_class'] }
    end
  end

  describe '#fa_icon' do
    it 'returns icon HTML' do
      expect(helper.fa_icon('info')).to eq '<i class="fa fa-info"></i>'
      expect(helper.fa_icon('see-o', 'see')).to eq '<i class="fa fa-see-o fa-see"></i>'
      expect(helper.fa_icon('see-o', 'see', title: 'something')).to eq '<i title="something" class="fa fa-see-o fa-see"></i>'
    end
  end

  describe '#itooltip' do
    it 'returns itooltip HTML' do
      expect(helper.itooltip('<this is a title>')).to eq '<i title="&lt;this is a title&gt;" data-toggle="tooltip" data-placement="top" class="fa fa-info-circle"></i>'
      expect(helper.itooltip('"this is a title"')).to eq '<i title="&quot;this is a title&quot;" data-toggle="tooltip" data-placement="top" class="fa fa-info-circle"></i>'
    end

    context 'when html_safe' do
      it 'escapes quotes' do
        expect(helper.itooltip('<this is a title>'.html_safe)).to eq '<i title="<this is a title>" data-toggle="tooltip" data-placement="top" class="fa fa-info-circle"></i>'
        expect(helper.itooltip('"this is a title"'.html_safe)).to eq '<i title="&quot;this is a title&quot;" data-toggle="tooltip" data-placement="top" class="fa fa-info-circle"></i>'
      end
    end
  end

  describe '#imodal' do
    it 'returns modal HTML' do
      expect(helper.imodal('<this is a title>', '<this is the body>')).to eq '<span class="modaler"><a data-target="#imodal" data-toggle="modal" href="#"><i class="fa fa-clone"></i></a><span class="modaler__title">&lt;this is a title&gt;</span><span class="modaler__body">&lt;this is the body&gt;</span></span>'
      expect(helper.imodal('<this is a title>'.html_safe, '<this is the body>'.html_safe)).to eq '<span class="modaler"><a data-target="#imodal" data-toggle="modal" href="#"><i class="fa fa-clone"></i></a><span class="modaler__title"><this is a title></span><span class="modaler__body"><this is the body></span></span>'
    end
  end

  describe '#null' do
    it 'returns null HTML' do
      expect(helper.null).to eq '<i class="text-muted">&lt;null&gt;</i>'
    end
  end

  describe '#na' do
    it 'returns na HTML' do
      expect(helper.na).to eq '<i class="text-muted">&lt;n/a&gt;</i>'
    end
  end

  describe '#muted' do
    it 'returns muted HTML in HTML escape regardless html_safe' do
      expect(helper.muted('<content>')).to eq '<i class="text-muted">&lt;&lt;content&gt;&gt;</i>'
      expect(helper.muted('<content>'.html_safe)).to eq '<i class="text-muted">&lt;&lt;content&gt;&gt;</i>'
    end
  end
end
