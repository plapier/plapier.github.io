class ConstructSlider
  constructor: () ->
    @nav       = $('nav.slides-nav')
    @container = $('#slides')
    @inner     = @container.find('.slides-container')
    @setInnerWidth()
    @setupArrows()
    @setupDrawerNav()
    @setupWindowResizer()
    @setupKeybindings()

  setInnerWidth: ->
    width = null
    $(".slides-container section").each ->
      width = width + $(this).outerWidth(true) + 3 ## 3 random pixels? Rounding bug?
    $(@inner).css('width', width)

  ## Next/Prev Nav Buttons
  setupArrows: ->
    $('.main-nav').on 'click', '.arrow', (event) =>
      id = $(event.target).attr('data-id')
      @slideNext(id)
      @hideDrawer()

  slideNext: (id) ->
    viewportW = @viewportWidth()
    $current = $(@container).find('.active')
    index = $(@inner).find('section').index($current)
    if id is "next"
      $next = $current.next()
      width = (index + 1) * 90
      pxVal = (viewportW * (index + 1)) * (90/100)
    else if id = "prev"
      $next = $current.prev()
      width = (index - 1) * 90
      pxVal = (viewportW * (index - 1)) * (90/100)

    if $next.length
      # $inner.css('left', "-#{width}vw")
      $(@inner).css('transform', "translateX(-#{pxVal}px)")
      $current.removeClass('active')
      $next.addClass('active')

  ## Drawer Navigation
  setupDrawerNav: ->
    $('.menu').click =>
      @toggleDrawer()

    $('.drawer a').on 'click', (event) =>
      dataId = $(event.target).attr('href')
      dataId = dataId.replace("#", "")
      $target = $("[data-id='#{dataId}']")
      targetIndex = $(@inner).find('section').index($target)

      $current = @container.find('.active')
      currentIndex = @inner.find('section').index($current)
      if targetIndex isnt currentIndex
        # width = 90 * targetIndex
        # $inner.css('left', "-#{width}vw")
        viewportW = @viewportWidth()
        pxVal = (viewportW * targetIndex) * (90/100)
        @inner.css('transform', "translateX(-#{pxVal}px)")
        $($current).removeClass('active')
        $target.addClass('active')
        @hideDrawer()

  ## Show/Hide Drawer
  toggleDrawer: (val) ->
    if val is "close"    or @container.hasClass('show-nav')
      $(@container).removeClass('show-nav').addClass('hide-nav')
    else if val = 'open' or @container.hasClass('show-nav')
      $(@container).removeClass('hide-nav').addClass('show-nav')

  hideDrawer: ->
    if $(@container).hasClass('show-nav')
      @inner.on "transitionend webkitTransitionEnd MSTransitionEnd", =>
        @toggleDrawer("close")

  ## Fix positioning on window resize
  setupWindowResizer: ->
    window.onresize = =>
      viewportW = @viewportWidth()
      $current = $(@container).find('.active')
      index = $(@inner).find('section').index($current)
      pxVal = (viewportW * index) * (90/100)
      $(@inner).css('transform', "translateX(-#{pxVal}px)")

  setupKeybindings: ->
    $(window).focus ->
      window_focus = true

    $(window).keydown (event) =>
      keyCode = event.keyCode or event.which
      arrow =
        left: 37
        up: 38
        right: 39
        down: 40
      switch keyCode
        when arrow.left
          @slideNext("prev")
        when arrow.right
          @slideNext("next")
        when arrow.down
          @toggleDrawer()
        when arrow.up
          @toggleDrawer()

  viewportWidth: ->
    document.documentElement.clientWidth
$ ->
  new ConstructSlider()
