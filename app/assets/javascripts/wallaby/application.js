//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
jQuery(function ($) {
  $('[data-toggle="tooltip"]').tooltip({ html: true })

  $('.search-form').each(function () {
    var $this = $(this)
    $(this).find('input:visible').on('focus', function () {
      $this.addClass('focus')
    }).on('blur', function () {
      $this.removeClass('focus')
    })
  })
})
