class ConstructSlider
  constructor: () ->
    # @nav       = document.getElementsByClassName('slider-nav')[0]
    # @sections  = @inner.getElementsByTagName('section')
    @navWork = document.getElementById('nav-work')
    @navAbout = document.getElementById('nav-about')
    @pathname = window.location.pathname
    @setInnerWidth()

  setInnerWidth: ->
    if @pathname is "/about"
      console.log("about")
      @navAbout.classList.add('active')
      @navWork.classList.remove('active')
    else
      console.log("work")
      @navAbout.classList.remove('active')
      @navWork.classList.add('active')
$ ->
  new ConstructSlider()
