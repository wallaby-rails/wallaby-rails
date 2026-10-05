/* global jQuery, documentReady */
// Initialise the auto_select fields (belongs_to / has_many / has_and_belongs_to_many).
//
// This lives in an external asset instead of an inline <script> emitted by the
// view partials. Everything the behaviour needs (remote URL, wildcard, initial
// selection) is read from the `data-*` attributes rendered on the elements.
(function (jQuery) {
  'use strict';

  documentReady('.auto_select_init', function () {
    // belongs_to: a polymorphic <select> may switch the remote URL per class.
    jQuery('[data-init="belongs_to"]').each(function () {
      var $container = jQuery(this);
      var $select = $container.find('select');

      if (!$select.length) {
        $container.auto_select();
        return;
      }

      $select
        .on('change.auto_select', function (_event, initialising) {
          var $option = jQuery(this.selectedOptions);
          var url = $option.data('url');

          if (!url) { return; }

          $container.data('url', url).auto_select();

          if (initialising) { return; }

          $container.find('ul a').trigger('click.auto_select');
        })
        .trigger('change.auto_select', true);
    });

    // has_many / has_and_belongs_to_many
    jQuery('[data-init="has_many"], [data-init="has_and_belongs_to_many"]').auto_select();
  });
})(window.jQuery);
