/* global jQuery, Bloodhound */

(function (jQuery, Bloodhound) {
  'use strict';

  var $template = jQuery('<li class="auto_select__item"><input type="hidden" /><a href="javascript:;" class="auto_select__link"></a></li>');

  jQuery.fn.extend({
    auto_select: function (typeaheadOptions, engineOptions) {
      jQuery(this).each(function () {
        var $container = jQuery(this),
            $input = $container.find('div input:visible');

        setup($container, $input, typeaheadOptions, engineOptions);

        $input
          .off('typeahead:select')
          .off('typeahead:change')
          .on('typeahead:select typeahead:autocomplete', function onSelect(_event, suggestion) {
            appendAndFocusOnSelection($container, $input, suggestion);
          })
          .on('keypress', ignoreTabAndEnter);

        $container
          .off('click.auto_select')
          .on('click.auto_select', 'a', function onRemove(_event) {
            jQuery(this).parent().remove();
            disableTypeaheadOnSingleSelection($container, $input);
          });
      });
    }
  });

  function setup($container, $input, typeaheadOptions, engineOptions) {
    moveAttributesIntoDataFor($input);
    recreateTypeahead($input, typeaheadOptions, engineOptions, $container.data());
    disableTypeaheadOnSingleSelection($container, $input);
  }

  function moveAttributesIntoDataFor($input) {
    $input.data('name', $input.attr('name'));
    $input.data('multiple', $input.attr('multiple'));
    $input.removeAttr('name').removeAttr('multiple');
  }

  function recreateTypeahead($input, typeaheadOptions, engineOptions, containerOptions) {
    var options = jQuery.extend({
          highlight: true,
          hint: true,
          minLength: 1
        }, typeaheadOptions),
        sourceOptions = {
          name: containerOptions.source,
          display: 'label',
          source: new Bloodhound(
            jQuery.extend({
              remote: {
                url: containerOptions.url,
                wildcard: containerOptions.wildcard
              },
              queryTokenizer: Bloodhound.tokenizers.whitespace,
              datumTokenizer: Bloodhound.tokenizers.whitespace
            }, engineOptions)
          )
        };

    $input.typeahead('destroy')
    $input.typeahead(options, sourceOptions);
  }

  function disableTypeaheadOnSingleSelection($container, $input) {
    var $anchors = $container.find('a'),
        $count = $container.find('.auto_select__count span'),
        countOfAnchors = $anchors.length,
        isMultiple = $input.data('multiple');
    $input.prop('disabled', !isMultiple && countOfAnchors === 1);
    $count.text(countOfAnchors);
  }

  function appendAndFocusOnSelection($container, $input, suggestion) {
    var $anchor,
        $existing = $container.find('input[value=' + suggestion.id + ']'),
        isMultiple = $input.data('multiple'),
        inputName = $input.data('name');
    if ($existing.length) {
      $anchor = $existing.next();
    } else {
      var $newItem = $template.clone(),
          $itemInput = $newItem.find('input'),
          $list = $container.find('ul');
      $itemInput.attr('name', inputName).val(suggestion.id);
      $list.append($newItem);
      $anchor = $newItem.find('a').text(suggestion.label);
      disableTypeaheadOnSingleSelection($container, $input);
    }
    if (isMultiple) { $anchor.focus(); }
    $input.typeahead('val', '');
  }

  function ignoreTabAndEnter(event) {
    var keyCode = event.keyCode || event.which;
    if (keyCode === 13 || keyCode === 9) { return false; }
  }
})(jQuery, Bloodhound);
