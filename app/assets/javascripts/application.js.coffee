#= require jquery_ujs
#require turbolinks
#= require_tree .

(($) ->
  $(document).ready ->
    $('#side-menu').metisMenu()

  $(window).on "load resize", ->
    topOffset = 50
    #width = (@window.innerWidth > 0) ? @window.innerWidth : @screen.width
    width = @screen.width
    width = @window.innerWidth if @window.innerWidth > 0

    if width < 768
      $('div.navbar-collapse').addClass 'collapse'
      topOffset = 100
    else
      $('div.navbar-collapse').removeClass 'collapse'

    height = @screen.height
    height = @window.innerHeight if @window.innerHeight > 0
    height = height - topOffset
    height = 1 if height < 1
    $('#page-wrapper').css 'min-height', (height)+'px' if height > topOffset




) jQuery


