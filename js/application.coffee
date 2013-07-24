$(document).ready ->

  $nav = $('nav.slides-nav')
  $container = $('#slides')
  $inner = $container.find('.slides-container')
  viewportW = document.documentElement.clientWidth

  $(window).focus ->
    window_focus = true

  slideNext = (id) ->
    $current = $container.find('.active')
    index = $inner.find('section').index($current)
    if id is "next"
      $next = $current.next()
      width = (index + 1) * 90
      pxVal = (viewportW * (index + 1)) * (90/100)
    else if id is "prev"
      $next = $current.prev()
      width = (index - 1) * 90
      pxVal = (viewportW * (index - 1)) * (90/100)

    if $next.length
      # $inner.css('left', "-#{width}vw")
      $inner.css('transform', "translateX(-#{pxVal}px)")

      $current.removeClass('active')
      $next.addClass('active')

  ## Fix positioning on window resize
  window.onresize = ->
    viewportW = document.documentElement.clientWidth
    $current = $container.find('.active')
    index = $inner.find('section').index($current)
    pxVal = (viewportW * index) * (90/100)
    $inner.css('transform', "translateX(-#{pxVal}px)")

  $(window).keydown (event) ->
    keyCode = event.keyCode or event.which
    arrow =
      left: 37
      up: 38
      right: 39
      down: 40
    switch keyCode
      when arrow.left
        slideNext("prev")
      when arrow.right
        slideNext("next")
      when arrow.down
        showNav()
      when arrow.up
        showNav()


  ## Next/Prev Nav Buttons
  ## -----------------------------------
  $('.arrow').on 'click', ->
    id = $(this).attr('data-id')
    slideNext(id)
    hideDrawer()

  ## Set container width for slider
  ## -----------------------------------
  setInnerWidth = ->
    width = null
    $(".slides-container section").each ->
      width = width + $(this).outerWidth(true) + 3 ## 3 random pixels? Rounding bug?
    $inner.css('width', width)

  setInnerWidth()


  ## Show/Hide Drawer
  ## -----------------------------------
  showNav = ->
    if $container.hasClass('show-nav')
      $container.removeClass('show-nav').addClass('hide-nav')
    else if $container.hasClass('hide-nav')
      $container.removeClass('hide-nav').addClass('show-nav')

  $('.menu').click ->
    showNav()


  ## Drawer Navigation
  ## -----------------------------------
  $('.drawer a').on 'click', ->
    dataId = $(this).attr('href')
    dataId = dataId.replace("#", "")
    $target = $("[data-id='#{dataId}']")
    targetIndex = $inner.find('section').index($target)

    $current = $container.find('.active')
    currentIndex = $inner.find('section').index($current)
    if targetIndex isnt currentIndex
      # width = 90 * targetIndex
      # $inner.css('left', "-#{width}vw")
      pxVal = (viewportW * targetIndex) * (90/100)
      $inner.css('transform', "translateX(-#{pxVal}px)")

      $current.removeClass('active')
      $target.addClass('active')
      hideDrawer()

  hideDrawer = ->
    $inner.on "transitionend webkitTransitionEnd MSTransitionEnd", ->
      $container.removeClass('show-nav').addClass('hide-nav')
