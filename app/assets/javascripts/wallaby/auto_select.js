'use strict';

jQuery.fn.extend({
  auto_select: function (typeahead_options, engine_options) {
    var $this = jQuery(this),
        $input = jQuery('div input', this),
        $template = jQuery('<li><input type="hidden" /><a href="javascript:,"></a></li>'),
        name = $input.attr('name'),
        multiple = $input.attr('multiple');

    var recreate_typeahead = function () {
      var data = $this.data(),
          options = jQuery.extend({
            highlight: true,
            hint: true,
            minLength: 1
          }, typeahead_options || {}),
          source_options = {
            name: data.source,
            display: 'label',
            source: new Bloodhound(jQuery.extend({
              remote: {
                url: data.url,
                wildcard: data.wildcard
              },
              queryTokenizer: Bloodhound.tokenizers.whitespace,
              datumTokenizer: Bloodhound.tokenizers.whitespace
            }, engine_options || {}))
          };
      $input.typeahead('destroy')
      $input.typeahead(options, source_options);
    };
    $this.off('reload.auto_select')
      .on('reload.auto_select', recreate_typeahead)
      .trigger('reload');

    var disable_typeahead_on_single_selection = function () {
      $input.prop('disabled', !multiple && $this.find('a').length === 1);
      $this.find('.auto_select__count span').text($this.find('a').length);
    };
    $this.off('update.auto_select')
      .on('update.auto_select', disable_typeahead_on_single_selection)
      .trigger('update');

    $input.removeAttr('name').removeAttr('multiple'); // some clean up for the input

    var append_and_focus_on_selection = function (event, suggestion) {
      var $a,
          $existing = $this.find('input[value=' + suggestion.id + ']');
      if ($existing.length) {
        $a = $existing.next();
      } else {
        var $new_item = $template.clone();
        $new_item.find('input').attr('name', name).val(suggestion.id);
        $this.find('ul').append($new_item);
        $a = $new_item.find('a').text(suggestion.label);
        $this.trigger('update');
      }
      if (multiple) { $a.focus(); }
      $input.typeahead('val', '');
    };
    var ignore_tab_and_enter = function (e) {
      var k = e.keyCode || e.which;
      if (k == 13) { return false; }
    };
    $input.off('typeahead:select').off('typeahead:change')
      .on('typeahead:select typeahead:autocomplete', append_and_focus_on_selection)
      .on('keypress', ignore_tab_and_enter);

    var remove_selection = function () {
      jQuery(this).parent().remove();
      $this.trigger('update');
    };
    $this.off('click.auto_select').
      on('click.auto_select', 'a', remove_selection);
  }
});
