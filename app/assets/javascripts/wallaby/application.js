//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require moment
//= require bootstrap-datetimepicker
//= require summernote
//= require codemirror
//= require codemirror/modes/xml
//= require codemirror/modes/ruby
//= require codemirror/modes/javascript
//= require jquery.minicolors
//= require turbolinks

jQuery(document).on('turbolinks:load', function () {
  jQuery('[data-toggle="tooltip"]').tooltip({ html: true, container:'body' })

  jQuery('.index').each(function() {
    jQuery('.query__search', this).each(function () {
      var $this = jQuery(this);
      jQuery('input:visible', this).on('focus.modifier', function () {
        $this.addClass('query--focus');
      }).on('blur', function () {
        $this.removeClass('query--focus');
      })
    })

    jQuery('.resources').each(function () {
      var $this = jQuery(this);

      // let's clone the actions, just for styling
      jQuery('.resources__data', this).each(function () {
        var $actions_table = jQuery('<table></table>').addClass('resources__actions');
        var $thead = jQuery('<thead><tr><th>&nbsp;</th></tr></thead>');
        var $tbody = jQuery('<tbody></tbody>');
        var $tr = jQuery('<tr></tr>');

        jQuery('.resource__actions', this).each(function () {
          $tbody.append($tr.clone().append(jQuery(this).clone()));
        })

        $actions_table.append($thead, $tbody);
        jQuery('> section', $this).append($actions_table);
      })

      // to show double arrows
      jQuery('.resources__container').on('scroll', function () {
        var $container = jQuery(this);
        $th = jQuery('.resources__actions thead th', $this);
        $data_table = jQuery('.resources__data', $this);
        $th.toggleClass('resources--backward', $container.scrollLeft() > 0);
        $th.toggleClass('resources--forward', $container.scrollLeft() + $container.width() < $data_table.width());
      }).trigger('scroll');
    })
  })
})
