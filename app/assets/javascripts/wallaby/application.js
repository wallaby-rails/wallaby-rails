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
    jQuery('.page-header .pull-right').each(function () {
      var $this = jQuery(this)
      $this.find('input:visible').on('focus', function () {
        $this.addClass('focus')
      }).on('blur', function () {
        $this.removeClass('focus')
      })
    })

    jQuery('.data-table tbody tr, .actions-table tbody tr').each(function () {
      var $this = jQuery(this)
      var index = $this.index() + 1
      var $this_line = jQuery('.data-table tbody tr:nth-child(' + index + '), .data-table tbody tr:nth-child(' + index + ')')
      $this.hover(function () {
        $this_line.addClass('hover')
      }, function () {
        $this_line.removeClass('hover')
      })
    })
  })
})
