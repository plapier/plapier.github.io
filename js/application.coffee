class ConstructSlider
  @viewportW
  constructor: () ->
    @nav       = $('nav.slides-nav')
    @drawer    = $('.drawer')
    @container = $('#slides')
    @inner     = @container.find('.slides-container')
    @setInnerWidth()
    @setupArrows()
    @setupDrawerNav()
    @setupImagesNav()
    @setupKeybindings()
    @watchViewportWidth()

  setInnerWidth: ->
    width = null
    @inner.find('section').each ->
      width = width + $(this).outerWidth(true) + 3 ## 3 random pixels? Rounding bug?
    @inner.css('width', width)

  ## Next/Prev Nav Buttons
  setupArrows: ->
    @inner.find('.nav-info').addClass('slide-up') # keyboard shortcuts popup
    @nav.on 'click', '.arrow', (event) =>
      id = $(event.target).attr('data-id')
      @slideNext(id)
      @hideDrawer()

  slideNext: (id) ->
    $current = @container.find('.active')
    index = @inner.find('section').index($current)
    if id is "next"
      $next = $current.next()
      width = (index + 1) * 90
      pxVal = (@viewportW * (index + 1)) * (90/100)
    else if id = "prev"
      $next = $current.prev()
      width = (index - 1) * 90
      pxVal = (@viewportW * (index - 1)) * (90/100)

    if $next.length
      $target = $current.find('div')
      timeout = 0
      speed = 400
      $scrollPos = $current.scrollTop()
      if $scrollPos > 100
        offset = $current.scrollTop()
        $target.addClass('animate').css('transform', "translateY(#{offset}px")
        $target.on "transitionend webkitTransitionEnd MSTransitionEnd", ->
          $(this).removeClass('animate')
        timeout = speed + 50

      window.setTimeout (=>
        @inner.css('transform', "translateX(-#{pxVal}px)")
        $current.removeClass('active')
        $next.addClass('active')
        @inner.on "transitionend webkitTransitionEnd MSTransitionEnd", ->
          $target.css('transform', "translateX(0)")
          $current.scrollTop(0)
      ), timeout
      @hideDrawer()

  ## Drawer Navigation
  setupDrawerNav: ->
    @nav.find('.menu').click =>
      @toggleDrawer()

    @drawer.find('a').on 'click', (event) =>
      dataId = $(event.target).attr('href')
      dataId = dataId.replace("#", "")
      $target = @inner.find("[data-id='#{dataId}']")
      $targetIndex = $target.index()

      $current = @container.find('.active')
      $currentIndex = $current.index()
      diff = Math.abs($targetIndex - $currentIndex)

      if $targetIndex isnt $currentIndex
        pxVal = Math.floor (@viewportW * $targetIndex) * (90/100)
        $current.removeClass('active') ## THIS
        $target.addClass('active')
        @inner.addClass("transition-#{diff}").css('transform', "translateX(-#{pxVal}px)")
        @hideDrawer()
        $current.scrollTop(0)

        # Set active drawer anchor
        $(event.target).parent().addClass('active').siblings().removeClass('active')


  ## For Multiples images in a single browser frame
  setupImagesNav: ->
    @setBrowserHeight()
    @inner.find('nav.dots').on 'click', 'span', ->
      if !$(this).hasClass('current')
        $(this).addClass('current').siblings().removeClass('current')
        index = $(this).index()
        images = $(this).parent().siblings('img')
        $(images[index]).addClass('current').siblings().removeClass('current')

  setBrowserHeight: ->
    @inner.find('.multiple-images').each ->
      imageHeight = $(this).find('img.current').outerHeight()
      $(this).height(imageHeight)

  ## Show/Hide Drawer
  toggleDrawer: (val) ->
    if val is "close"    or @container.hasClass('show-nav')
      @container.removeClass('show-nav').addClass('hide-nav')
    else if val = 'open' or @container.hasClass('show-nav')
      @container.removeClass('hide-nav').addClass('show-nav')

  hideDrawer: ->
    if @container.hasClass('show-nav')
      @inner.on "transitionend webkitTransitionEnd MSTransitionEnd", =>
        @toggleDrawer("close")
        @inner.removeClass (index, css) ->
          (css.match(/\btransition\S+/g) or []).join " "


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

  ## Setup event listener on resize and set global variable
  watchViewportWidth: ->
    @viewportW = @getViewportW()

    onResize = () =>
      @viewportW = @getViewportW()
      @setInnerWidth()
      @recalculatePos()
      @setBrowserHeight()

    ## Resize after user stops resizing
    $(window).bind "resize", ->
      timer and clearTimeout(timer)
      timer = setTimeout(onResize, 500)

  getViewportW: ->
    document.documentElement.clientWidth

  ## Fix panel positioning
  recalculatePos: ->
    $current = @container.find('.active')
    index    = @inner.find('section').index($current)
    pxVal    = Math.floor (@viewportW * index) * (90/100)
    @inner.css('transform', "translateX(-#{pxVal}px)")

$ ->
  new ConstructSlider()
