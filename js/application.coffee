class ConstructSlider
  @viewportW
  constructor: () ->
    @transition = "transitionend webkitTransitionEnd MSTransitionEnd"
    @nav       = document.getElementsByClassName('slider-nav')[0]
    @drawer    = document.getElementsByClassName('drawer')[0]
    @container = document.getElementById('slider')
    @inner     = document.getElementById('inner')
    @sections  = @inner.getElementsByTagName('section')
    @setInnerWidth()
    @setupArrows()
    @setupDrawerNav()
    @setupKeybindings()
    @setupSwipeEvents()
    @watchViewportWidth()
    @readHash()

  setInnerWidth: ->
    width = null
    for section in @sections
      width = width + section.offsetWidth + 3 ## 3 random pixels? Rounding bug?
    @inner.style.width = "#{width}px"

  ## Next/Prev Nav Buttons
  setupArrows: ->
    arrows = @inner.getElementsByClassName('nav-info')[0]
    arrows.classList.add('slide-up')

  slideNext: (id) ->
    next = undefined
    current = @container.getElementsByClassName('active')[0]
    index = $(@sections).index(current)

    if id is "next"
      next = current.nextElementSibling
      width = (index + 1) * 90
      pxVal = (@viewportW * (index + 1)) * (90/100)
    else if id = "prev"
      next = current.previousElementSibling
      width = (index - 1) * 90
      pxVal = (@viewportW * (index - 1)) * (90/100)
    @changeHash(next)

    return if !next?

    target = current.getElementsByClassName('frame')[0]
    timeout = 0
    speed = 400
    $scrollPos = $(current).scrollTop()
    if $scrollPos > 100
      offset = $(current).scrollTop()
      target.classList.add('animate')
      $(target).css('transform', "translateY(#{offset}px")
      $(target).on @transition, ->
        target.classList.remove('animate')
        $(target).off(@transition)
      timeout = speed + 50

    window.setTimeout (=>
      $(@inner).css('transform', "translateX(-#{pxVal}px)")
      current.classList.remove('active')
      next.classList.add('active')
      @changeDrawerActive()
      $(@inner).on @transition, =>
        $(target).css('transform', "translateX(0)")
        $(current).scrollTop(0)
        $(@inner).off(@transition)
    ), timeout
    @hideDrawer()

  ## Drawer Navigation
  setupDrawerNav: ->
    $(@nav).on 'click', (event) =>
      if event.target.classList.contains('arrow')
        id = event.target.getAttribute('data-id')
        @slideNext(id)
        @hideDrawer()
        @removeTransitionClass()

      else if event.target.classList.contains('menu')
        @toggleDrawer()
        mixpanel.track("Menu Click")

    $(@drawer).on 'click', (event) =>
      dataId = event.target.getAttribute('href')
      @slideToTarget(dataId)

  slideToTarget: (id) ->
    id = id.replace("#", "")
    target = @inner.querySelectorAll("[data-id='#{id}']")[0]
    current = @container.getElementsByClassName('active')[0]

    $targetIndex = $(target).index()
    $currentIndex = $(current).index()
    return if $targetIndex is $currentIndex

    diff = Math.abs($targetIndex - $currentIndex)
    pxVal = Math.floor (@viewportW * $targetIndex) * (90/100)
    current.classList.remove('active')
    target.classList.add('active')
    @inner.classList.add("transition-#{diff}")
    $(@inner).css('transform', "translateX(-#{pxVal}px)")
    @changeDrawerActive()
    @hideDrawer()
    $(current).scrollTop(0)
    @changeHash(target)
    @removeTransitionClass()

  ## Show/Hide Drawer
  toggleDrawer: (val) ->
    if val is "close" or @container.classList.contains('show-nav')
      @container.classList.remove('show-nav')
      @container.classList.add('hide-nav')
      @drawer.classList.remove('show')
      @drawer.classList.add('hide')
      @nav.classList.remove('show')
      @nav.classList.add('hide')
    else if val = 'open' or @container.classList.contains('show-nav')
      @container.classList.remove('hide-nav')
      @container.classList.add('show-nav')
      @drawer.classList.remove('hide')
      @drawer.classList.add('show')
      @nav.classList.remove('hide')
      @nav.classList.add('show')

  hideDrawer: ->
    return if !@container.classList.contains('show-nav')
    $(@inner).on @transition, =>
      @toggleDrawer("close")
      @removeTransitionClass()
      $(@inner).off @transition

  changeDrawerActive: ->
    selector = $(@container).find('.active').attr('class').split(' ')[0]
    @drawer.getElementsByClassName('active')[0].classList.remove('active')
    @drawer.querySelector("a[href='##{selector}']").parentElement.classList.add('active')

  removeTransitionClass: ->
    $(@inner).removeClass (index, css) ->
      (css.match(/\btransition\S+/g) or []).join " "

  setupSwipeEvents: ->
    $(@inner).hammer(
      drag_min_distance: 50
      drag_lock_to_axis: true
      drag_block_horizontal: true
      drag_block_vertical: true
      ).on("dragstart", (ev) =>
        ev.preventDefault()
        @inner.classList.add('no-transition')

      ).on("drag", (ev) =>
        ev.preventDefault()
        $currentIndex = $(@container).find('.active').index()
        pxVal         = Math.floor (@viewportW * $currentIndex) * (90/100)
        distance      = Math.floor ev.gesture.distance

        if ev.gesture.direction is "right"
          distance = distance * -1

        switch ev.gesture.direction
          when "right", "left"
            deltaDistance = pxVal + distance
            $(@inner).css('transform', "translateX(-#{deltaDistance}px)")
          when "up", "down"
           return false

      ).on("dragend", (ev) =>
        ev.preventDefault()

        @inner.classList.remove('no-transition')
        @inner.classList.add('drag-transition')
        ## remove drag-transiton after transition completes
        setTimeout (=>
          @inner.classList.remove 'drag-transition'
        ), 600

        switch ev.gesture.direction
          when "right"
            ev.gesture.stopDetect()
            @slideNext("prev")
          when "left"
            ev.gesture.stopDetect()
            @slideNext("next")
      ).on('pinch', =>
        ev.preventDefault()
      )

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
        when arrow.down, arrow.up
          @toggleDrawer()
      mixpanel.track("Key Press")

  ## Setup event listener on resize and set global variable
  watchViewportWidth: ->
    @viewportW = @getViewportW()

    onResize = () =>
      @viewportW = @getViewportW()
      @setInnerWidth()
      @recalculatePos()

    ## Resize after user stops resizing
    $(window).bind "resize", ->
      timer and clearTimeout(timer)
      timer = setTimeout(onResize, 500)

  getViewportW: ->
    document.documentElement.clientWidth

  ## Fix panel positioning
  recalculatePos: ->
    $current = @container.getElementsByClassName('active')
    index    = $(@sections).index($current)
    pxVal    = Math.floor (@viewportW * index) * (90/100)
    $(@inner).css('transform', "translateX(-#{pxVal}px)")

  readHash: ->
    hashes = []
    hash = window.location.hash
    for section in @sections
      hashes.push("##{section.getAttribute('data-id')}")

    # Only slide if hash is in the DOM
    unless hashes.indexOf(hash) is -1
      @slideToTarget(hash) unless hash.length is 0

  changeHash: (target) ->
    id = $(target).attr('data-id')
    History.replaceState({state:1}, "#{id}", "##{id}") if id

    ## Report to Analytics
    _gaq.push ["_trackPageview", location.pathname + location.search + location.hash]
    mixpanel.track(id)

$ ->
  new ConstructSlider()
