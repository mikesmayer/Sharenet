#= require jquery_ujs
#= require dataTables/jquery.dataTables
#require turbolinks
#= require_tree .

jQuery ($) ->

  show_alert = (type, messages) ->
    _class = 'alert-' + type
    _elem = $('<div class="alert ' + _class + ' alert-dismissable"></div>')
    _elem.append '<button class="close" aria-hidden="true" data-dismiss="alert" type="button">×</button>'
    for message in messages
      _elem.append message+'<br>'

    $('#alert-panel').html _elem
    setTimeout( ->
      _elem.slideToggle()
    5000)

  initialize_datatables = ->
    tables = []
    $('.table-datatable').each (index) ->
      columns = []
      column_count = $(this).find('tr:first-child th').length
      column_count = parseInt( $(this).attr('ajax-data-columns') ) if $(this).attr('ajax-data-columns')?

      no_sorts = []
      no_sorts = $(this).attr('no-sortable').split(' ') if $(this).attr('no-sortable')?

      for i in [0 .. column_count-1]
        columns[i] = {}
        columns[i] = orderable: false if i.toString() in no_sorts

      tables[index] = $(this).dataTable(
        processing: true
        serverSide: true
        ajax:
          url: $(this).attr 'ajax-for'
          type: "post"

        columns: columns
      )

    tables

  reload_datatables = (tables) ->
    for table in tables
      table.fnDraw true


  $(document).ready ->
    $('#side-menu').metisMenu()

    datatables = initialize_datatables()

    $(document).on "click", (event) ->
      target = event.target
      $elem = $(target).closest 'a'

      if $elem.hasClass 'needs-confirmation'
        if not confirm('Are you sure to continue this operation?')
          event.preventDefault()
          event.stopPropagation()
          return

      if $elem.hasClass 'ajax-partial-link'
        href = $elem.attr 'href'
        $('#ajax-partial-area').load href, ->
          $('#ajax-partial-area').hide()
          $('#ajax-partial-area').slideToggle 500
        event.preventDefault()

      else if $elem.hasClass 'partial-closer'
        $content = $('#ajax-partial-area').find '#partial-content'
        if $content.length > 0
          $content.animate {height:0}, 500, ->
            $(this).remove();
          event.preventDefault()

      else if $elem.hasClass 'ajax-content-link'
        href = $elem.attr 'href'
        $('#page-wrapper').load href + ' #page-content', ->
          datatables = initialize_datatables()
        event.preventDefault()

      else if $elem.hasClass 'ajax-link'
        href = $elem.attr 'href'
        $.post(href, (data) ->
          if (data.result == 'success')
            show_alert('success', ['Operation is completed successfully.'])
            reload_datatables(datatables)
          else
            show_alert('danger', data['error'])
        'json'
        )
        event.preventDefault()

      else if $(target).attr('type')? and $(target).attr('type').toLowerCase() is 'submit'
        $form = $(target).closest 'form'
        if $form.hasClass 'ajax-form'
          $form.ajaxForm (data)->
            if data['result'] is 'success'
              $content = $('#ajax-partial-area').find '#partial-content'
              $content.slideToggle 500 if $content.hasClass 'for-form'
              show_alert 'success', ['The category is saved successfully.']
              reload_datatables datatables
            else
              show_alert 'danger', data['error']

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

